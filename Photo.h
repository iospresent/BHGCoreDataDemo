//
//  Photo.h
//  BHGDataNew
//
//  Created by alex on 23/03/2014.
//  Copyright (c) 2014 baihuogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSString * photoLink;
@property (nonatomic, retain) Item *item;

@end
