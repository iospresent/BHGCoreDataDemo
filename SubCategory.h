//
//  SubCategory.h
//  BHGDataNew
//
//  Created by baihuogou on 14-4-13.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MainCategory, ProductItem;

@interface SubCategory : NSManagedObject

@property (nonatomic, retain) NSString * productCategoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * categoryImageUrl;
@property (nonatomic, retain) NSString * linkOneImageUrl;
@property (nonatomic, retain) NSString * linkTwoImageUrl;
@property (nonatomic, retain) NSDate * lastUpdatedStamp;
@property (nonatomic, retain) NSOrderedSet *items;
@property (nonatomic, retain) MainCategory *mainCat;
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
