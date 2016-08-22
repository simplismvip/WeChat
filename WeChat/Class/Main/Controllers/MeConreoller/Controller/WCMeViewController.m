//
//  WCMeViewController.m
//  WeChat
//
//  Created by lanouhn on 16/2/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "WCUserInfo.h"

@interface WCMeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headView;

@end

@implementation WCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示当前用户个人信息
    
    //如何使用coreData获取数据
    // 1> 获取上下文
    // 2> 请求对象
    // 3> 设置过滤条件
    // 4> 执行请求
    
    // XMPP 提供了一个方法直接获取用户信息
    XMPPvCardTemp *tmp = [WCXmppTool sharedWCXmppTool].vCard.myvCardTemp;
    
    // 设置头像
    if (tmp.photo) {
        self.headView.image = [UIImage imageWithData:tmp.photo];
    }
    
    
    // 设置昵称
    self.nickLabel.text = tmp.nickname;
    
    NSLog(@"%@", tmp.nickname);
    
    // 设置用户名
    self.numberLabel.text = [NSString stringWithFormat:@"微信号:%@", [WCUserInfo sharedWCUserInfo].user];
}



- (IBAction)logout:(id)sender {
    
    // AppDelegate *app = [UIApplication sharedApplication].delegate;
    [[WCXmppTool sharedWCXmppTool] logOut];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return 10;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//
//    cell.textLabel.text = @"000";
//    
//    return cell;
//}
//

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
