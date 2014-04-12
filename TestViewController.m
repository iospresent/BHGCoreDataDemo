//
//  TestViewController.m
//  BHGDataNew
//
//  Created by liaolongcheng on 14-4-12.
//  Copyright (c) 2014年 baihuogou. All rights reserved.
//

#import "TestViewController.h"
#import "LYSyncEngine.h"


@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    UITableView *table=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    table.dataSource=self;
//    table.delegate=self;
//    [self.view addSubview:table];
    
    NSString *str = [[LYSyncEngine sharedEngine] dateForEntity:@"SubCategory" withIdKey:nil IdValue:nil];
    //http://192.168.1.40:8080/baihuogou-api/rest/product/last_update?category_id=ycs_tttj_reco_0201&last_update=2011-01-01%2000:00:00&page_size=5&page_now=1

   // http://192.168.1.40:8080/baihuogou-api/rest/product/last_update?category_id=%E5%8F%82%E6%95%B0&last_update=%E5%8F%82%E6%95%B0&page_size=%E5%8F%82%E6%95%B0&page_now=%E5%8F%82%E6%95%B0
    //bhg_man_root_1
    
    
    NSString *urlString=[NSString stringWithFormat:@"http://192.168.1.40:8080/baihuogou-api/rest/product/last_update?category_id=ycs_tttj_reco_0201&last_update=%@&page_size=5&page_now=1",str];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager GET:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"___________error:%@",error);
    }];
    
    
    
    
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
