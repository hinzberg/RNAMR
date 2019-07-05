//
//  KeywordViewController.swift
//  RNAMR
//
//  Created by Holger Hinzberg on 01.04.19.
//  Copyright © 2019 Holger Hinzberg. All rights reserved.
//

import Cocoa

class KeywordViewController: NSViewController
{
    @IBOutlet var keywordTextfield: NSTextField!
    @IBOutlet var keywordLabel: NSTextField!
    
    public var keyword = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func setKeyword(filename:String)
    {
        self.keywordTextfield.stringValue = keyword
    }
    
    @IBAction func OkButtonClicked(_ sender: Any)
    {
        self.keyword = self.keywordTextfield.stringValue
        let application = NSApplication.shared
        application.stopModal()
    }
    
    @IBAction func ChancelButtonClicked(_ sender: Any)
    {
        self.keyword = ""
        let application = NSApplication.shared
        application.stopModal()
    }
}
