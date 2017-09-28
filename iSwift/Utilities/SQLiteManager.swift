//
//  SQLiteManager.swift
//  All List
//
//  Created by Amol Bapat on 20/12/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import UIKit

import SQLite

class SQLiteManager: NSObject {

    static let sharedManager = SQLiteManager()
    
    static private let DocumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    static private let dbName = "All_List.sqlite3"
    private let db =  try? Connection("\(DocumentDirectoryPath)/\(dbName)")
    private let history_limit = 20
    
    //tables
    private let visit_history = Table("visit_history")
    private let notifications = Table ("notifications")
    
    //columns
    private let row_id = Expression<Int>("id")
    private let shop_id = Expression<String?>("shop_id")
    private let shop_name = Expression<String?>("shop_name")
    private let category_name = Expression<String?>("categ_name")
    private let mall_name = Expression<String?>("mall_name")
    
    private let timestamp = Expression<TimeInterval>("timestamp")
    
    private let n_id = Expression<String?>("notification_id")
    private let n_title = Expression<String?>("notification_title")
    private let n_text = Expression<String?>("notification_text")
    private let n_image = Expression<String?>("notification_image")
    private let n_service = Expression<String?>("service_of")
    
    
    // MARK: CURD / Basic operations
    /* e.g.
    _ = SQLiteManager.sharedManager.createTable(name: "visit_history")
    _ = SQLiteManager.sharedManager.createTable(name: "notifications")
    */
    func createTable(name:String)->Bool
    {
        print("Careating table ...")
        
        let table = Table(name)
        
        var create:Statement? = nil
        
        if(name == "visit_history")
        {
            create =  try! db?.run(table.create(ifNotExists: true) { t in
                t.column(row_id, primaryKey: .autoincrement)
                t.column(shop_id, unique:true)
                t.column(shop_name)
                t.column(category_name)
                t.column(mall_name)
                t.column(timestamp)
            })
        }
        else if (name == "notifications")
        {
            create =  try! db?.run(table.create(ifNotExists: true) { t in
                t.column(row_id, primaryKey: .autoincrement)
                t.column(n_id, unique:true)
                t.column(shop_id)
                t.column(n_title)
                t.column(n_text)
                t.column(n_image)
                t.column(n_service)
                t.column(timestamp)
            })
        }
        
        if(create != nil)
        {
            print("Table '\(name)' created ...")
            return true
        }
        else
        {
            
        }
        
        return false
    }
    
    
    /* 
    e.g.
    let condition:Expression<Bool>? = Expression<Bool>(shop_id == data["shopID"] as? String)
    if(checkExistRow(table: visit_history, whereCondition:condition))
    {
    }
    */
    
