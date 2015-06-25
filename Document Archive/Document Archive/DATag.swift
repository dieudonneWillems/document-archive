//
//  DATag.swift
//  Document Archive
//
//  Created by Don Willems on 22/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Foundation
import CoreData

class DATag: NSManagedObject {

    @NSManaged var label: String
    @NSManaged var broader: NSSet
    @NSManaged var narrower: NSSet
    @NSManaged var sameAs: NSSet
    @NSManaged var files: NSSet
    @NSManaged var proposedForFiles: NSSet
}


extension DATag {
    
    func broaderTags() -> [DATag] {
        var broaderArray = broader.allObjects as! [DATag]
        broaderArray.sort({$0.label < $1.label})
        return broaderArray
    }
    
    func addBroaderTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(broader as Set<NSObject>)
        nset.addObject(tag)
        broader = nset
    }
    
    func removeBroaderTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(broader as Set<NSObject>)
        nset.removeObject(tag)
        broader = nset
    }
    
    func narrowerTags() -> [DATag] {
        var narrowerArray = narrower.allObjects as! [DATag]
        narrowerArray.sort({$0.label < $1.label})
        return narrowerArray
    }
    
    func addNarrowerTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(narrower as Set<NSObject>)
        nset.addObject(tag)
        narrower = nset
    }
    
    func removeNarrowerTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(narrower as Set<NSObject>)
        nset.removeObject(tag)
        narrower = nset
    }
    
    func synonyms() -> [DATag] {
        var synonyms = sameAs.allObjects as! [DATag]
        synonyms.sort({$0.label < $1.label})
        return synonyms
    }
    
    func addSynonym(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(sameAs as Set<NSObject>)
        nset.addObject(tag)
        sameAs = nset
    }
    
    func removeSynonym(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(sameAs as Set<NSObject>)
        nset.removeObject(tag)
        sameAs = nset
    }
    
    func addFile(file:DAFile) {
        var nset = NSMutableSet()
        nset.setSet(files as Set<NSObject>)
        nset.addObject(file)
        files = nset
    }
    
    func removeFile(tag:DAFile) {
        var nset = NSMutableSet()
        nset.setSet(files as Set<NSObject>)
        nset.removeObject(tag)
        files = nset
    }
    
    func addProposedFile(file:DAFile) {
        var nset = NSMutableSet()
        nset.setSet(proposedForFiles as Set<NSObject>)
        nset.addObject(file)
        proposedForFiles = nset
    }
    
    func removeProposedFile(tag:DAFile) {
        var nset = NSMutableSet()
        nset.setSet(proposedForFiles as Set<NSObject>)
        nset.removeObject(tag)
        proposedForFiles = nset
    }
}
