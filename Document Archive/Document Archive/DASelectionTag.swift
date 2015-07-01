//
//  DASelectionTag.swift
//  Document Archive
//
//  Created by Don Willems on 01/07/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Cocoa

class DASelectionTag :NSObject{
    
    static var currentTags = [DATag : DASelectionTag]()
    
    let tag: DATag
    var tagIcon : NSImage
    var isSearchResult : Bool
    var broader = [DASelectionTag]()
    var narrower = [DASelectionTag]()
    
    class func selectionTag(tag: DATag, isSearchResult: Bool) -> DASelectionTag{
        var test = currentTags[tag]
        var stag : DASelectionTag
        if test == nil {
            stag = DASelectionTag(tag: tag, isSearchResult: false)
        }else {
            stag = test!
        }
        if stag.isSearchResult == false && isSearchResult{
            stag.isSearchResult = true
            stag.addBroader()
            stag.addNarrower()
        }
        return stag
    }
    
    class func resetSelectedTags() {
        currentTags.removeAll(keepCapacity: true)
    }
    
    private init(tag: DATag) {
        self.tag = tag
        isSearchResult = true
        tagIcon = (NSApplication.sharedApplication().delegate as! AppDelegate).tagsAccess.smallTagLabel(tag)
        super.init()
        DASelectionTag.currentTags[tag] = self
    }

    private init(tag: DATag, isSearchResult: Bool) {
        self.tag = tag
        self.isSearchResult = isSearchResult
        tagIcon = (NSApplication.sharedApplication().delegate as! AppDelegate).tagsAccess.smallTagLabel(tag)
        super.init()
        DASelectionTag.currentTags[tag] = self
    }
    
    func rootTags() -> [DASelectionTag] {
        if broader.count <= 0 {
            return [self]
        }
        var roots = [DASelectionTag]()
        for btag in broader {
            let broots = btag.rootTags()
            for broot in broots {
                roots.append(broot)
            }
        }
        return roots
    }
    
    func addBroader() {
        for btag in tag.broader {
            var sbtag = DASelectionTag.selectionTag(btag as! DATag, isSearchResult: false)
            if !contains(broader,sbtag) {
                broader.append(sbtag)
                sbtag.narrower.append(self)
                sbtag.addBroader()
            }
        }
    }
    
    func addNarrower() {
        for btag in tag.narrower {
            var sbtag = DASelectionTag.selectionTag(btag as! DATag, isSearchResult: false)
            if !contains(narrower,sbtag) {
                narrower.append(sbtag)
                sbtag.broader.append(self)
                sbtag.addNarrower()
            }
        }
    }
}
