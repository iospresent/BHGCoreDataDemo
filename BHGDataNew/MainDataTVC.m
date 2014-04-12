//
//  MainDataTVC.m
//  BHGDataNew
//
//  Created by baihuogou on 14-3-22.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import "MainDataTVC.h"
#import "AppDelegate.h"
#import "LYSyncEngine.h"
#import "ImageDown.h"
#import "BHLLCDataHelper.h"
#import "MyCell.h"
#import "MainDataTVC.h"
#import "SubCategory.h"
#import "MainCategory.h"
#import "SubCategory.h"
#import "SubDataTVC.h"

@interface MainDataTVC ()
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) LYSyncEngine *engine;
@property (strong,nonatomic) NSArray *dataArray;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSOperation *priorCompletionOperation;


@end

@implementation MainDataTVC

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

- (IBAction)refresh:(UIBarButtonItem *)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"MainCategory"];
    NSUInteger count = [self.appDelegate.cdh.context countForFetchRequest:request error:nil];
    NSArray *test = [self.appDelegate.cdh.context executeFetchRequest:request error:nil];
    NSLog(@"new______%d______%@",count,test);
}

-(NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
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
       self.dataArray =  [self.engine loadDataFromCoreDataForEntity:@"MainCategory"withId:nil];
        [self.tableView reloadData];
    }];
    

    [self.engine startSyncEngineForMainCategoryWithId:@"FOUR"];
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
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"main"];
    MainCategory *mainCat = self.dataArray[indexPath.row];
    cell.textLabel.text = mainCat.categoryName;
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        NSLog(@"LOVE IS GREAT!");
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SubDataTVC *subtvc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MainCategory *mainCat = self.dataArray[indexPath.row];
    subtvc.mainCategory = mainCat;
    subtvc.subId = mainCat.categoryId;
}

@end
