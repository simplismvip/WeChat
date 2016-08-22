//
//  WCBaseLoginController.m
//  WeChat
//
//  Created by lanouhn on 16/2/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCBaseLoginController.h"
#import "AppDelegate.h"

@interface WCBaseLoginController ()

@end

@implementation WCBaseLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 用户登陆
- (void)baseLogin {
    
        
    // 登陆到界面之后隐藏键盘
    [self.view endEditing:YES];
    
    // 在登陆之前显示正在登陆的提示
    [MBProgressHUD showMessage:@"正在登陆..." toView:self.view];
    
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    
//    // 在登陆之前把注册标记改为NO
    [WCXmppTool sharedWCXmppTool].resign = NO;
    
    // 在这里登陆
    // 自己写的方法要在这里使用weak方法
    __weak typeof(self)selfVc = self;
    
    [[WCXmppTool sharedWCXmppTool] login:^(XMPPResultType type) {
        
        [selfVc showLoginResult:type];
        
    }];
    
}


// 显示登陆结果
- (void)showLoginResult:(XMPPResultType)type
{
    // 因为在Appdelegate里面代理实现都是在子线程执行, 这里需要到主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 在登陆成功之后隐藏掉提示登陆动画
        [MBProgressHUD hideHUDForView:self.view];
        
        switch (type) {
            case XMPPResultTypeFailure:
                
                [MBProgressHUD showError:@"用户名或密码错误" toView:self.view];
                break;
                
            case XMPPResultTypeSucess:
                
                // 调用登陆到主界面的方法
                [self loginMainPage];
                
                break;
                
            case XMPPResultTypeNetErr:
                
                [MBProgressHUD showError:@"网络错误" toView:self.view];
                break;
                
            default:
                break;
        }
        
    });
}

#pragma mark -- 登陆到Main界面的方法
- (void)loginMainPage
{
    // 登陆成功之后更改用户的登录状态为YES
    [WCUserInfo sharedWCUserInfo].loginStatus = YES;
    
    // 然后把然后把用户登录成功的数据写入沙盒
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
    [MBProgressHUD showSuccess:@"登陆成功" toView:self.view];
    
    // 因为转跳到Main里面是模态过来的, 模态方法会在内部对控制器执行一次强引用, 因而控制机器不会被释放, 这里需要执行一次dismiss方法
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 授权成功后切换到的主界面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // 先拿到控制器的view, 在拿到view的window
    self.view.window.rootViewController = storyBoard.instantiateInitialViewController;
}

@end
