//
//  DAKeywordsWindowController.swift
//  Document Archive
//
//  Created by Don Willems on 24/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Cocoa

class DAKeywordsWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.titleVisibility = NSWindowTitleVisibility.Hidden
        self.window!.titlebarAppearsTransparent = true
        self.window!.styleMask |= NSFullSizeContentViewWindowMask
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
