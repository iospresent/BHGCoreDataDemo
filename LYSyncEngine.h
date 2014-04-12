//
//  LYSyncEngine.h
//  BaiHuiGouData
//
//  Created by baihuogou on 14-3-21.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//
// Required: MainCategory

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreData/CoreData.h>

@class LYSyncEngine;
@class MainCategory;
@class SubCategory;


@interface LYSyncEngine : NSObject

// 引擎需注册KOV以保证该属性可用
@property (atomic, readonly) BOOL syncInProgress;

+ (LYSyncEngine *)sharedEngine;



-(void)SyncUsingOperationBlock:(void(^)(void))operation completionBlock:(void(^)(void))completionBlock;





-(void)startSyncEngineForMainCategoryWithId:(NSString *)catId;

-(void)startSyncEngineForSubCatId:(NSString *)subCatId withMainCat:(MainCategory *)mainCat;

-(void)startSyncEngineForItem:(NSString *)itemId withSubCat:(SubCategory *)subCat;

-(void)establishRelationship:(NSString *)key betweenChild:(NSManagedObject *)child andParent:(NSManagedObject *)parent;





// 获取当前数据最近时间
-(NSString *)dateForEntity:(NSString *)entityName withIdKey:(NSString *)entityIdKey IdValue:(NSString *)entityIdValue;
-(NSString *)dateForEntityObject:(NSManagedObject *)entity withChildRelationshipKey:(NSString *)key;

//将当前数组处理至CoreData

-(void)processDataArray:(NSArray *)dataArray intoCoreDataForEntityObject:(NSManagedObject *)entity withIdKey:(NSString *)entityIdKey;

//从数据库中调出数据
-(NSArray *)loadDataFromCoreDataForEntity:(NSString *)entityName withId:(NSString *)parentId sortUsingIndex:(BOOL)isSorted;



@end
