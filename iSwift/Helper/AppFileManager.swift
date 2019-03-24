//
//  AppFileManager.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 24/03/19.
//  Copyright © 2019 yantrana. All rights reserved.
//

import Foundation

class AppFileManager: NSObject
{
    @objc static let shared = BRFileManager()
    
    // MARK: Core
    
    func createFolderInDocumentsDirectory(folder:String) -> URL?
    {
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        
        let directoryUrl = documentsUrl.appendingPathComponent(folder)
        
        if !(self.fileExists(atUrl: directoryUrl))
        {
            do
            {
                try FileManager.default.createDirectory(atPath: directoryUrl.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch let createError
            {
                print("Error creating directory: \(createError.localizedDescription)")
                return nil
            }
        }
        
        return directoryUrl
    }
    
    func getDocumentDirectoryPathForComponent(pathComponent:String) -> URL
    {
        // We are using rather absolute path
        if pathComponent.hasPrefix("/") {
            return URL(fileURLWithPath: pathComponent)
        }
        
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        
        return documentsUrl.appendingPathComponent(pathComponent)
    }
    
    func contentsOfDirectory(directory:String, isRelative:Bool) -> [URL]
    {
        var fileURL:URL? = nil
        if isRelative {
            fileURL = getDocumentDirectoryPathForComponent(pathComponent: directory)
        }else{
            fileURL = URL.init(string: directory)
        }
        
        if fileURL != nil
        {
            do {
                let files = try FileManager.default.contentsOfDirectory(at: fileURL!, includingPropertiesForKeys: nil, options: [])
                return files
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }
        
        return []
    }
    
    func clearAllFilesFrom(directory:String, isRelative:Bool)
    {
        let contents = contentsOfDirectory(directory: directory, isRelative: isRelative)
        
        if contents.count > 0
        {
            if contents.count > 0
            {
                for contentPath in contents
                {
                    do {
                        try FileManager.default.removeItem(atPath: contentPath.path)
                    } catch let removeError {
                        print("Error removing directory: \(removeError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func removeFile(atPath:String, isRelative:Bool) -> Bool
    {
        var filePath = atPath
        if isRelative {
            filePath = BRFileManager.shared.getDocumentDirectoryPathForComponent(pathComponent: atPath).path
        }
        
        do
        {
            try FileManager.default.removeItem(atPath: filePath)
            return true
        }
        catch let removeError
        {
            print("Error removing directory: \(removeError.localizedDescription)")
            return false
        }
    }
    
    func fileExists(atUrl:URL) -> Bool
    {
        return FileManager.default.fileExists(atPath: atUrl.path)
    }
    
    func copyFile(sourceURL:URL, destinaionURL:URL) -> Bool
    {
        _ = self.removeFile(atPath: destinaionURL.path, isRelative: false)
        
        do {
            try FileManager.default.copyItem(at: sourceURL, to: destinaionURL)
            return true
        } catch {
            print("\(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: Media
    
    func saveText(text:String, inDirectory:String, fileName:String) -> String?
    {
        guard let folder = createFolderInDocumentsDirectory(folder: inDirectory) else { return nil }
        
        var name = fileName
        if !((fileName as NSString).contains(".")) {
            name = fileName + ".txt"
        }
        
        let destinationPath = folder.appendingPathComponent(name)
        
        do {
            try text.write(to: destinationPath, atomically: false, encoding: .utf8)
            return "%HOME/" + inDirectory + "/" + name
        }
        catch {
            print("\(error.localizedDescription)")
            return nil
        }
    }
    
    func saveImages(images:[UIImage], inDirectory:String, clearOld:Bool) -> NSArray
    {
        //e.g. inDirectory = "Campaign/Images"
        
        if clearOld {
            clearAllFilesFrom(directory: inDirectory, isRelative: true)
        }
        
        let tempArr = NSMutableArray()
        
        var counter = 1
        
        for image in images
        {
            let imgName = "image" + String(counter)
            var ext = ""
            var imgData:Data? = nil
            if let jpg = UIImageJPEGRepresentation(image, 1.0)
            {
                ext = "jpg"
                imgData = jpg
            }
            else if let png = UIImagePNGRepresentation(image)
            {
                ext = "png"
                imgData = png
            }
            
            if(imgData != nil)
            {
                guard let folder = createFolderInDocumentsDirectory(folder: inDirectory) else { return tempArr }
                
                let fileName = imgName + "." + ext
                let destinationPath = folder.appendingPathComponent(fileName)
                
                do
                {
                    try imgData?.write(to: destinationPath, options: Data.WritingOptions.atomic)
                    
                    tempArr.add("%HOME/" + inDirectory + "/" + fileName)
                }
                catch (let writeError)
                {
                    print("Error writing file: \(writeError.localizedDescription)")
                }
            }
            
            counter = counter + 1
        }
        
        return tempArr
    }
    
    func saveImage(image:UIImage, inDirectory:String, fileName:String) -> String?
    {
        var name = fileName
        let fName = fileName as NSString
        if fName.contains("."){
            let index = fName.range(of: ".").location
            name = fName.substring(to: index)
        }
        
        var ext = ""
        var imgData:Data? = nil
        if let jpg = UIImageJPEGRepresentation(image, 1.0)
        {
            ext = "jpg"
            imgData = jpg
        }
        else if let png = UIImagePNGRepresentation(image)
        {
            ext = "png"
            imgData = png
        }
        
        if imgData != nil
        {
            guard let folder = BRFileManager.shared.createFolderInDocumentsDirectory(folder: inDirectory) else { return nil }
            
            name = name + "." + ext
            let destinationPath = folder.appendingPathComponent(name)
            
            do{
                try imgData?.write(to: destinationPath, options: Data.WritingOptions.atomic)
                
                return "%HOME/" + inDirectory + "/" + name
            }
            catch let error{
                print(error.localizedDescription)
                return nil
            }
        }
        
        return nil
    }
    
    @objc func getImage(imagePath:String, isRelative:Bool) -> UIImage?
    {
        var fileURL:URL? = nil
        
        if isRelative
        {
            let component = (imagePath as NSString).replacingOccurrences(of: "%HOME/", with: "")
            
            fileURL = self.getDocumentDirectoryPathForComponent(pathComponent: component)
        } else {
            fileURL = URL.init(string: imagePath)
        }
        
        if fileURL != nil
        {
            do
            {
                let imageData = try Data.init(contentsOf: fileURL!)
                return UIImage.init(data: imageData)
            }
            catch let readError
            {
                print("Error reading file: \(readError.localizedDescription)")
                return nil
            }
        }
        
        return nil
    }
    
    func saveVideo(data:Data, inDirectory:String, fileName:String) -> String?
    {
        guard let folder = createFolderInDocumentsDirectory(folder: inDirectory) else { return nil }
        
        do {
            let destinationPath = folder.appendingPathComponent(fileName)
            try data.write(to: destinationPath, options: Data.WritingOptions.atomic)
            
            return "%HOME/" + inDirectory + "/" + fileName
        }
        catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getVideo(videoPath:String, isRelative:Bool, returnData:Bool) -> Any?
    {
        var fileURL:URL? = nil
        
        if isRelative {
            let vidPath = (videoPath as NSString).replacingOccurrences(of: "%HOME/", with: "")
            
            fileURL = BRFileManager.shared.getDocumentDirectoryPathForComponent(pathComponent: vidPath)
        } else {
            fileURL = URL.init(string: videoPath)
        }
        
        if returnData, fileURL != nil
        {
            do {
                let videoData = try Data.init(contentsOf: fileURL!)
                return videoData
            }
            catch let error{
                print("\(error.localizedDescription)")
                return nil
            }
        }
        else {
            return fileURL
        }
    }
    
    func saveObject(anObject:Any, inDirectory:String, fileName:String) -> Bool
    {
        guard let folder = BRFileManager.shared.createFolderInDocumentsDirectory(folder: inDirectory) else { return false }
        
        let destinationPath = folder.appendingPathComponent(fileName)
        let data = NSKeyedArchiver.archivedData(withRootObject: anObject)
        
        do {
            try data.write(to: destinationPath)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getObject(objectPath:String, isRelative:Bool) -> Any?
    {
        var fileURL:URL? = nil
        
        if isRelative {
            let vidPath = (objectPath as NSString).replacingOccurrences(of: "%HOME/", with: "")
            
            fileURL = BRFileManager.shared.getDocumentDirectoryPathForComponent(pathComponent: vidPath)
        } else {
            fileURL = URL.init(string: objectPath)
        }
        
        if fileURL != nil
        {
            do
            {
                let data = try Data.init(contentsOf: fileURL!)
                return NSKeyedUnarchiver.unarchiveObject(with: data)
            }
            catch let error
            {
                print("\(error.localizedDescription)")
                return nil
            }
        }
        
        return nil
    }
    
    func createAndSavePDF(printFormatter:UIPrintFormatter, fileName:String) -> URL
    {
        let render = UIPrintPageRenderer()
        
        render.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let paper = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = paper.insetBy(dx: 0, dy: 0)
        render.setValue(paper, forKey: "paperRect")
        render.setValue(printable, forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage();
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext();
        
        let saveToUrl = getDocumentDirectoryPathForComponent(pathComponent: fileName)
        
        pdfData.write(to: saveToUrl, atomically: true)
        
        return saveToUrl
    }
    
    func saveHtml(text:String, fileName:String) -> URL?
    {
        let saveToUrl = getDocumentDirectoryPathForComponent(pathComponent: fileName)
        
        do {
            try text.write(to: saveToUrl, atomically: true, encoding: String.Encoding.utf8)
            return saveToUrl
        } catch {
            print("HTML write error :: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    // MARK: Remote
    
    func download(url:URL, name:String, completion:@escaping (_ fileURL:URL?, _ error:Error?) -> Void)
    {
        var fileName = name
        if (name as NSString).contains(".")
        {
            let tempArr = (name as NSString).components(separatedBy: ".")
            if tempArr.count == 2
            {
                let ext = tempArr.last
                if url.pathExtension != ext
                {
                    fileName = tempArr.first! + "." + url.pathExtension
                }
            }
        }
        else
        {
            fileName = name + url.pathExtension
        }
        
        guard let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil,nil)
            return
        }
        
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)
        
        if self.fileExists(atUrl: destinationFileUrl)
        {
            completion(destinationFileUrl,nil)
        }
        else
        {
            URLSession.shared.downloadTask(with: url, completionHandler: { (tempLocalURL, response, error) in
                
                if let tempLocalUrl = tempLocalURL, error == nil
                {
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        completion(destinationFileUrl,nil)
                    } catch (let writeError) {
                        completion(nil,writeError)
                    }
                }
                else
                {
                    completion(nil,error)
                }
            }).resume()
        }
}

