
import UIKit

/* 
pod 'SQLite.swift', '~> 0.11.1'
Add framework
*/

import SQLite

class SQLiteManager: NSObject {

    static let sharedManager = SQLiteManager()
    
    static private let DocumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    static private let dbName = "Project_Name.sqlite3"
    
    private let db =  try? Connection("\(DocumentDirectoryPath)/\(dbName)")
   
    
    //tables
    private let table1 = Table("table_name_1")
    
    //columns
    private let column1 = Expression<Int>("column_name_1")
    private let column2 = Expression<String?>("column_name_2")
    private let column3 = Expression<TimeInterval>("column_name_3")
    
    
    // MARK: CURD / Basic operations
    
    func createTable(name:String)->Bool
    {
        print("Careating table ...")
        
        let table = Table(name)
        
        var create:Statement? = nil
        
        if(table == table1)
        {
            create =  try! db?.run(table.create(ifNotExists: true) { t in
                t.column(column1, primaryKey: .autoincrement)
                t.column(column2, unique:true)
                t.column(column3)
            })
        }
        
        if(create != nil)
        {
            print("Table '\(name)' created ...")
            return true
        }
        
        return false
    }
    
    func checkExistRow(table:Table, whereCondition:Expression<Bool>?) -> Bool
    {
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
