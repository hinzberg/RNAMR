//  KeywordRepository.swift
//  RNAMR
//
//  Created by Holger Hinzberg on 01.04.19.
//  Copyright © 2019 Holger Hinzberg. All rights reserved.

import Cocoa

public class KeywordRepository
{
    private var entries = [KeywordEntry]()
    
    public func addEntry(entry:KeywordEntry)
    {
        if self.entries.contains(entry) == false
        {
             self.entries.append(entry)
        }
    }
    
    public func getEntry(at index:Int) -> KeywordEntry
    {
           return self.entries[index]
    }
    
    public func getAllEntries() -> [KeywordEntry]
    {
        return self.entries
    }
    
    public func getActiveEntries() -> [KeywordEntry]
    {
        let actives = self.entries.filter{$0.isActive == true}
        return actives
    }
    
    public func getRandomActiveEntries() -> [KeywordEntry]
    {
        var randActives = [KeywordEntry]()
        let actives = self.entries.filter{$0.isActive == true}
        
        if actives.count > 0
        {
            let index = Int(arc4random_uniform(UInt32(actives.count)))
            randActives.append(actives[index])
        }
        return randActives
    }
    
    public func setAllEntries(entries:[KeywordEntry])
    {
        return self.entries = entries
    }
    
    public func removeEntry(entry:KeywordEntry)
    {
        if let idx = entries.firstIndex(where: { $0 === entry })
        {
            entries.remove(at: idx)
        }
    }
    
    public func count() -> Int
    {
        return self.entries.count
    }
    
}
