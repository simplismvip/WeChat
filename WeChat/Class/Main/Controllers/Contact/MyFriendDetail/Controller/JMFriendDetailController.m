//
//  JMFriendDetailController.m
//  WeChat
//
//  Created by JM Zhao on 16/8/21.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMFriendDetailController.h"
#import "JMFriendCell.h"
#import "XMPPJID.h"
#import "WCXmppTool.h"
#import "JMDetailModel.h"
#import "MainViewModel.h"
#import "JMMessageController.h"

@interface JMFriendDetailController ()<UITableViewDelegate, UITableViewDataSource, JMFriendCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JMFriendDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setUpTableView
{
    NSArray *array1 = @[@"", @"设置备注和标签", @"地区", @"个人相册", @"更多", @"", @""];
    self.dataArray = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    NSMutableArray *array3 = [NSMutableArray array];
    NSMutableArray *array4 = [NSMutableArray array];
    NSMutableArray *array5 = [NSMutableArray array];
    for (int i = 0; i < array1.count; i ++) {
        
        JMDetailModel *model = [[JMDetailModel alloc] init];
        model.title = array1[i];
        switch (i) {
            case 0:
                
                model.header = @"header";
                model.nickName = _cModel.nickname;
                model.number = _cModel.weChatNumber;
                [array2 addObject:model];
                break;
                
            case 1:
                
                [array3 addObject:model];
                break;
                
            case 2:
                
                model.region = @"中国-上海";
                [array4 addObject:model];
                break;
                
            case 3:
                
                model.imageArr = @[@"01", @"02", @"03", @"04"];
                [array4 addObject:model];
                break;
                
            case 4:
                
                [array4 addObject:model];
                break;
                
            case 5:
                
                [array5 addObject:model];
                break;
                
            case 6:
                
                [array5 addObject:model];
                break;
                
            default:
                break;
        }
    }
    
    [self.dataArray addObject:array2];
    [self.dataArray addObject:array3];
    [self.dataArray addObject:array4];
    [self.dataArray addObject:array5];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    [tableView registerClass:[JMFriendCell class] forCellReuseIdentifier:@"Detailcell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMFriendCell *cell = [JMFriendCell lrcCell:tableView cellForRowAtIndexPath:indexPath dataArr:self.dataArray];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {return 64;
        
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == 1) {return 80;}else{return 44;}
        
    }else {return 44;}
}

- (void)btnAction:(btnType)type
{
    XMPPJID *jid = [XMPPJID jidWithString:self.cModel.jidStr];
    switch (type) {
        case btnMessage:
            
            [self pushController:jid];
            break;
            
        case btnDelete:
            
            // 删除好友操作
            [[WCXmppTool sharedWCXmppTool].roster removeUser:jid];
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

// 弹出聊天界面
- (void)pushController:(XMPPJID *)jid
{
    MainViewModel *mModel = [[MainViewModel alloc] init];
    mModel.nickname = self.cModel.nickname;
    mModel.weChatNumber = self.cModel.weChatNumber;
    mModel.sectionNum = self.cModel.sectionNum;
    mModel.jidStr = self.cModel.jidStr;
    mModel.number = self.cModel.number;
    [mModel save];
    
    // 在这里吧对应好友的jid传给下个界面
    JMMessageController *msgVC = [[JMMessageController alloc] init];
    msgVC.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:msgVC animated:YES];
    msgVC.jid = jid;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中%ld行", indexPath.row);
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
