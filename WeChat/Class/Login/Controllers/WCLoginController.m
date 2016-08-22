//
//  WCLoginController.m
//  WeChat
//
//  Created by lanouhn on 16/2/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCLoginController.h"
#import "WCResignController.h"
#import "WCNavigationController.h"

@interface WCLoginController ()<WCResignControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置登录界面的输入框, 按钮, label背景图片
    [self.textField addLeftViewWithImage:@"Card_Lock"];
    
    self.textField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    // 从沙盒获取用户名
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    self.userLabel.text = user;
    
}

// 直接登录的方法
- (IBAction)loginClick:(id)sender {
    
    // 保存数据到单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.textField.text;
    
    // 调用父类登录方法
    [super baseLogin];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    
    if (sender.tag == 101) {
        
        // 获取注册控制器
        id destVC = segue.destinationViewController;
        
        
        if ([destVC isKindOfClass:[WCNavigationController class]]) {
            
            WCNavigationController *regiser = destVC;
            
            WCResignController *resignVc = (WCResignController *)regiser.topViewController;
            
            // 设置注册控制器代理
            resignVc.delegate = self;
        }

    }
    
    
}


// 实现代理方法
- (void)regisgerViewControllerDidfinish
{
    WCLog(@"完成注册");
    
    // 完成注册
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].resignUser;

    // 注册成功 给个提示
    [MBProgressHUD showSuccess:@"请输入密码进行登录" toView:self.view];
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
