//  Config.swift
//  Created by Holger Hinzberg on 2019-03-27.
//  Copyright © 2019 Holger Hinzberg. All rights reserved.

import Cocoa

class Config
{
    static var sourcePath:String = ""
    static var destinationPath:String = ""
    static var deleteOriginalFiles:Bool = false;
    static var addPrefixes:Bool = false;
    static var addSuffixes:Bool = false;
    static var randomlyChoosePrefix:Bool = false;
    static var randomlyChooseSuffix:Bool = false;
    static var insertSpaceBetweenPrefixesAndFilenames:Bool = false;
    static var insertSpaceBetweenSuffixesAndFilenames:Bool = false;
    static var replaceSpacesWithUnderscores:Bool = false;
    
    static var suffixesArray = [KeywordEntry]()
    static var prefixesArray = [KeywordEntry]()
    
    static private let sourcePathKey = "sourcePathKey"
    static private let destinationPathKey = "destinationPathKey"
    static private let deleteOriginalFilesPathKey = "deleteOriginalFilesPathKey"
    static private let addPrefixesPathKey = "addPrefixesPathKey"
     static private let addSuffixesPathKey = "addSuffixesPathKey"
    static private let randomlyChoosePrefixPathKey = "randomlyChoosePrefixPathKey"
    static private let randomlyChooseSuffixPathKey = "randomlyChooseSuffixPathKey"
    static private let insertSpaceBetweenPrefixesAndFilenamesPathKey = "insertSpaceBetweenPrefixesAndFilenamesPathKey"
    static private let insertSpaceBetweenSuffixesAndFilenamesPathKey = "insertSpaceBetweenSuffixesAndFilenamesPathKey"
    static private let replaceSpacesWithUnderscoresPathKey = "replaceSpacesWithUnderscoresPathKey"
    static let suffixesArrayKey = "suffixesArrayKey"
    static let prefixesArrayKey = "prefixesArrayKey"
    
    private static func ReadStringValue(defaults:UserDefaults, forKey:String) -> String?
    {
        let data:AnyObject? = defaults.object(forKey: forKey) as AnyObject
        if data != nil && data is String
        {
            let value = data as! String
            return value
        }
        return nil
    }
    
    private static func ReadBoolValue(defaults:UserDefaults, forKey:String) -> Bool?
    {
        let data:AnyObject? = defaults.object(forKey: forKey) as AnyObject
        if data != nil && data is Bool
        {
            let value = data as! Bool
            return value
        }
        return nil
    }
    
    static func load()
    {
        let defaults = UserDefaults.standard
        
        if let value = self.ReadStringValue(defaults: defaults, forKey: sourcePathKey)
        {
            self.sourcePath = value
        }
        
        if let value = self.ReadStringValue(defaults: defaults, forKey: destinationPathKey)
        {
            self.destinationPath = value
        }
        
        if let value = self.ReadBoolValue(defaults: defaults, forKey: deleteOriginalFilesPathKey)
        {
            self.deleteOriginalFiles = value
        }

        if let value = self.ReadBoolValue(defaults: defaults, forKey: replaceSpacesWithUnderscoresPathKey)
        {
            self.replaceSpacesWithUnderscores = value
        }
        
        // Options for Prefixes only
        
        if let value = self.ReadBoolValue(defaults: defaults, forKey: addPrefixesPathKey)
        {
            self.addPrefixes = value
        }

        if let value = self.ReadBoolValue(defaults: defaults, forKey: randomlyChoosePrefixPathKey)
        {
            self.randomlyChoosePrefix = value
        }
        
        if let value = self.ReadBoolValue(defaults: defaults, forKey: insertSpaceBetweenPrefixesAndFilenamesPathKey)
        {
            self.insertSpaceBetweenPrefixesAndFilenames = value
        }
        
        // Options for Suffixes only
        
        if let value = self.ReadBoolValue(defaults: defaults, forKey: addSuffixesPathKey)
        {
            self.addSuffixes = value
        }
        
        if let value = self.ReadBoolValue(defaults: defaults, forKey: randomlyChooseSuffixPathKey)
        {
            self.randomlyChooseSuffix = value
        }
        
        if let value = self.ReadBoolValue(defaults: defaults, forKey: insertSpaceBetweenSuffixesAndFilenamesPathKey)
        {
            self.insertSpaceBetweenSuffixesAndFilenames = value
        }
        
        // The two Arrays
        do
        {
            if let prefixData = defaults.object(forKey: prefixesArrayKey) as? NSData
            {
                let savedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(prefixData as Data) as? [KeywordEntry]
                if let savedArray = savedData
                {
                    self.prefixesArray = savedArray
                }
            }
        }
        catch
        {
            // todo
        }
        
        do
        {
            if let suffixData = defaults.object(forKey: suffixesArrayKey) as? NSData
            {
                let savedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(suffixData as Data) as? [KeywordEntry]
                if let savedArray = savedData
                {
                    self.suffixesArray = savedArray
                }
            }
        }
        catch
        {
            // todo
        }
    }
    
    static  func save()
    {
        let defaults = UserDefaults.standard
        defaults.set(self.sourcePath, forKey: self.sourcePathKey)
        defaults.set(self.destinationPath, forKey: self.destinationPathKey)
        defaults.set(self.deleteOriginalFiles, forKey: self.deleteOriginalFilesPathKey)
        defaults.set(self.replaceSpacesWithUnderscores, forKey: self.replaceSpacesWithUnderscoresPathKey)
        // Options for Prefixes
        defaults.set(self.addPrefixes, forKey: self.addPrefixesPathKey)
        defaults.set(self.randomlyChoosePrefix, forKey: self.randomlyChoosePrefixPathKey)
        defaults.set(self.insertSpaceBetweenPrefixesAndFilenames, forKey: self.insertSpaceBetweenPrefixesAndFilenamesPathKey)
        // Options for Suffixes
        defaults.set(self.addSuffixes, forKey: self.addSuffixesPathKey)
        defaults.set(self.randomlyChooseSuffix, forKey: self.randomlyChooseSuffixPathKey)
        defaults.set(self.insertSpaceBetweenSuffixesAndFilenames, forKey: self.insertSpaceBetweenSuffixesAndFilenamesPathKey)
        
        // The two Arrays
        do
        {
            let prefixData = try NSKeyedArchiver.archivedData(withRootObject: self.prefixesArray, requiringSecureCoding: false)
            defaults.set(prefixData, forKey: prefixesArrayKey)
            
            let suffixData = try NSKeyedArchiver.archivedData(withRootObject: self.suffixesArray, requiringSecureCoding: false)
            defaults.set(suffixData, forKey: suffixesArrayKey)
        }
        catch
        {
            //todo
        }
    }
}
