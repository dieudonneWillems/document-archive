//
//  DAFile.h
//  Document Archive
//
//  Created by Don Willems on 21/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DATag;

@interface DAFile : NSManagedObject

@property (nonatomic, retain) NSString * path;
@property (nonatomic) NSTimeInterval creationDate;
@property (nonatomic) NSTimeInterval modificationDate;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) DATag *tags;

@end
