//
//  MainDataTVC.h
//  BHGDataNew
//
//  Created by baihuogou on 14-3-22.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface MainDataTVC : UITableViewController
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@end
