//
//  KeywordEntry.swift
//  RNAMR
//
//  Created by Holger Hinzberg on 01.04.19.
//  Copyright © 2019 Holger Hinzberg. All rights reserved.
//

import Cocoa

public class KeywordEntry  : NSObject, NSCoding, Comparable
{
    public var isActive:Bool = true
    public var keyword:String = ""
    
    override init()
    {
        self.isActive = false
        self.keyword = ""
    }
    
    public static func < (lhs: KeywordEntry, rhs: KeywordEntry) -> Bool
    {
        return lhs.keyword < rhs.keyword
    }
    
    public static func == (lhs: KeywordEntry, rhs: KeywordEntry) -> Bool
    {
        return lhs.keyword == rhs.keyword
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(isActive, forKey: "isActive")
        aCoder.encode(keyword, forKey: "keyword")
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        self.isActive = aDecoder.decodeBool(forKey:"isActive") as Bool
        self.keyword = aDecoder.decodeObject(forKey: "keyword") as! String
    }
}
