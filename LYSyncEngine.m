//
//  LYSyncEngine.m
//  BaiHuiGouData
//
//  Created by baihuogou on 14-3-21.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import "LYSyncEngine.h"
#import "MainCategory.h"
#import "AppDelegate.h"

#import "BHLLCDataHelper.h"

#import "Reachability.h"
#import "SubCategory.h"
#import "ProductItem.h"

NSString * const kSyncEngineSyncCompletedNotificationName = @"SyncEngineSyncCompleted";


@interface LYSyncEngine()
@property (nonatomic,strong) NSOperationQueue *queue;
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (nonatomic, strong) NSOperationQueue *imageQueue;
@property (nonatomic, strong) NSOperation *priorCompletionOperation;
@property (nonatomic,strong,readwrite) NSMutableArray *newEntities;
@property (strong,nonatomic) Reachability *networkReachability;
@property (nonatomic,strong,readwrite) NSMutableArray *mostRecentEntitiesToUpdate;


@end

@implementation LYSyncEngine
@synthesize syncInProgress = _syncInProgress;

#pragma mark - lazy Instantiation

-(NSMutableArray *)mostRecentEntitiesToUpdate{
    if (!_mostRecentEntitiesToUpdate) {
        _mostRecentEntitiesToUpdate = [[NSMutableArray alloc]init];
    }
    return _mostRecentEntitiesToUpdate;
}

-(Reachability *)networkReachability{
    if (!_networkReachability) {
        _networkReachability = [Reachability reachabilityForInternetConnection];
    }
    return _networkReachability;
}

-(NSMutableArray *)newEntities{
    if (!_newEntities) {
        _newEntities = [[NSMutableArray alloc]init];
    }
    return _newEntities;
}






-(AppDelegate *)appDelegate{
    if (!_appDelegate) {
        _appDelegate = [[UIApplication sharedApplication]delegate];
    }
    return _appDelegate;
}

+ (LYSyncEngine *)sharedEngine {
    static LYSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[LYSyncEngine alloc] init];
    });
    return sharedEngine;
}


-(NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

-(NSOperationQueue *)imageQueue{
    if (!_imageQueue) {
        _imageQueue = [[NSOperationQueue alloc]init];
    }
    return _imageQueue;
}







// 返回指定Entity的最近一次更新时间（opContext）
- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName usingRequest:(NSFetchRequest *)request{
    __block NSDate *date = nil;
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    [request setFetchLimit:1];
    [self.appDelegate.cdh.opContext performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [self.appDelegate.cdh.opContext executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
    return date;
}

// 编写返回NSMutableURLRequest的方法，从服务器获取在指定日期后的更新数据。

-(void)communicateWithServer{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://itunes.apple.com/search?term=game&limit=100&entity=ebook"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        [ self.appDelegate.cdh.opContext performBlock:^{
            NSArray *result =responseObject[@"results"];
            for (NSDictionary *data in result) {
                MainCategory *mainCat = [NSEntityDescription insertNewObjectForEntityForName:@"MainCategory" inManagedObjectContext:self.appDelegate.cdh.opContext];
                mainCat.categoryName = data[@"categoryName"];
                mainCat.categoryId = data[@"productCategoryId"];
                mainCat.thumbnail = nil;
                mainCat.updatedAt = nil;
            }
            [self.appDelegate.cdh saveOpContext];
            [self.appDelegate.cdh.opContext reset];
        }];
    } failure:^(AFHTTPRequestOperation *operation, id responseObject){
   
        NSLog(@"FAILURE");
    }];
    [self.queue addOperation:operation];
}




-(void)SyncUsingOperationBlock:(void(^)(void))operation completionBlock:(void(^)(void))completionBlock{
    NSBlockOperation *heavyLifting = [NSBlockOperation blockOperationWithBlock:operation];
    NSBlockOperation *temp = [NSBlockOperation blockOperationWithBlock:completionBlock];
    [temp addDependency:heavyLifting];
//    if (self.priorCompletionOperation) {
//        [temp addDependency:self.priorCompletionOperation];
//    }
    [self.queue addOperation:heavyLifting];
    [[NSOperationQueue mainQueue] addOperation:temp];
  //  self.priorCompletionOperation = temp;
}



-(void)startSyncEngineForMainCategoryWithId:(NSString *)catId{
    NetworkStatus status =  [self.networkReachability currentReachabilityStatus];
    if (!self.syncInProgress && status != NotReachable){
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"MainCategory"];
       NSUInteger count = [self.appDelegate.cdh.context countForFetchRequest:request error:nil];
        NSArray *test = [self.appDelegate.cdh.context executeFetchRequest:request error:nil];
        if (!count) {
          [self downloadMainCatWithId:catId];
        } else{
            /* 增量更新 */
            NSLog(@"APlle");
            [self SyncCompleted];
      
        }
    }
}


