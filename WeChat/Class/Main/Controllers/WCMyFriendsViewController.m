//
//  WCMyFriendsViewController.m
//  WeChat
//
//  Created by lanouhn on 16/3/2.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCMyFriendsViewController.h"
#import "XMPPJID.h"
#import "WCXmppTool.h"
#import "MainViewModel.h"
#import "JMMessageController.h"
#define kH [UIScreen mainScreen].bounds.size.height
#define kW [UIScreen mainScreen].bounds.size.width

@interface WCMyFriendsViewController ()
@property (nonatomic, strong) XMPPJID *jid;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *weChatNumber;
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UILabel *myPic;
@property (weak, nonatomic) IBOutlet UILabel *more;
@property (weak, nonatomic) IBOutlet UILabel *phoneNUmber;
@end

@implementation WCMyFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 设置模型
- (void)setCModel:(ContactModel *)cModel
{
    _cModel = cModel;
    self.nickName.text = cModel.nickname;
    self.weChatNumber.text = cModel.weChatNumber;
    self.jid = [XMPPJID jidWithString:cModel.jidStr];
}

#pragma mark -- 删除好友并返回上一个界面
- (IBAction)deleteFriends:(id)sender {
    
    // 删除好友操作
    [[WCXmppTool sharedWCXmppTool].roster removeUser:self.jid];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    MainViewModel *mModel = [[MainViewModel alloc] init];
    mModel.nickname = self.cModel.nickname;
    mModel.weChatNumber = self.cModel.weChatNumber;
    mModel.sectionNum = self.cModel.sectionNum;
    mModel.jidStr = self.cModel.jidStr;
    mModel.number = self.cModel.number;
    BOOL isS = [mModel save];
    if (isS) {
        
        NSLog(@"保存成功");
    }
    // 在这里吧对应好友的jid传给下个界面
    JMMessageController *message = segue.destinationViewController;
    message.jid = self.jid;
}

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

*/
#pragma mark -- UISearchBarDelegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
