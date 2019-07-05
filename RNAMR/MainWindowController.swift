//
//  MainWindowController.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 17.01.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad()
    {
        super.windowDidLoad()
        var infoDictionary = Bundle.main.infoDictionary! as Dictionary
        let currentVersion:String = infoDictionary["CFBundleShortVersionString"] as! String
        self.window?.title = "RNAMER Version " + currentVersion
    }
}
