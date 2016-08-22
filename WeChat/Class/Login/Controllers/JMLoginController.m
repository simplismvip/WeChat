//
//  JMLoginController.m
//  WeChat
//
//  Created by JM Zhao on 16/8/15.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMLoginController.h"
#import "LoginAndRegisterView.h"

@interface JMLoginController()<LoginAndRegisterViewDelegate>

@end

@implementation JMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.view.backgroundColor = [UIColor cyanColor];
    //    LoginAndRegisterView *login = [[LoginAndRegisterView alloc] initWithFrame:self.view.frame];
    //    [self.view addSubview:login];
    
    [LoginAndRegisterView initWithLoginView:self.view delegate:self];
    
}

- (void)actionByStatus:(loginViewBtnStatus)status
{
    NSLog(@"actionByStatus==%ld", status);
}
- (void)actionByremPwdn:(loginViewBtnStatus)status rem:(BOOL)isRem
{
    NSLog(@"actionByremPwdn==%ld==%d", status, isRem);
}

- (void)actionByLogin:(NSString *)acc pwd:(NSString *)pwd
{
    NSLog(@"pwd=%@--acc=%@", pwd, acc);
}

@end