-(void)startSyncEngineForSubCatId:(NSString *)subCatId withMainCat:(MainCategory *)mainCat{
    NetworkStatus status =  [self.networkReachability currentReachabilityStatus];
    if (!self.syncInProgress && status != NotReachable){
        NSOrderedSet *subCats = mainCat.subs;
        if (![subCats count]) {
            [self downloadSubCatWithId:subCatId parentId:mainCat.categoryId];
        } else{
            /* 增量更新 */
            NSLog(@"增量更新");
            [self SyncCompleted];
        }
    }
}

-(void)startSyncEngineForItem:(NSString *)itemId withSubCat:(SubCategory *)subCat{
    NetworkStatus status =  [self.networkReachability currentReachabilityStatus];
    if (!self.syncInProgress  && status != NotReachable ) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
    }
    NSOrderedSet *items = subCat.items;
    if (![items count]) {
        
        [self downloadProductItemWithId:itemId withSubcategory:subCat];
    }
}

-(void)downloadMainCatWithId:(NSString *)catId{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.40:8080/baihuogou-api/rest/category/first_category?status=%@",catId]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        [ self.appDelegate.cdh.parentContext performBlockAndWait:^{
            NSArray *result =responseObject[@"result"];
            for (NSDictionary *data in result) {
                MainCategory *mainCat = [NSEntityDescription insertNewObjectForEntityForName:@"MainCategory" inManagedObjectContext:self.appDelegate.cdh.parentContext];
                mainCat.categoryName = data[@"categoryName"];
                mainCat.categoryId = data[@"productCategoryId"];
                mainCat.thumbnail = nil;
                mainCat.updatedAt = nil;
                mainCat.index = [NSNumber numberWithInteger:[result indexOfObject:data]];
            }
            

        }];
        [self.appDelegate.cdh bgSaveContext];
        [self.appDelegate.cdh.parentContext reset];
        [self SyncCompleted];
    } failure:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"FAILURE");
    }];
    [self.queue addOperation:operation];
}

-(void)downloadSubCatWithId:(NSString *)subcatId parentId:(NSString *)parentId{
    
    NSLog(@"fsdfasdfasdfasdfasdfasdfasd&");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.40:8080/baihuogou-api/rest/category/second_category?parent_category_id=%@",subcatId]]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
  
        [self.appDelegate.cdh.parentContext performBlock:^{
            NSArray *result =responseObject[subcatId];
            
            for (NSDictionary *data in result) {
                SubCategory *subCat = [NSEntityDescription insertNewObjectForEntityForName:@"SubCategory" inManagedObjectContext:self.appDelegate.cdh.context];
                subCat.categoryName = data[@"categoryName"];
                subCat.categoryId = data[@"productCategoryId"];
                subCat.thumbnail = nil;
                subCat.updatedAt = nil;
                subCat.parentId = parentId;
            }

        }];

        [self.appDelegate.cdh bgSaveContext];
        [self.appDelegate.cdh.parentContext reset];
        [self SyncCompleted];
    } failure:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"FAILURE");
    }];
    [self.queue addOperation:operation];
}



-(void)downloadProductItemWithId:(NSString *)itemId withSubcategory:(SubCategory *)subCat{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.40:8080/baihuogou-api/rest/category/second?parentCategoryId=%@",itemId]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        [ self.appDelegate.cdh.parentContext performBlock:^{
            NSArray *result =responseObject[@"itemId"];
            for (NSDictionary *data in result) {
                ProductItem *productItem = [NSEntityDescription insertNewObjectForEntityForName:@"SubCategory" inManagedObjectContext:self.appDelegate.cdh.parentContext];
                productItem.subcat = subCat;
            }
        }];
        [self.appDelegate.cdh bgSaveContext];
        [self.appDelegate.cdh.parentContext reset];
        [self SyncCompleted];
    } failure:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"FAILURE");
    }];
    [self.queue addOperation:operation];
}


- (void)SyncCompleted{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kSyncEngineSyncCompletedNotificationName
         object:nil];
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = NO;
        [self didChangeValueForKey:@"syncInProgress"];
    });
}






-(NSArray *)loadDataFromCoreDataForEntity:(NSString *)entityName withId:(NSString *)subId{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    if (subId) {
        request.predicate = [NSPredicate predicateWithFormat:@"parentId = %@",subId];
    }
    return  [self.appDelegate.cdh.context executeFetchRequest:request error:nil];
}

-(void)establishRelationship:(NSString *)key betweenChild:(NSManagedObject *)child andParent:(NSManagedObject *)parent{
    
    [child setValue:parent forKey:key];
    [self.appDelegate.cdh backgroundSaveContext];
    
}

@end
