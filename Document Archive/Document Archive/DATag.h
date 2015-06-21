//
//  DATag.h
//  Document Archive
//
//  Created by Don Willems on 21/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAFile, DATag;

@interface DATag : NSManagedObject

@property (nonatomic, retain) NSString * string;
@property (nonatomic, retain) DATag *broader;
@property (nonatomic, retain) DATag *narrower;
@property (nonatomic, retain) DATag *sameAs;
@property (nonatomic, retain) DAFile *files;

@end
