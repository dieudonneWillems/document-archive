//
//  DATagsAccess.swift
//  Document Archive
//
//  Created by Don Willems on 26/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Cocoa

class DATagsAccess: NSObject {
    
    // MARK: - Tags as images
    
    /**
    Returns an image with a small circle in the colour of the tag.
    
    :param: tag The tag for which the image is requested.
    
    :returns: The image with the coloured circle.
    */
    func smallTagLabel(tag: DATag) -> NSImage {
        var image = NSImage(size: NSMakeSize(16,16))
        image.lockFocus()
        var colour : NSColor? = tag.colour
        var strokecolor : NSColor = NSColor(deviceHue: 0.0, saturation: 0.0, brightness: 0.5, alpha: 1.0)
        if colour == nil {
            colour = NSColor(deviceHue: 0, saturation: 0, brightness: 0.8, alpha: 0.6)
        }
        strokecolor = colour!.darkerColor()
        let rect = NSMakeRect(4, 2, 8, 8)
        var circle = NSBezierPath(ovalInRect: rect)
        colour!.set()
        circle.fill()
        strokecolor.set()
        circle.stroke()
        image.unlockFocus()
        return image
    }
    
    /**
    Returns an image with the label of the tag encircled by a rounded rectangle in the
    colour of the tag.
    
    :param: tag The tag for which the image is requested.
    :param: textAttributes The text attributes used fro creating the string.
    
    :returns: The image with the coloured tag.
    */
    func namedTagLabel(tag: DATag, textAttributes: [String:AnyObject]) -> NSImage {
        let stringSize = (tag.label as NSString).sizeWithAttributes(textAttributes)
        var image = NSImage(size: stringSize)
        image.lockFocus()
        tag.colour.set()
        let rect = NSMakeRect(0, 0, stringSize.width, stringSize.height)
        var rrect = NSBezierPath(roundedRect: rect, xRadius: 2, yRadius: 2)
        rrect.fill()
        var spoint = NSMakePoint(0, 0)
        (tag.label as NSString).drawAtPoint(spoint, withAttributes: textAttributes)
        image.unlockFocus()
        return image
    }
    
    
    // MARK: - Core Data object access methods
    
    /**
    Returns all tags in the database. The tags are sorted alphabetically on their label.
    
    :returns: An array containing all tags.
    */
    func allTags() -> [DATag] {
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        var tags = [DATag]()
        let appd = NSApplication.sharedApplication().delegate as! AppDelegate
        let moc = appd.managedObjectContext!
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
            tags = fetchResults
        }
        tags.sort({(tag1, tag2) -> Bool in
            return tag1.label < tag2.label
        })
        return tags
    }
    
    
    /**
    Returns all root tags in the database. The tags are sorted alphabetically on their label.
    A root tag is a tag without any broader concepts/tags.
    
    :returns: An array containing all root tags.
    */
    func rootTags() -> [DATag] {
        var fetchRequest = NSFetchRequest(entityName: "Tag")
        let predicate = NSPredicate(format: "broader.@count == 0")
        fetchRequest.predicate = predicate
        var tags = [DATag]()
        let appd = NSApplication.sharedApplication().delegate as! AppDelegate
        let moc = appd.managedObjectContext!
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
            tags = fetchResults
        }
        tags.sort({(tag1, tag2) -> Bool in
            return tag1.label < tag2.label
        })
        return tags
    }
    
    /**
    Returns all tags in the database with a label exactly the same as the string specified in the first parameter :string:.
    
    :param: string The label of the requested tags.
    
    :returns: All tags with label equal to :string:.
    */
    func tagsWithLabel(string :String) -> [DATag] {
        var fetchRequest = NSFetchRequest(entityName: "Tag")
        let predicate = NSPredicate(format: "label == %@", string)
        fetchRequest.predicate = predicate
        var tags = [DATag]()
        let appd = NSApplication.sharedApplication().delegate as! AppDelegate
        let moc = appd.managedObjectContext!
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
            tags = fetchResults
        }
        return tags
    }
    
    /**
    Returns all tags in the database containing the string specified in the first parameter :string:.
    For instance for string 'p' both 'apple' and 'pear' will be returned but not 'mango'.
    The tags are sorted according to the location at which :string: appears in the tag, and if the same
    alphabetically. Tags that start with :string: will therefore appear at the top of the list.
    
    :param: string The string contained in the requested tags.
    
    :returns: All tags containing :string:.
    */
    func tagsContaining(string :String) -> [DATag] {
        var fetchRequest = NSFetchRequest(entityName: "Tag")
        let predicate = NSPredicate(format: "label contains[c] %@", string)
        fetchRequest.predicate = predicate
        var tags = [DATag]()
        let appd = NSApplication.sharedApplication().delegate as! AppDelegate
        let moc = appd.managedObjectContext!
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
            tags = fetchResults
        }
        tags.sort({(tag1, tag2) -> Bool in
            let label1 = tag1.label
            let label2 = tag2.label
            let ex1 = label1.rangeOfString(string)
            let ex2 = label2.rangeOfString(string)
            if ex1 != ex2 {
                return ex1!.startIndex < ex2!.startIndex    // sort according to location of the string in the tag name.
            }
            return label1 < label2 // if the location is the same, sort alphabetically.
        })
        return tags
    }
    
    /**
    Returns all tags in the database starting with the string specified in the first parameter :string:.
    For instance for string 'p' 'pear' will ber returned but not 'apple' or 'mango'.
    The tags are sorted alphabetically
    
    :param: string The string with which the tags need to start to be included in the list.
    
    :returns: All tags starting with :string:.
    */
    func tagsBeginningWith(string :String) -> [DATag] {
        var fetchRequest = NSFetchRequest(entityName: "Tag")
        let predicate = NSPredicate(format: "label beginswith[c] %@", string)
        fetchRequest.predicate = predicate
        var tags = [DATag]()
        let appd = NSApplication.sharedApplication().delegate as! AppDelegate
        let moc = appd.managedObjectContext!
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
            tags = fetchResults
        }
        tags.sort({(tag1, tag2) -> Bool in
            return tag1.label < tag2.label
        })
        return tags
    }
    
    /**
    Creates a new tag with the specified tag name and optionally as a child of the :broader: tag.
    For instance a new tag with name 'apple' can be created with parent 'fruit'.
    
    :param: tagName The name of the tag.
    :param: broader The parent (broader) tag.
    
    :return: The newly created tag.
    */
    func createNewTag(tagName :String, broader: DATag?=nil) -> DATag {
        let appd = NSApplication.sharedApplication().delegate as! AppDelegate
        let moc = appd.managedObjectContext!
        let newTag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: moc) as! DATag
        newTag.label = tagName
        if broader != nil {
            newTag.addBroaderTag(broader!)
        }
        return newTag
    }
    
    
    /**
    Deletes the specified tag from the database.
    
    :param: tag The tag to be deleted.
    */
    func deleteTag(tag: DATag) {
        let appd = NSApplication.sharedApplication().delegate as! AppDelegate
        let moc = appd.managedObjectContext!
        moc.deleteObject(tag)
    }

}
