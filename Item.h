//
//  Item.h
//  BHGDataNew
//
//  Created by alex on 23/03/2014.
//  Copyright (c) 2014 baihuogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photoLink;
@property (nonatomic, retain) NSNumber * updatePhoto;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
