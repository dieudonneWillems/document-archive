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
    @IBOutlet weak var searchTF : NSSearchField!
    var tags : [DATag] = []

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.titleVisibility = NSWindowTitleVisibility.Hidden
        self.window!.titlebarAppearsTransparent = true
       // self.window!.styleMask |= NSFullSizeContentViewWindowMask
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.reloadData()
    }
    
    
    // MARK: - Actions
    
    @IBAction func searchFieldTyped(sender: NSSearchField) {
        self.reloadData()
    }
    
    
    // MARK: - Reloading data
    
    func reloadData() {
        let appdelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        var highlightedTags = [DATag]()
        if searchTF.stringValue.isEmpty {
            tags = appdelegate.tagsAccess.rootTags()
        } else {
            let query = searchTF.stringValue
            highlightedTags = appdelegate.tagsAccess.tagsContaining(query)
            if highlightedTags.count > 0 {
                tags.removeAll(keepCapacity: true)
                for htag in highlightedTags {
                    let roots = htag.rootTags()
                    for rtag in roots {
                        if !contains(tags, rtag) {
                            tags.append(rtag)
                        }
                    }
                }
            }
        }
        outlineView.reloadData()
    }
    
    
    // MARK: - Data source methods for outline view with tags
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let tag = item as? DATag {
            return tag.narrowerTags()[index]
        }
        return tags[index]
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if let tag = item as? DATag {
            return (tag.narrowerTags().count > 0)
        }
        return false;
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let tag = item as? DATag {
            return tag.narrowerTags().count
        }
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
            let appdelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            if let tf = v.textField {
                tf.stringValue = tag.label
            }
            if let iv = v.imageView {
                iv.image = appdelegate.tagsAccess.smallTagLabel(tag)
            }
        }
        return v
    }
}
