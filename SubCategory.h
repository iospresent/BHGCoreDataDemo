//
//  SubCategory.h
//  BHGDataNew
//
//  Created by baihuogou on 14-4-12.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MainCategory, ProductItem;

@interface SubCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSOrderedSet *items;
@property (nonatomic, retain) MainCategory *main;
@end

@interface SubCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(ProductItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(ProductItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(ProductItem *)value;
- (void)removeItemsObject:(ProductItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
