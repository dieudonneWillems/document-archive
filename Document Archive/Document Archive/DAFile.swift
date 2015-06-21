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

}
