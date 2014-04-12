//
//  SubDataTVC.m
//  BHGDataNew
//
//  Created by baihuogou on 14-4-12.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import "SubDataTVC.h"
#import "AppDelegate.h"
#import "LYSyncEngine.h"
#import "MainCategory.h"
#import "SubCategory.h"


@interface SubDataTVC ()
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) LYSyncEngine *engine;
@property (strong,nonatomic) NSArray *dataArray;

@end

@implementation SubDataTVC
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc]init];
    }
    return _dataArray;
}

-(LYSyncEngine *)engine{
    if (!_engine) {
        _engine = [LYSyncEngine sharedEngine];
    }
    return _engine;
}

-(AppDelegate *)appDelegate{
    if (!_appDelegate) {
        _appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"MyCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"test"];
    self.tableView.rowHeight = 80;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (![self.mainCategory.subs count]) {
           

            self.dataArray =  [self.engine loadDataFromCoreDataForEntity:@"SubCategory"withId:self.subId];
            [self.tableView reloadData];
        } else {
            self.dataArray = [self.mainCategory.subs array];
            [self.tableView reloadData];}
    }];
    
    [self.engine startSyncEngineForSubCatId:self.subId withMainCat:self.mainCategory];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.engine addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SyncEngineSyncCompleted" object:nil];
    [self.engine removeObserver:self forKeyPath:@"syncInProgress"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"sub"];
    SubCategory *subCat = self.dataArray[indexPath.row];
    [self.engine establishRelationship:@"main" betweenChild:subCat andParent:self.mainCategory];
    cell.textLabel.text = subCat.categoryName;

    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        NSLog(@"LOVE IS GREAT!");
    }
}


@end
