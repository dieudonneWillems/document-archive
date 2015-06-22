//
//  DAFile.swift
//  Document Archive
//
//  Created by Don Willems on 22/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Foundation
import CoreData

class DAFile: NSManagedObject {

    @NSManaged var path: String
    @NSManaged var creationDate: NSTimeInterval
    @NSManaged var modificationDate: NSTimeInterval
    @NSManaged var source: String
    @NSManaged var title: String
    @NSManaged var documentDate: NSTimeInterval
    @NSManaged var tags: NSSet
    @NSManaged var proposedTags: NSSet
    @NSManaged var thumbnail: NSData

}


extension DAFile {
    
    func addTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(tags as Set<NSObject>)
        nset.addObject(tag)
        tags = nset
    }
    
    func removeTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(tags as Set<NSObject>)
        nset.removeObject(tag)
        tags = nset
    }
    
    func addProposedTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(proposedTags as Set<NSObject>)
        nset.addObject(tag)
        proposedTags = nset
    }
    
    func removeProposedTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(proposedTags as Set<NSObject>)
        nset.removeObject(tag)
        proposedTags = nset
    }
}
