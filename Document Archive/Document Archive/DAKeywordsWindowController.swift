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
    var tags : [DATag] = []

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
        tags = appdelegate.allTags()
        outlineView.reloadData()
    }
    
    
    // MARK: - Data source methods for outline view with tags
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let tag = item as? DATag {
 //           return tag.narrower[index]
        }
        return tags[index]
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return false;
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        return tags.count;
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        return item;
    }
    
    func outlineView(outlineView: NSOutlineView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) {
        
    }
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        var v = outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView
        if let tag = item as? DATag {
            if let tf = v.textField {
                tf.stringValue = tag.label
            }
        }
        return v
    }
}
