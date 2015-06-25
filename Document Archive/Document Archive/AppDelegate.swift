//
//  AppDelegate.swift
//  Document Archive
//
//  Created by Don Willems on 19/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        var tags = rootTags()
        for tag in tags {
            println("Retrieved tag: \(tag.label)")
            for broaderTag in tag.broader {
                let bro = broaderTag.label as String
                println("                    -> \(bro)")
            }
            for narrowerTag in tag.narrower {
                let nar = narrowerTag.label as String
                println("                    <- \(nar)")
            }
        }
        
        var stags = tagsBeginningWith("M")
        for tag in stags {
            println("Retrieved tag with 'm': \(tag.label)")
            for broaderTag in tag.broader {
                let bro = broaderTag.label as String
                println("                    -> \(bro)")
            }
            for narrowerTag in tag.narrower {
                let nar = narrowerTag.label as String
                println("                    <- \(nar)")
            }
            println("           colour : \(tag.colour)")
        }
        /*
        var fruit = self.createNewTag("fruit")
        var apple = self.createNewTag("apple", broader: fruit)
        var pear = self.createNewTag("pear", broader: fruit)
        println("Test data APPLE: \(apple)")
        println("Test data FRUIT: \(fruit)")
        var mango = self.createNewTag("mango",broader: fruit)
        mango.colour = NSColor(calibratedRed: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
*/

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
    // MARK: - Core Data object access methods
    
    /**
        Returns all tags in the database. The tags are sorted alphabetically on their label.
    
        :returns: An array containing all tags.
     */
    func allTags() -> [DATag] {
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        var tags = [DATag]()
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
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
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
            tags = fetchResults
        }
        tags.sort({(tag1, tag2) -> Bool in
            return tag1.label < tag2.label
        })
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
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
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
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [DATag] {
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
        let newTag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: self.managedObjectContext!) as! DATag
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
        self.managedObjectContext?.deleteObject(tag)
    }

        
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lapsedpacifist.Document_Archive" in the user's Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        let appSupportURL = urls[urls.count - 1] as! NSURL
        return appSupportURL.URLByAppendingPathComponent("com.lapsedpacifist.Document_Archive")
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Document_Archive", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.) This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        let fileManager = NSFileManager.defaultManager()
        var shouldFail = false
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."

        // Make sure the application files directory is there
        let propertiesOpt = self.applicationDocumentsDirectory.resourceValuesForKeys([NSURLIsDirectoryKey], error: &error)
        if let properties = propertiesOpt {
            if !properties[NSURLIsDirectoryKey]!.boolValue {
                failureReason = "Expected a folder to store application data, found a file \(self.applicationDocumentsDirectory.path)."
                shouldFail = true
            }
        } else if error!.code == NSFileReadNoSuchFileError {
            error = nil
            fileManager.createDirectoryAtPath(self.applicationDocumentsDirectory.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
        }
        
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator?
        if !shouldFail && (error == nil) {
            coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Document_Archive.storedata")
            if coordinator!.addPersistentStoreWithType(NSXMLStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
                coordinator = nil
            }
        }
        
        if shouldFail || (error != nil) {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            if error != nil {
                dict[NSUnderlyingErrorKey] = error
            }
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSApplication.sharedApplication().presentError(error!)
            return nil
        } else {
            return coordinator
        }
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(sender: AnyObject!) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        if let moc = self.managedObjectContext {
            if !moc.commitEditing() {
                NSLog("\(NSStringFromClass(self.dynamicType)) unable to commit editing before saving")
            }
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSApplication.sharedApplication().presentError(error!)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        if let moc = self.managedObjectContext {
            return moc.undoManager
        } else {
            return nil
        }
    }

    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        
        if let moc = managedObjectContext {
            if !moc.commitEditing() {
                NSLog("\(NSStringFromClass(self.dynamicType)) unable to commit editing to terminate")
                return .TerminateCancel
            }
            
            if !moc.hasChanges {
                return .TerminateNow
            }
            
            var error: NSError? = nil
            if !moc.save(&error) {
                // Customize this code block to include application-specific recovery steps.
                let result = sender.presentError(error!)
                if (result) {
                    return .TerminateCancel
                }
                
                let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
                let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
                let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
                let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
                let alert = NSAlert()
                alert.messageText = question
                alert.informativeText = info
                alert.addButtonWithTitle(quitButton)
                alert.addButtonWithTitle(cancelButton)
                
                let answer = alert.runModal()
                if answer == NSAlertFirstButtonReturn {
                    return .TerminateCancel
                }
            }
        }
        // If we got here, it is time to quit.
        return .TerminateNow
    }

}

