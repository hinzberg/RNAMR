//
//  ViewController.swift
//  RNAMR
//
//  Created by Holger Hinzberg on 27.03.19.
//  Copyright © 2019 Holger Hinzberg. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate
{
    @IBOutlet var statusLabel: NSTextField!
    @IBOutlet var sourcePathTextfield: NSTextField!
    @IBOutlet var destinationPathTextfield: NSTextField!
    
    // All the checkboxes
    @IBOutlet var deleteOriginalFilesCheckbox: NSButton!
    @IBOutlet var addPrefixesCheckbox: NSButton!
    @IBOutlet var addSuffixesCheckbox: NSButton!
    @IBOutlet var randomlyChoosePrefixCheckbox: NSButton!
    @IBOutlet var randomlyChooseSuffixCheckbox: NSButton!
    @IBOutlet var insertSpaceBetweenPrefixCheckbox: NSButton!
    @IBOutlet var insertSpaceBetweenSuffixCheckbox: NSButton!
    @IBOutlet var replaceSpacesWithUnderscoresCheckbox: NSButton!
    
    @IBOutlet var prefixesTableView: NSTableView!
    @IBOutlet var suffixesTableView: NSTableView!
    
    private var suffixesRepository = KeywordRepository()
    private var prefixesRepository = KeywordRepository()
    private var selectedEntry:KeywordEntry? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.prefixesTableView.delegate = self
        self.prefixesTableView.dataSource = self
        self.suffixesTableView.delegate = self
        self.suffixesTableView.dataSource = self
        
        self.statusLabel.stringValue = ""
        Config.load()
        self.prefixesRepository.setAllEntries(entries: Config.prefixesArray)
        self.suffixesRepository.setAllEntries(entries: Config.suffixesArray)
        self.setConfigToView()
    }

    private func setConfigToView()
    {
        self.sourcePathTextfield.stringValue = Config.sourcePath
        self.destinationPathTextfield.stringValue = Config.destinationPath
        // All the Checkboxes
        self.deleteOriginalFilesCheckbox.state = BoolToCheckboxState(value: Config.deleteOriginalFiles)
        self.addPrefixesCheckbox.state = BoolToCheckboxState(value: Config.addPrefixes)
        self.addSuffixesCheckbox.state = BoolToCheckboxState(value: Config.addSuffixes)
        self.randomlyChoosePrefixCheckbox.state = BoolToCheckboxState(value: Config.randomlyChoosePrefix)
        self.randomlyChooseSuffixCheckbox.state = BoolToCheckboxState(value: Config.randomlyChooseSuffix)
        self.insertSpaceBetweenPrefixCheckbox.state = BoolToCheckboxState(value: Config.insertSpaceBetweenPrefixesAndFilenames)
        self.insertSpaceBetweenSuffixCheckbox.state = BoolToCheckboxState(value: Config.insertSpaceBetweenSuffixesAndFilenames)
        self.replaceSpacesWithUnderscoresCheckbox.state = BoolToCheckboxState(value: Config.replaceSpacesWithUnderscores)
    }
    
    override func viewDidDisappear()
    {
        self.saveConfig()
    }
    
    func saveConfig()
    {
        Config.sourcePath = self.sourcePathTextfield.stringValue
        Config.destinationPath = self.destinationPathTextfield.stringValue
        // All the Checkboxes
        Config.deleteOriginalFiles  = CheckboxStateToBool(value: self.deleteOriginalFilesCheckbox.state)
        Config.addPrefixes = CheckboxStateToBool(value: self.addPrefixesCheckbox.state)
        Config.addSuffixes = CheckboxStateToBool(value:self.addSuffixesCheckbox.state )
        Config.randomlyChoosePrefix = CheckboxStateToBool(value: self.randomlyChoosePrefixCheckbox.state)
        Config.randomlyChooseSuffix  = CheckboxStateToBool(value: self.randomlyChooseSuffixCheckbox.state)
        Config.insertSpaceBetweenPrefixesAndFilenames = CheckboxStateToBool(value: self.insertSpaceBetweenPrefixCheckbox.state)
        Config.insertSpaceBetweenSuffixesAndFilenames = CheckboxStateToBool(value: self.insertSpaceBetweenSuffixCheckbox.state)
        Config.replaceSpacesWithUnderscores = CheckboxStateToBool(value: self.replaceSpacesWithUnderscoresCheckbox.state)
        Config.prefixesArray = self.prefixesRepository.getAllEntries()
        Config.suffixesArray = self.suffixesRepository.getAllEntries()
        Config.save()
    }
    
    // Connected with all the checkboxes on the view
    @IBAction func checkboxClicked(_ sender: Any)
    {
        self.saveConfig()
    }
    
    @IBAction func sourcePathButtonClicked(_ sender: Any)
    {
        if let url = self.openFileDialog()
        {
            self.sourcePathTextfield.stringValue = url.path
            self.saveConfig()
        }
    }
    
    @IBAction func destinationPathButtonClicked(_ sender: Any)
    {
        if let url = self.openFileDialog()
        {
            self.destinationPathTextfield.stringValue = url.path
            self.saveConfig()
        }
    }
    
    func openFileDialog() -> URL?
    {
        let fileDialog = NSOpenPanel()
        fileDialog.canChooseFiles = false
        fileDialog.canChooseDirectories = true
        fileDialog.runModal()
        return fileDialog.url
    }
    
    // MARK:- TableView Methods
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        if tableView == self.suffixesTableView
        {
           return self.suffixesRepository.count()
        }
        
        if tableView == self.prefixesTableView
        {
            return self.prefixesRepository.count()
        }
        return 0
    }
    
    func getEntry(at index:Int, forTableView tableView:NSTableView) -> KeywordEntry?
    {
        var entry:KeywordEntry? = nil
        
        if tableView == self.suffixesTableView
        {
            entry = self.suffixesRepository.getEntry(at: index)
        }
        else if tableView == self.prefixesTableView
        {
            entry = self.prefixesRepository.getEntry(at: index)
        }
        return entry
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        let entry:KeywordEntry? = self.getEntry(at: row, forTableView: tableView)
        guard entry != nil  else
        {
            return "" as AnyObject
        }
        
        if let identifier = tableColumn?.identifier
        {
            if identifier.rawValue == "Active"
            {
                return entry!.isActive as AnyObject
            }
            else if identifier.rawValue == "Keyword"
            {
                return entry!.keyword as AnyObject
            }
        }
        
        return "" as AnyObject
    }
    
    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool
    {
        return false
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool
    {
        self.selectedEntry = self.getEntry(at: row, forTableView: tableView)
        return true
    }
    
    // MARK:- Tablecell Checkboxes clicked
    
    @IBAction func prefixesTableViewColumCellClicked(sender: NSButtonCell)
    {
        if let entry = self.selectedEntry
        {
           entry.isActive  = !entry.isActive
           self.prefixesTableView.reloadData()
        }
    }
    
    @IBAction func suffixesTableViewColumCellClicked(sender: NSButtonCell)
    {
        if let entry = self.selectedEntry
        {
            entry.isActive  = !entry.isActive
            self.suffixesTableView.reloadData()
        }
    }
    
    // MARK:- Keyword Table Buttons
    
    @IBAction func addPrefixButtonClicked(_ sender: Any)
    {
        let keyword:String = self.showKeywordEntryView(keyword: "")
        if keyword != ""
        {
            let entry = KeywordEntry();
            entry.keyword = keyword
            entry.isActive = true
            self.prefixesRepository.addEntry(entry: entry)
            self.prefixesTableView.reloadData()
        }
    }
    
    @IBAction func deletePrefixButtonClicked(_ sender: Any)
    {
        let row:Int = self.prefixesTableView.selectedRow;
        if row > -1
        {
            let entry:KeywordEntry = self.prefixesRepository.getEntry(at:row)
            self.prefixesRepository.removeEntry(entry: entry)
            self.prefixesTableView.reloadData()
        }
    }
    
    @IBAction func addSuffixButtonClicked(_ sender: Any)
    {
        let keyword:String = self.showKeywordEntryView(keyword: "")
        if keyword != ""
        {
            let entry = KeywordEntry();
            entry.keyword = keyword
            entry.isActive = true
            self.suffixesRepository.addEntry(entry: entry)
            self.suffixesTableView.reloadData()
        }
    }
    
    @IBAction func deleteSuffixButtonClicked(_ sender: Any)
    {
        let row:Int = self.suffixesTableView.selectedRow;
        if row > -1
        {
            let entry:KeywordEntry = self.suffixesRepository.getEntry(at:row)
            self.suffixesRepository.removeEntry(entry: entry)
            self.suffixesTableView.reloadData()
        }
    }
    
    private func showKeywordEntryView(keyword:String) -> String
    {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        // WindowController
        let keywordWindowController = storyboard.instantiateController(withIdentifier: "Keyword_Window") as? NSWindowController
        // ViewController
        let keywordViewController = keywordWindowController?.contentViewController as? KeywordViewController
        // Show Modal Window
        let application = NSApplication.shared
        application.runModal(for: (keywordWindowController?.window)!)
        // Close the Window
        keywordWindowController?.window?.close()
       
        return keywordViewController!.keyword
    }
    
    // MARK:- RenameAction
    
    @IBAction func renameButtonClicked(_ sender: NSButton)
    {
        var prefixes = [KeywordEntry]()
        var suffixes = [KeywordEntry]()
        
        if Config.randomlyChoosePrefix == true
        {
           prefixes = self.prefixesRepository.getRandomActiveEntries()
        }
        else
        {
            prefixes = self.prefixesRepository.getActiveEntries()
        }
        
        if Config.randomlyChooseSuffix == true
        {
            suffixes = self.suffixesRepository.getRandomActiveEntries()
        }
        else
        {
            suffixes = self.suffixesRepository.getActiveEntries()
        }
        
        let deleteOriginal:Bool = Config.deleteOriginalFiles
        
        let rename = FileRenamer()
        let count = rename.renameFiles(prefixes: prefixes, suffixes: suffixes, deleteOriginal: deleteOriginal)
        self.statusLabel.stringValue = "\(count) files renamed"    
    }
}

