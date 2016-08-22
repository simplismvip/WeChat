//
//  WCOtherLoginController.m
//  WeChat
//
//  Created by lanouhn on 16/2/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCOtherLoginController.h"
#import "AppDelegate.h"

@interface WCOtherLoginController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstrsints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstrans;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrsints;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *logIn;

@end

@implementation WCOtherLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"其他方式登录";
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        self.topConstrsints.constant = 100;
        self.leftConstrsints.constant = 20;
        self.rightConstrans.constant = 20;
    }

    self.userName.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdText.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.logIn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
 
}

// 用户登陆
- (IBAction)login {
    
    // 登陆之前拿到密码账号
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userName.text;
    userInfo.pwd = self.pwdText.text;
    
    // 这里直接调用父类方法
    [super baseLogin];
}



- (IBAction)cancle:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
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
