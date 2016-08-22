//
//  JMFriendDetailController.m
//  WeChat
//
//  Created by JM Zhao on 16/8/21.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMFriendDetailController.h"
#import "JMFriendCell.h"

@interface JMFriendDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JMFriendDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JMFriendCell class] forCellReuseIdentifier:@"cell"];
    self.dataSource = @[@[], @[@"地址", @"相册", @"更多"], @[@"电话号码"], @[], @[]];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMFriendCell *cell = [JMFriendCell friendCell:tableView cellForRowAtIndexPath:indexPath];
    // cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
