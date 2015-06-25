//
//  DATag.swift
//  Document Archive
//
//  Created by Don Willems on 22/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Foundation
import CoreData
import Cocoa

class DATag: NSManagedObject {

    @NSManaged var label: String
    @NSManaged var broader: NSSet
    @NSManaged var narrower: NSSet
    @NSManaged var sameAs: NSSet
    @NSManaged var files: NSSet
    @NSManaged var proposedForFiles: NSSet
    @NSManaged var colour : NSColor
}


extension DATag {
    
    /**
    Returns an array with all broader (parent) tags that are root tags.
    This function is recursive and returns the broader terms which do not have
    broader terms themselves.
    
    :returns: All root tags.
    */
    func rootTags() -> [DATag] {
        var roottags = [DATag]()
        if broader.count == 0 {
            roottags.append(self)
        } else {
            for parent in broader {
                let broot = parent.rootTags()
                for root in broot {
                    if !contains(roottags, root) {
                        roottags.append(root)
                    }
                }
            }
        }
        return roottags
    }
    
    
    /**
    Checks whether the specified tag is a broader tag of the receiver.
    
    :param: tag The tag to be tested.
    
    :returns: True when the tag is a broader tag, false otherwise.
    */
    func isBroader(tag :DATag) -> Bool {
        for parent in broader {
            if tag === parent {
                return true
            }
            if parent.isBroader(tag) {
                return true
            }
        }
        return false
    }
    
    /**
    Checks whether the specified tag is a narrower tag of the receiver.
    
    :param: tag The tag to be tested.
    
    :returns: True when the tag is a narrower tag, false otherwise.
    */
    func isNarrower(tag :DATag) -> Bool {
        for child in narrower {
            if tag === child {
                return true
            }
            if child.isNarrower(tag) {
                return true
            }
        }
        return false
    }
    
    /**
    Returns an array with all broader (parent) tags of the receiver.
    The array is sorted alphabetically.
    
    :returns: All broader tags.
    */
    func broaderTags() -> [DATag] {
        var broaderArray = broader.allObjects as! [DATag]
        broaderArray.sort({$0.label < $1.label})
        return broaderArray
    }
    
    /**
    Adds a broader (parent) tag to the receiver.
    The specified tag is considered to be the parent of the receiver tag.
    e.g. 'apple' has as broader tag 'fruit'.
    A narrower tag is automatically added with the receiver tag as the narrower tag.
    The hierarchy is checked for circularity.
    
    :param: tag The parent or broader tag.
    */
    func addBroaderTag(tag:DATag) {
        if isNarrower(tag) {
            return
        }
        var nset = NSMutableSet()
        nset.setSet(broader as Set<NSObject>)
        nset.addObject(tag)
        broader = nset
    }
    
    /** 
    Removes the broader tag from the set of broader tags of the receiver.
    
    :param: tag The broader tag to be removed.
    */
    func removeBroaderTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(broader as Set<NSObject>)
        nset.removeObject(tag)
        broader = nset
    }
    
    
    /**
    Returns an array with all narrower (child) tags of the receiver.
    The array is sorted alphabetically.
    
    :returns: All narrower tags.
    */
    func narrowerTags() -> [DATag] {
        var narrowerArray = narrower.allObjects as! [DATag]
        narrowerArray.sort({$0.label < $1.label})
        return narrowerArray
    }
    
    /**
    Adds a narrower (child) tag to the receiver.
    The specified tag is considered to be the child of the receiver tag.
    e.g. 'fruit' has as narrower tag 'apple'.
    A broader tag is automatically added with the receiver tag as the broader tag.
    The hierarchy is checked for circularity.
    
    :param: tag The child or narrower tag.
    */
    func addNarrowerTag(tag:DATag) {
        if isBroader(tag) {
            return
        }
        var nset = NSMutableSet()
        nset.setSet(narrower as Set<NSObject>)
        nset.addObject(tag)
        narrower = nset
    }
    
    
    /**
    Removes the narrower tag from the set of narrower tags of the receiver.
    
    :param: tag The narrower tag to be removed.
    */
    func removeNarrowerTag(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(narrower as Set<NSObject>)
        nset.removeObject(tag)
        narrower = nset
    }
    
    
    /**
    Returns an array with all synonyms of the receiver.
    For instance, "soil" may have as synonym "ground".
    The array is sorted alphabetically.
    
    :returns: All synonyms.
    */
    func synonyms() -> [DATag] {
        var synonyms = sameAs.allObjects as! [DATag]
        synonyms.sort({$0.label < $1.label})
        return synonyms
    }
    
    /**
    Adds a synonym to the set of synonyms of the receiver.
    For instance, "soil" may have as synonym "ground".
    
    :param: tag The tag that is a synonym of the receiver.
    */
    func addSynonym(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(sameAs as Set<NSObject>)
        nset.addObject(tag)
        sameAs = nset
    }
    
    /**
    Removes the synonym from the set of synonym tags of the receiver.
    
    :param: tag The synonym tag to be removed.
    */
    func removeSynonym(tag:DATag) {
        var nset = NSMutableSet()
        nset.setSet(sameAs as Set<NSObject>)
        nset.removeObject(tag)
        sameAs = nset
    }
    
    /**
    Returns all files, including proposed files.
    
    :returns: All files.
    */
    func allFiles() -> [DAFile] {
        var allfiles = [DAFile]()
        //TODO
        let filesarray = files.allObjects as! [DAFile]
        allfiles += filesarray
        for pfile in proposedForFiles {
            if !contains(allfiles, pfile as! DAFile) {
                allfiles.append(pfile as! DAFile)
            }
        }
        return allfiles
    }
    
    /**
    Associates a file with the receiver tag.
    This method should be used when the user manually associates a file with the tag.
    If the file is automatically associated with a tag, the file should be associated
    using the addProposedFile(file:DAFile) method.
    
    :param: file The file to be associated to the tag.
    */
    func addFile(file:DAFile) {
        var nset = NSMutableSet()
        nset.setSet(files as Set<NSObject>)
        nset.addObject(file)
        files = nset
    }
    
    /**
    Removes an associated file from the receiver tag.
    
    :param: tag
    */
    func removeFile(file:DAFile) {
        var nset = NSMutableSet()
        nset.setSet(files as Set<NSObject>)
        nset.removeObject(file)
        files = nset
    }
    
    
    /**
    Proposes a file to be associated with the receiver tag.
    If the file is manualy associated with a tag, the file should be associated
    using the addFile(file:DAFile) method.
    
    :param: file The file to be associated to the tag.
    */
    func addProposedFile(file:DAFile) {
        var nset = NSMutableSet()
        nset.setSet(proposedForFiles as Set<NSObject>)
        nset.addObject(file)
        proposedForFiles = nset
    }
    
    /**
    Removes an proposed associated file from the receiver tag.
    
    :param: tag
    */
    func removeProposedFile(file:DAFile) {
        var nset = NSMutableSet()
        nset.setSet(proposedForFiles as Set<NSObject>)
        nset.removeObject(file)
        proposedForFiles = nset
    }
}
