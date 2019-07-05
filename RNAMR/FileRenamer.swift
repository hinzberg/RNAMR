//
//  FileRenamer.swift
//  RNAMR
//
//  Created by Holger Hinzberg on 20.04.19.
//  Copyright © 2019 Holger Hinzberg. All rights reserved.
//

import Cocoa

class FileRenamer
{
    func renameFiles(prefixes:[KeywordEntry], suffixes:[KeywordEntry], deleteOriginal:Bool) ->Int
    {
        var copyCounter = 0
        let fileHelper = HHFileHelper()
        
        let destinationFolder = URL(fileURLWithPath: Config.destinationPath)
        let sourceFolder = URL(fileURLWithPath: Config.sourcePath)
        let sourceFilesUrls = fileHelper.getImagesfilesURLsFromFolder(sourceFolder)
        
        for sourceFileUrl in sourceFilesUrls!
        {
            let originalExtention = sourceFileUrl.pathExtension;
            let originalFilename = sourceFileUrl.deletingPathExtension().lastPathComponent;
            let newFilename = createNewFilename(prefixes: prefixes, suffixes: suffixes, originalFilename: originalFilename, originalExtention: originalExtention)
            //print(newFilename)
            let destinationFilePath = destinationFolder.path + "/" + newFilename
            //print(destinationFilePath)
            //print(sourceFileUrl.path)
            
            let success = fileHelper.copyItemAtPath(sourcePath: sourceFileUrl.path, toPath: destinationFilePath)
            if  success == true
            {
                copyCounter += 1
                if deleteOriginal == true
                {
                    let _ = fileHelper.deleteItemAtPath(sourcePath: sourceFileUrl.path)
                }
            }
        }
        
        return copyCounter
    }
    
    private func createNewFilename(prefixes:[KeywordEntry], suffixes:[KeywordEntry], originalFilename:String, originalExtention:String) -> String
    {
        var prefixesPart = ""
        var suffixesPart = ""
        
        for prefix in prefixes
        {
            prefixesPart += prefix.keyword
        }

        if Config.insertSpaceBetweenPrefixesAndFilenames
        {
            prefixesPart += " "
        }
        
        
        if Config.insertSpaceBetweenSuffixesAndFilenames
        {
            suffixesPart += " "
        }
        
        for suffix in suffixes
        {
            suffixesPart += suffix.keyword
        }
        
        var newFilename = "\(prefixesPart)\(originalFilename)\(suffixesPart)"
        newFilename = newFilename.trimmingCharacters(in: .whitespacesAndNewlines)
        newFilename = newFilename + "." + originalExtention
        return newFilename
    }
}
