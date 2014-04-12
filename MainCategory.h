//
//  MainCategory.h
//  BHGDataNew
//
//  Created by baihuogou on 14-4-13.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubCategory;

@interface MainCategory : NSManagedObject

@property (nonatomic, retain) NSString * productCategoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSDate * lastUpdatedStamp;
@property (nonatomic, retain) NSString * linkOneImageUrl;
@property (nonatomic, retain) NSString * linkTwoImageUrl;
@property (nonatomic, retain) NSOrderedSet *subs;
@end

@interface MainCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(SubCategory *)value inSubsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubsAtIndex:(NSUInteger)idx;
- (void)insertSubs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubsAtIndex:(NSUInteger)idx withObject:(SubCategory *)value;
- (void)replaceSubsAtIndexes:(NSIndexSet *)indexes withSubs:(NSArray *)values;
- (void)addSubsObject:(SubCategory *)value;
- (void)removeSubsObject:(SubCategory *)value;
- (void)addSubs:(NSOrderedSet *)values;
- (void)removeSubs:(NSOrderedSet *)values;
@end
