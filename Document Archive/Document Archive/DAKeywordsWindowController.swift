//
//  DAKeywordsWindowController.swift
//  Document Archive
//
//  Created by Don Willems on 24/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Cocoa

class DAKeywordsWindowController: NSWindowController {
    
    @IBOutlet weak var outlineView : NSOutlineView!

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.titleVisibility = NSWindowTitleVisibility.Hidden
        self.window!.titlebarAppearsTransparent = true
        self.window!.styleMask |= NSFullSizeContentViewWindowMask
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.reloadData()
    }
    
    // MARK: - Reloading data
    
    func reloadData() {
        let appdelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        outlineView.reloadData()
    }
    
    
    // MARK: - Data source methods for outline view with tags
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        return "test"
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return false;
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        return 5;
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        return item;
    }
    
    func outlineView(outlineView: NSOutlineView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) {
        
    }
}