    func checkExistRow(table:Table, whereCondition:Expression<Bool>?) -> Bool
    {
        print("Checking exist ...")
        
        var alice = table
        
        if(whereCondition != nil)
        {
            alice = table.filter(whereCondition!)
        }
    
        if ((try! db?.pluck(alice)) != nil)
        {
            print("Row exist ...")
            return true
        }
        
        print("Row not exist ...")
        return false
    }
   
    
    /*
    e.g.
    let setterData:[Setter] = [shop_id <- data["shopID"] as? String,
                     shop_name <- data["shopName"] as? String,
                     category_name <- data["categName"] as? String,
                     mall_name <- data["mallName"] as? String,
                     timestamp <- data["timestamp"] as! TimeInterval]
            
    insert(table: visit_history, setter:setterData)
    */
    func insert(table:Table, setter:[Setter]) -> Bool
    {
        do
        {
            print("Inserting ...")
            
            let rowid = try db?.run(table.insert(
                    setter
                ))
            
            print("visit inserted with row id: \(rowid)")
            
            return true
            
        }
        catch
        {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    
    /*
    e.g.
     let data:[Setter] = [shop_name <- data["shopName"] as? String,
                                 category_name <- data["categName"] as? String,
                                 mall_name <- data["mallName"] as? String,
                                 timestamp <- data["timestamp"] as! TimeInterval]
            
     update(table: visit_history, setter: data, whereCondition:condition)
    */
    func update(table:Table, setter:[Setter], whereCondition:Expression<Bool>?) -> Bool
    {
        var alice = table
        
        if(whereCondition != nil)
        {
            alice = table.filter(whereCondition!)
        }
        
        do
        {
            print("Updating ...")
            
            let rowid = try db?.run(alice.update(
                setter
            ))
            
            print("visit updated with row id: \(rowid)")
            
            return true
        }
        catch
        {
            print("Updation failed: \(error)")
            return false
        }
    }
    
    /*
    e.g.
    delete(table: notifications, whereCondition: Expression<Bool>(row_id == notificationID))
    */
    
    func delete(table:Table, whereCondition:Expression<Bool>?) -> Bool
    {
        var alice = table
     
        if(whereCondition != nil)
        {
            alice = table.filter(whereCondition!)
        }
        
        do
        {
            print("Deleting ...")
            
            if (try db?.run(alice.delete()))! > 0 {
                print("Deleted ...")
            } else {
                print("No deletable entry found ...")
            }
            
            return true
            
        }
        catch
        {
            print("Deletion failed: \(error)")
            return false
        }
    }
    
    func truncateTable(name:String) -> Bool
    {
        let table = Table(name)
        
        return delete(table: table, whereCondition: nil)
    }
    
    func dropTable(name:String) -> Bool
    {
        let table = Table(name)
        do
        {
            print("Dropping ...")
            try db?.run(table.drop(ifExists: true))
            print("Dropped \(name)")
            return true
        }
        catch
        {
            print("Dropping failed: \(error)")
            return false
        }
        
    }
    
    // MARK: All List - View History
    
    func processVisitHistory(data:[String:Any]) -> Bool
    {
        let condition:Expression<Bool>? = Expression<Bool>(shop_id == data["shopID"] as? String)
        
        if(checkExistRow(table: visit_history, whereCondition:condition))
        {
            
            let data:[Setter] = [shop_name <- data["shopName"] as? String,
                                 category_name <- data["categName"] as? String,
                                 mall_name <- data["mallName"] as? String,
                                 timestamp <- data["timestamp"] as! TimeInterval]
            
            return update(table: visit_history, setter: data, whereCondition:condition)

        }
        else
        {
            
            if let count = try? db?.scalar(visit_history.count)
            {
                if count! >= history_limit
                {
                    if let min_id = try? db?.scalar(visit_history.select(row_id.min))
                    {
                        _ = delete(table: visit_history, whereCondition: Expression<Bool>(row_id == min_id!))
                    }
                }
            }
            
            let setterData:[Setter] = [shop_id <- data["shopID"] as? String,
                     shop_name <- data["shopName"] as? String,
                     category_name <- data["categName"] as? String,
                     mall_name <- data["mallName"] as? String,
                     timestamp <- data["timestamp"] as! TimeInterval]
            
            return insert(table: visit_history, setter:setterData)
        }
    }
    
    
    
    func getViewHistory() -> Array<[String:String]>?
    {
        do
        {
            if let all = try db?.prepare(visit_history)
            {
                var arr: [Dictionary<String,String>] =  []
                
                for row in all
                {
                    let ts = row[timestamp] as TimeInterval
                    
                    let date = Date.init(timeIntervalSince1970: ts).string(format: "dd MMM yyyy")
                   
                    let time = Date.init(timeIntervalSince1970: ts).string(format: "hh:mm a")
                    
                    arr.append([
                        "shop_id" : row[shop_id]!,
                        "shop_name" : row[shop_name]!,
                        "shop_cat_name" : row[category_name]!,
                        "mall_name" : row[mall_name]!,
                        "visit_date" : date!,
                        "visit_time" : time!
                        ])
                }
                
                return arr
            }
            else
            {
                return nil
            }
        }
        catch
        {
            return nil
        }
    }
    
    
    // MARK: Notification
    
    func processNotification(data:[AnyHashable: Any]) -> Bool
    {
        print("Processing Notification Data ...")
        
        /*
         [
             AnyHashable("gcm.notification.message"): 50% cashback on your first purchase from toyss,
             AnyHashable("gcm.notification.service_of"): offer,
             AnyHashable("gcm.notification.image"): ,
             AnyHashable("gcm.notification.shop_id"): 15,
             AnyHashable("gcm.notification.is_background"): false,
             AnyHashable("gcm.notification.timestamp"): 2016-12-29 16:19:05,
             AnyHashable("aps"):{
                 alert =     {
                     body = "50% cashback on your first purchase from toyss";
                     title = "All List Offers";
                 };
                 badge = 1;
                 "content-available" = 1;
                 sound = default;
             },
             AnyHashable("gcm.message_id"): 0:1483008376415630%f7cf484af7cf484a
         ]
         */
        
        var done:Bool = false
        
        let condition:Expression<Bool>? = Expression<Bool>(n_id == data["gcm.message_id"] as? String)
        
        if(checkExistRow(table: notifications, whereCondition:condition))
        {
            print("Notification already exist ...")
        }
        else
        {
            if let aps = data["aps"] as? NSDictionary
            {
                let title = (aps.value(forKey: "alert") as! NSDictionary).value(forKey: "title") as? String
                
                let text = (aps.value(forKey: "alert") as! NSDictionary).value(forKey: "body") as? String
                
                if(title != nil && text != nil)
                {
                    var ts:TimeInterval = 0
                    
                    if let datetime = data["gcm.notification.timestamp"] as? String
                    {
                        ts = (datetime.date(format: "yyyy:MM:dd HH:mm:ss")?.timeIntervalSince1970)!
                    }
                    
                    let setterData:[Setter] = [
                        n_id <- data["gcm.message_id"] as? String,
                        shop_id <- data["gcm.notification.shop_id"] as? String,
                        n_title <- title,
                        n_text <- text,
                        n_image <- data["gcm.notification.image"] as? String,
                        n_service <- data["gcm.notification.service_of"] as? String,
                        timestamp <- ts
                    ]
                    
                    done = insert(table: notifications, setter:setterData)
                }
            }
        }
        
        return done
    }
    
    func getNotifications() -> NSArray
    {
        do
        {
            if let all = try db?.prepare(notifications)
            {
                var arr: [Dictionary<String,String>] =  []
                
                for row in all
                {
                    let ts = row[timestamp] as TimeInterval
                    
                    let date = Date.init(timeIntervalSince1970: ts).string(format: "dd MMM yyyy")
                    
                    let time = Date.init(timeIntervalSince1970: ts).string(format: "hh:mm a")
                    
                    arr.append([
                        "notification_id" : String(row[row_id]),
                        "shop_id" : row[shop_id]!,
                        "title" : row[n_title]!,
                        "text" : row[n_text]!,
                        "image_name" : row[n_image]!,
                        "service" : row[n_service]!,
                        "date" : date!,
                        "time" : time!
                    ])
                }
                
                return arr as NSArray
            }
            else
            {
                print("Notification not found ...")
                return NSArray()
            }
        }
        catch
        {
            print("Error while getting notification: \(error)")
            return NSArray()
        }
    }
    
    func deleteNotification(notificationID:Int) -> Bool
    {
        return delete(table: notifications, whereCondition: Expression<Bool>(row_id == notificationID))
        
    }
}
