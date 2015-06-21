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

    @NSManaged var string: String
    @NSManaged var broader: NSSet
    @NSManaged var narrower: NSSet
    @NSManaged var sameAs: NSSet
    @NSManaged var files: NSSet
    @NSManaged var proposedForFiles: NSSet

}
