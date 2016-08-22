//
//  JMMainViewController.m
//  WeChat
//
//  Created by JM Zhao on 16/8/10.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMMainViewController.h"
#import "JMMainTableView.h"
#import "JMArrayHelper.h"
#import "MainViewModel.h"

@interface JMMainViewController ()
@property (nonatomic, strong) JMMainTableView *base;
@end

//static BOOL _isExistSQLite;
@implementation JMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readContactFromSQL];
}

// 加载展示数据
- (void)readContactFromSQL
{
    // 2> 将数据库中的数据取出来
    NSArray *he = [MainViewModel findAll];
    [JMMainTableView initContactTableView:self dataArray:[he mutableCopy]];
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
