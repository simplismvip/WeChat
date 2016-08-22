//
//  JMMainTableView.m
//  WeChat
//
//  Created by JM Zhao on 16/8/10.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMMainTableView.h"
#import "JMMaimCell.h"
#import "MainViewModel.h"
#import "pinyin.h"
#import "UIView+Extension.h"

@interface JMMainTableView()<UITableViewDelegate, UITableViewDataSource>
// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
@end


@implementation JMMainTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        
        [self registerClass:[JMMaimCell class] forCellReuseIdentifier:@"Maincell"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMMaimCell *cell = [JMMaimCell contactCell:tableView cellForRowAtIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 点击进入聊天界面
//    NSMutableArray *rowArr = self.dataArray[indexPath.section];
//    ContactModel *model = rowArr[indexPath.row];
//    
//    UIStoryboard *sto = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WCMyFriendsViewController *mfVC = [sto instantiateViewControllerWithIdentifier:@"SendAndDeleta"];
//    mfVC.nickname = [NSString stringWithFormat:@"昵称:%@", model.nickname];
//    mfVC.wechatNumber = [NSString stringWithFormat:@"微信号:%@", model.jidStr];
//    XMPPJID *jid = [XMPPJID jidWithString:model.jidStr];
//    mfVC.jid = jid;
//    [self.superViewController.navigationController pushViewController:mfVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPat
{}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"添加" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"添加");
    }];
    
    
    UITableViewRowAction *deleAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"删除");
        
    }];
    
    return @[addAction, deleAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

+ (instancetype)initContactTableView:(UIViewController *)viewC dataArray:(NSMutableArray *)dataArray;
{
    JMMainTableView *base = [[JMMainTableView alloc] initWithFrame:viewC.view.bounds];
    base.dataArray = dataArray;
    [viewC.view addSubview:base];
    return base;
}

@end
