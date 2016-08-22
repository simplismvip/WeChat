//
//  WCResignController.m
//  WeChat
//
//  Created by lanouhn on 16/2/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCResignController.h"
#import "AppDelegate.h"

@interface WCResignController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstrsints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstrans;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrsints;
@end

@implementation WCResignController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"其他方式登录";
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        self.topConstrsints.constant = 100;
        self.leftConstrsints.constant = 20;
        self.rightConstrans.constant = 20;
    }
    
    self.userTextField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.registerBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}



- (IBAction)registerButn {
    
#pragma mark -- 这里使用正则表达式
    if (![self.userTextField isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确手机号码" toView:self.view];
    }
    
    // 把注册信息保存到单例
    WCUserInfo *userinfo = [WCUserInfo sharedWCUserInfo];
    userinfo.resignPwd = self.pwdField.text;
    userinfo.resignUser = self.userTextField.text;
    
    // 调用注册方法
    // AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    // 再注册之前更改注册标记的BOOl值
    [WCXmppTool sharedWCXmppTool].resign = YES;
    
    
    [MBProgressHUD showMessage:@"正在注册" toView:self.view];
    __weak typeof(self)weakSelf = self;
    
    [[WCXmppTool sharedWCXmppTool] resign:^(XMPPResultType type) {
        
        
        // 在这里回调
        [weakSelf handleResign:type];
        
    }];
    
    [self.view endEditing:YES];
}



// 取消注册
- (IBAction)cancle:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 处理注册方法
- (void)handleResign:(XMPPResultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
      
        // 隐藏
        [MBProgressHUD hideHUDForView:self.view];
        
        switch (type) {
            case XMPPResultTypeResignSucess:
                
                [MBProgressHUD showError:@"注册成功" toView:self.view];
                [self dismissViewControllerAnimated:YES completion:nil];
                
#warning maek -- 代理实现方法
                // 在这里判断代理方法是否实现
                if ([self.delegate respondsToSelector:@selector(regisgerViewControllerDidfinish)]) {
                    
                    [self.delegate regisgerViewControllerDidfinish];
                }
                
                break;
                
            case XMPPResultTypeResignFailure:
                
                // 注册成功之后返回登陆界面, 并且登陆界面UserLabel显示注册的账户
                [MBProgressHUD showSuccess:@"注册失败, 用户名重复" toView:self.view];
                
                
                break;
                
            case XMPPResultTypeNetErr:
                
                [MBProgressHUD showMessage:@"网络错误" toView:self.view];
                
                break;
                
            default:
                break;
        }
    });
}


- (IBAction)textChange {
    
    // 没有输入文字时让登录按钮不可用
    BOOL enable = self.userTextField.text.length != 0 && self.pwdField.text.length != 0;
    
    self.registerBtn.enabled = enable;
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
