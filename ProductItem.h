//
//  ProductItem.h
//  BHGDataNew
//
//  Created by baihuogou on 14-4-12.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubCategory;

@interface ProductItem : NSManagedObject

@property (nonatomic, retain) SubCategory *subcat;

@end
