//
//  HHSFileHelper.swift
//  CollectionViewDemo
//
//  Created by Holger Hinzberg on 20.06.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.
//

import Foundation

public class HHFileHelper: NSObject
{
    class func getDocumentsDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as String
        return documentDirectory
    }
    
    func checkIfFolderDoesExists(folder:String, doCreate:Bool) -> Bool
    {
        let isDir:UnsafeMutablePointer<ObjCBool>? = nil
        let exists = FileManager.default.fileExists(atPath: folder, isDirectory: isDir)
        
        if exists == false && doCreate == true
        {
            var error: NSError?
            do
            {
                try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error1 as NSError
            {
                error = error1
            }
            print(error!.localizedDescription)
        }
        return true
    }
    
    func copyFiles(sourceUrls:[URL], toUrl destinationUrl: URL) -> Int
    {
        var copyCounter = 0;
        
        for sourceUrl in sourceUrls
        {
            // Get only the Filename
            let originalFilename = sourceUrl.lastPathComponent;
            // Create an destinationpath with the filename
            let destinationFilename = destinationUrl.path + "/" + originalFilename;
            // Copy from source to destination
            let success = self.copyItemAtPath(sourcePath: sourceUrl.path, toPath: destinationFilename)
            if  success == true
            {
                copyCounter += 1
            }
        }        
        return copyCounter;
    }
    
    func deleteItemAtPath(sourcePath: String?) -> Bool
    {
        var success = true
        
        if let sourcePath = sourcePath
        {
            let fileManager = FileManager.default
            do
            {
                try fileManager.removeItem(atPath: sourcePath)
            }
            catch let error as NSError
            {
                print("Could not delete \(sourcePath) : \(error.localizedDescription)")
                success = false;
            }
        }
        else
        {
            print("Filepath could not be unwrapped. Possible NULL")
            success = false;
        }
        return success
    }
    
    
    func copyItemAtPath(sourcePath: String?, toPath destinationPath: String?) -> Bool
    {
        var success = true
        
        if let sourcePath = sourcePath, let destinationPath = destinationPath
        {
            let fileManager = FileManager.default
            do
            {
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
            }
            catch let error as NSError
            {
                print("Could not copy \(sourcePath) : \(error.localizedDescription)")
                success = false;
            }
        }
        else
        {
            print("Filepath could not be unwrapped. Possible NULL")
            success = false;
        }
        return success
    }
    
    /*
     public func getDesktopUrl() -> NSURL
     {
     let desktopUrl = NSFileManager().URLsForDirectory(.DesktopDirectory, inDomains: .UserDomainMask).first as! NSURL
     return desktopUrl
     }
     
     public func getContentsOfDirectoryAtURL(directory:NSURL, withFileExtention extention:String ) -> [NSURL]
     {
     var content = [NSURL]()
     let files =  self.getContentsOfDirectoryAtURL(directory)
     
     for file in files
     {
     let a = file.pathExtension?.lowercaseString
     let b = extention.lowercaseString
     if (a == b)
     {
     content.append(file)
     }
     }
     return content
     }
     
     // Den kompletten Inhalt eines Verzeichnisses
     // Auch Ordner und verstecke Dateien
     public func getContentsOfDirectoryAtURL(directory:NSURL) -> [NSURL]
     {
     let fileManger = NSFileManager()
     var content = [NSURL]()
     
     let files =  try fileManger.contentsOfDirectoryAtURL(directory, includingPropertiesForKeys: nil, options: nil) as? [NSURL]
     if let files = files
     {
     for file in files
     {
     content.append(file)
     }
     }
     return content
     }
     
     // Alle Ordner unterhalb eines angegebenen Ordners holen
     // Funktioniert aus rekursiev mit Unterordnern
     public func getFolders(rootFolder:String) -> [NSURL]
     {
     var folderurl = NSURL(fileURLWithPath: rootFolder)
     var enumerator = getFolderEnumerator(folderurl!)
     
     var folders =  [NSURL]()
     
     while let url = enumerator?.nextObject() as? NSURL
     {
     folders.append(url)
     }
     return folders
     }
     
     private func getFolderEnumerator(directoryUrl:NSURL) -> NSDirectoryEnumerator?
     {
     let fileManger = NSFileManager()
     let keys = [NSURLIsDirectoryKey]
     
     let handler = {
     (url:NSURL!,error:NSError!) -> Bool in
     print(error.localizedDescription)
     print(url.absoluteString)
     return true
     }
     
     let enumarator = fileManger.enumeratorAtURL(
     directoryUrl, includingPropertiesForKeys:
     keys, options: NSDirectoryEnumerationOptions(), errorHandler:handler)
     
     return enumarator
     }
     */
    
    func getNumberOfImagefilesFromFolder(_ folderURL: URL) -> Int
    {
        var count = 0;
        
        if let urls = self.getImagesfilesURLsFromFolder(folderURL)
        {
            count = urls.count
        }
        return count
    }
    
   func getImagesfilesURLsFromFolder(_ folderURL: URL) -> [URL]?
    {
        let options: FileManager.DirectoryEnumerationOptions =
            [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
        
        let fileManager = FileManager.default
        let resourceValueKeys = [URLResourceKey.isRegularFileKey, URLResourceKey.typeIdentifierKey]
        
        guard let directoryEnumerator = fileManager.enumerator(at: folderURL, includingPropertiesForKeys: resourceValueKeys,
                                                               options: options, errorHandler: { url, error in
                                                                print("`directoryEnumerator` error: \(error).")
                                                                return true
        }) else { return nil }
        
        var urls: [URL] = []
        for case let url as URL in directoryEnumerator
        {
            do {
                let resourceValues = try (url as NSURL).resourceValues(forKeys: resourceValueKeys)
                guard let isRegularFileResourceValue = resourceValues[URLResourceKey.isRegularFileKey] as? NSNumber else { continue }
                guard isRegularFileResourceValue.boolValue else { continue }
                guard let fileType = resourceValues[URLResourceKey.typeIdentifierKey] as? String else { continue }
                guard UTTypeConformsTo(fileType as CFString, "public.image" as CFString) else { continue }
                urls.append(url)
            }
            catch
            {
                print("Unexpected error occured: \(error).")
            }
        }
        return urls
    }
    
    
}
