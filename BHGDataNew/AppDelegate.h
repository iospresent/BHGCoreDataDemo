//
//  AppDelegate.h
//  BHGDataNew
//
//  Created by baihuogou on 14-3-22.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong,nonatomic) NSMutableArray *bDayingCategories;

@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;
- (CoreDataHelper*)cdh;
@property (nonatomic, strong) NSOperationQueue *queue;
@end
