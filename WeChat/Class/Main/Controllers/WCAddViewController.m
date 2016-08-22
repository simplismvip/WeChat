//
//  WCAddViewController.m
//  WeChat
//
//  Created by lanouhn on 16/3/2.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCAddViewController.h"
#import "WCXmppTool.h"

@interface WCAddViewController ()<UISearchBarDelegate, XMPPRosterDelegate>

@end

@implementation WCAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加代理
    [[WCXmppTool sharedWCXmppTool].roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}


#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 1> 获取好友账号
    NSString *userName = searchBar.text;
    
    // 2> 判断这个账号是否为手机号
    if (![self isTelphoneNum:userName]) {
        
        [self showAlert:@"请输入正确手机号码"];
    }
    
    // 根据好友名字拿到相应JID
    NSString *jidStr= [NSString stringWithFormat:@"%@@%@", userName, domain];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];

    
    // 判断是否添加自己
    if([userName isEqualToString:[WCUserInfo sharedWCUserInfo].user])
    {
        [self showAlert:@"不能添加自己为好友"];
        return;
    }
    
    // 判断是否好友已经存在
    if([[WCXmppTool sharedWCXmppTool].rosterStorage userExistsWithJID:jid xmppStream:[WCXmppTool sharedWCXmppTool].xmppStream]){
        
        [self showAlert:@"当前好友已经存在"];
        return;
    }
    
    // 3> 发送请求订阅好友
    [[WCXmppTool sharedWCXmppTool].roster subscribePresenceToUser:jid];
    [self showAlert:@"已发送添加消息"];
    
}


#pragma mark - 添加好友同意后会调用这个方法
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    
    [self showAlert:@"已成功添加好友"];
    NSLog(@"添加成功后会调用这个方法");
}

- (void)showAlert:(NSString *)str
{
    // 这里给出错误提示
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:str message:@"谢谢" preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 这里判断是否输入为电话号码
-(BOOL)isTelphoneNum:(NSString *)str{
    
    NSString *telRegex = @"^1[3578]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
