//
//  AppDelegate.m
//  BHGDataNew
//
//  Created by baihuogou on 14-3-22.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import "AppDelegate.h"
#import "LYSyncEngine.h"
#import "MainCategory.h"
@implementation AppDelegate

#define debug 1

-(NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

- (CoreDataHelper*)cdh {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (!_coreDataHelper) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            _coreDataHelper = [[CoreDataHelper alloc]init];
        });
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}

-(void)downloadMainCatWithId:(NSString *)catId{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.40:8080/baihuogou-api/rest/category/firstCategory?status=%@",catId]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        [self.cdh.opContext performBlockAndWait:^{
            NSArray *result =responseObject[@"result"];
            for (NSDictionary *data in result) {
                MainCategory *mainCat = [NSEntityDescription insertNewObjectForEntityForName:@"MainCategory" inManagedObjectContext:self.cdh.opContext];
                mainCat.categoryName = data[@"categoryName"];
                mainCat.categoryId = data[@"productCategoryId"];
                mainCat.thumbnail = nil;
                mainCat.updatedAt = nil;
                mainCat.index = [NSNumber numberWithInteger:[result indexOfObject:data]];
            }
            
            [self.cdh saveOpContext];
        }];
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"MainCategory"];
        NSUInteger count = [self.cdh.context countForFetchRequest:request error:nil];
        NSArray *test = [self.cdh.context executeFetchRequest:request error:nil];
        NSLog(@"new______%d",count);
    
    } failure:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"FAILURE");
    }];
    [self.queue addOperation:operation];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // [self demo];
   // [[LYSyncEngine sharedEngine] communicateWithServer];
   // [[LYSyncEngine sharedEngine] startSyncEngineForMainCategoryWithId:@"FOUR"];
   // [self downloadMainCatWithId:@"FOUR"];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
