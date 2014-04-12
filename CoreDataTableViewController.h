//
//  CoreDataTableViewController.h
//  BDaying
//
//  Created by alex on 08/02/2014.
//  Copyright (c) 2014 alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;
@property BOOL debug;

@end
