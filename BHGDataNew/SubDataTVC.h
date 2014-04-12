//
//  SubDataTVC.h
//  BHGDataNew
//
//  Created by baihuogou on 14-4-12.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainCategory;

@interface SubDataTVC : UITableViewController

@property (strong,nonatomic) MainCategory *mainCategory;
@property (strong,nonatomic) NSString *subId;

@end
