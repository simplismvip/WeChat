//
//  LoginAndRegisterView.m
//  LogInView
//
//  Created by JM Zhao on 16/7/14.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "LoginAndRegisterView.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"
#import "NSString+Reglx.h"
#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface LoginAndRegisterView()<UITextFieldDelegate>

@property (nonatomic, weak) UIImageView *headerImage;
@property (nonatomic, weak) UILabel *accountLabel;
@property (nonatomic, weak) UITextField *accountText;
@property (nonatomic, weak) UIView *lineFrist;
@property (nonatomic, weak) UILabel *pwdLabel;
@property (nonatomic, weak) UITextField *pwdText;
@property (nonatomic, weak) UIView *lineSecon;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIButton *remPwd;
@property (nonatomic, weak) UIButton *forgetPwdBtn;
@property (nonatomic, weak) UIButton *registerBtn;
@property (nonatomic, weak) UIView *lineLeft;
@property (nonatomic, weak) UILabel *otherLogin;
@property (nonatomic, weak) UIView *lineRight;
@property (nonatomic, weak) UIButton *sinaBtn;
@property (nonatomic, weak) UIButton *qqBtn;
@property (nonatomic, weak) UIButton *weChatBtn;

@property (nonatomic, assign) BOOL isRemPwd;
@end

@implementation LoginAndRegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.isRemPwd = NO;
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.bounds];
        image.image = [UIImage imageNamed:@"22"];
        [self addSubview:image];
        [self creatSubView];
        
    }
    return self;
}

- (void)loginViewBtn:(UIButton *)sender
{
    [self endEditing:YES];
    if (self.delegate == nil) return;
    
    NSInteger status = sender.tag-150;
    
    if (status == remPwdStatus) {
        
        if (self.isRemPwd) {
            
            [self.delegate actionByremPwdn:remPwdStatus rem:self.isRemPwd];
            [sender setImage:[[UIImage imageNamed:@"remPwdn"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
            self.isRemPwd = !self.isRemPwd;
            
        }else{
            [self.delegate actionByremPwdn:remPwdStatus rem:self.isRemPwd];
            [sender setImage:[[UIImage imageNamed:@"remPwd"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
            self.isRemPwd = !self.isRemPwd;
        }
        
    }else if(status == loginBtnStatus){
    
        if (![self.accountText.text isQQ]) {
            
            NSLog(@"请输入合法账号");
            return;
        }
        
        if (![self.pwdText.text isQQ]){
        
            NSLog(@"请输入合法密码");
            return;
        }
        
        [self.delegate actionByLogin:self.accountText.text pwd:self.pwdText.text];
    }else{
    
        [self.delegate actionByStatus:status];
    }
}

/*
 NSInteger status = sender.tag-150;
 switch (status) {
 case loginBtnStatus:
 
 [self.delegate actionByStatus:loginBtnStatus];
 break;
 
 case remPwdStatus:
 
 [self btnAction:sender];
 break;
 
 case forgetPwdBtnStatus:
 
 [self.delegate actionByStatus:forgetPwdBtnStatus];
 break;
 
 case registerBtnStatus:
 
 [self.delegate actionByStatus:registerBtnStatus];
 break;
 
 case sinaBtnStatus:
 
 [self.delegate actionByStatus:sinaBtnStatus];
 break;
 
 case qqBtnStatus:
 
 [self.delegate actionByStatus:qqBtnStatus];
 break;
 
 case weChatBtnStatus:
 
 [self.delegate actionByStatus:weChatBtnStatus];
 break;
 
 default:
 break;
 **/

#pragma mark -- 初始化
+ (void)initWithLoginView:(UIView *)view delegate:(id)delegate
{
    LoginAndRegisterView *login = [[self alloc] initWithFrame:view.bounds];
    login.delegate = delegate;
    [view addSubview:login];
}

#pragma mark -- UITextFieldDelegate
// 开始textField是调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self textField:textField];
}

// 结束textField时调用
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textField:textField];
}

// 点击return时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self textField:textField];
    [self endEditing:YES];
    return YES;
}

- (void)textField:(UITextField *)textField
{
    if (textField.tag == 160) {
        
        self.accountText.text = textField.text;
    }else{
        
        self.pwdText.text = textField.text;
    }
}

// 弹出键盘
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // 键盘高度
    CGFloat imageH = self.height*0.1;
    CGFloat accountEdge = (40.0/736.0)*self.height;
    CGFloat loginBtnEdge = (60.0/736.0)*self.height;
    [self layoutLoginSubviews:imageH accountEdge:accountEdge loginBtnEdge:loginBtnEdge];
}

// 隐藏键盘
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGFloat imageH = self.height*0.2;
    CGFloat accountEdge = (80.0/736.0)*self.height;
    CGFloat loginBtnEdge = (100.0/736.0)*self.height;
    [self layoutLoginSubviews:imageH accountEdge:accountEdge loginBtnEdge:loginBtnEdge];
}

// 移除通知中心
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)creatSubView
{
    UIColor *lineCo = [UIColor whiteColor];
    UIColor *back = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"00"];
    imageView.layer.cornerRadius = 40;
    [self addSubview:imageView];
    self.headerImage = imageView;
    
    // 账号
    UILabel *account = [[UILabel alloc] init];
    account.text = @"账号";
    account.textColor = lineCo;
    [self addSubview:account];
    self.accountLabel = account;
    
    UITextField *accountText = [[UITextField alloc] init];
    accountText.delegate = self;
    accountText.tag = 160;
    accountText.placeholder = @"输入账号";
    [accountText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountText.clearsOnBeginEditing=YES;
    accountText.textColor = lineCo;
    [self addSubview:accountText];
    self.accountText = accountText;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = lineCo;
    [self addSubview:view];
    self.lineFrist = view;
    
    // 密码
    UILabel *pwdLabel = [[UILabel alloc] init];
    pwdLabel.text = @"密码";
    pwdLabel.textColor = lineCo;
    [self addSubview:pwdLabel];
    self.pwdLabel = pwdLabel;
    
    UITextField *pwdText = [[UITextField alloc] init];
    pwdText.delegate = self;
    pwdText.tag = 161;
    pwdText.placeholder = @"输入密码";
    pwdText.secureTextEntry = YES;
    [pwdText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdText.clearsOnBeginEditing=YES;
    pwdText.textColor = lineCo;
    [self addSubview:pwdText];
    self.pwdText = pwdText;
    
    UIView *lineSecon = [[UIView alloc] init];
    lineSecon.backgroundColor = lineCo;
    [self addSubview:lineSecon];
    self.lineSecon = lineSecon;
    
#pragma mark -- 登陆
    UIButton *loginBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    loginBtn.tag = 150+loginBtnStatus;
    loginBtn.backgroundColor = back;
    [loginBtn setTintColor:lineCo];
    [loginBtn addTarget:self action:@selector(loginViewBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [loginBtn setTitle:@"登陆" forState:(UIControlStateNormal)];
    [self addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIButton *forgetPwdBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    forgetPwdBtn.tag = 150+forgetPwdBtnStatus;
    forgetPwdBtn.backgroundColor = back;
    [forgetPwdBtn setTintColor:lineCo];
    [forgetPwdBtn addTarget:self action:@selector(loginViewBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    forgetPwdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [forgetPwdBtn setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
    [self addSubview:forgetPwdBtn];
    self.forgetPwdBtn = forgetPwdBtn;
    
    UIButton *remPwd = [UIButton buttonWithType:(UIButtonTypeSystem)];
    remPwd.tag = 150+remPwdStatus;
    remPwd.backgroundColor = back;
    [remPwd setTintColor:lineCo];
    [remPwd addTarget:self action:@selector(loginViewBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    remPwd.titleLabel.font = [UIFont systemFontOfSize:11.0];
    remPwd.layer.borderColor = [UIColor whiteColor].CGColor;
    [remPwd setTitle:@"记住密码" forState:(UIControlStateNormal)];
    [remPwd setImage:[[UIImage imageNamed:@"remPwdn"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    remPwd.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:remPwd];
    self.remPwd = remPwd;
    
    UIButton *registerBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    registerBtn.tag = 150+registerBtnStatus;
    registerBtn.backgroundColor = back;
    [registerBtn setTintColor:lineCo];
    [registerBtn addTarget:self action:@selector(loginViewBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    registerBtn.layer.cornerRadius = 5;
    registerBtn.layer.borderWidth = 1;
    registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [registerBtn setTitle:@"注册" forState:(UIControlStateNormal)];
    [self addSubview:registerBtn];
    self.registerBtn = registerBtn;
    
    // 其他方式登陆
    UIView *viewLeft = [[UIView alloc] init];
    viewLeft.backgroundColor = lineCo;
    [self addSubview:viewLeft];
    self.lineLeft = viewLeft;
    
    UILabel *other = [[UILabel alloc] init];
    other.text = @"其他方式登陆";
    other.textColor = lineCo;
    other.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:other];
    self.otherLogin = other;
    
    UIView *viewRight = [[UIView alloc] init];
    viewRight.backgroundColor = lineCo;
    [self addSubview:viewRight];
    self.lineRight = viewRight;
    
    UIButton *sinaBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    sinaBtn.tag = 150+sinaBtnStatus;
    [sinaBtn addTarget:self action:@selector(loginViewBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    sinaBtn.backgroundColor = back;
    [sinaBtn setImage:[[UIImage imageNamed:@"sina"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    [self addSubview:sinaBtn];
    self.sinaBtn = sinaBtn;
    
    UIButton *qqBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    qqBtn.tag = 150+qqBtnStatus;
    [qqBtn addTarget:self action:@selector(loginViewBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    qqBtn.backgroundColor = back;
    [qqBtn setImage:[[UIImage imageNamed:@"qq"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    [self addSubview:qqBtn];
    self.qqBtn = qqBtn;
    
    UIButton *weChatBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    weChatBtn.tag = 150+weChatBtnStatus;
    [weChatBtn addTarget:self action:@selector(loginViewBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    weChatBtn.backgroundColor = back;
    [weChatBtn setImage:[[UIImage imageNamed:@"weChat"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    [self addSubview:weChatBtn];
    self.weChatBtn = weChatBtn;
    
    // 设置frame
    CGFloat imageH = self.height*0.2;
    CGFloat accountEdge = (80.0/736.0)*self.height;
    CGFloat loginBtnEdge = (100.0/736.0)*self.height;
    [self layoutLoginSubviews:imageH accountEdge:accountEdge loginBtnEdge:loginBtnEdge];
    
    // 注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    // 注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)layoutLoginSubviews:(CGFloat)imageH accountEdge:(CGFloat)accountEdge loginBtnEdge:(CGFloat)loginBtnEdge
{
    // [super layoutSubviews];
    
    CGFloat leftEdge = self.width*0.15;
    CGFloat width = self.width-2*leftEdge;
    CGFloat lineHeight = 1;
    CGFloat btnHeight = (30.0/736.0)*self.height;
    CGFloat labelHeight = (30.0/736.0)*self.height;
    CGFloat ten = (10.0/736.0)*self.height;
    CGFloat five = (5.0/736.0)*self.height;
    
    // 1>
    self.headerImage.frame = CGRectMake(0, 0, (80.0/736.0)*self.height, (80.0/736.0)*self.height);
    self.headerImage.center = CGPointMake(self.width/2, imageH);
    
    // 账号 2>
    
    self.accountLabel.frame = CGRectMake(leftEdge, CGRectGetMaxY(self.headerImage.frame)+accountEdge, (40.0/414.0)*self.width, labelHeight);
    self.accountText.frame = CGRectMake(CGRectGetMaxX(self.accountLabel.frame)+ten, CGRectGetMaxY(self.headerImage.frame)+accountEdge, width-self.accountLabel.width-ten, btnHeight);
    self.lineFrist.frame = CGRectMake(leftEdge, CGRectGetMaxY(self.accountLabel.frame), width, lineHeight);
    
    // 密码
    CGFloat pwdEdge = (20.0/736.0)*self.height;
    self.pwdLabel.frame = CGRectMake(leftEdge, CGRectGetMaxY(self.lineFrist.frame)+pwdEdge, (40.0/414.0)*self.width, labelHeight);
    self.pwdText.frame = CGRectMake(CGRectGetMaxX(self.pwdLabel.frame)+ten, CGRectGetMaxY(self.lineFrist.frame)+pwdEdge, width-self.pwdLabel.width-ten, btnHeight);
    self.lineSecon.frame = CGRectMake(leftEdge, CGRectGetMaxY(self.pwdLabel.frame), width, lineHeight);
    
    // 忘记密码
    CGFloat pwdBtnEdge = CGRectGetMaxY(self.lineSecon.frame)+(10.0/736.0)*self.height;
    self.remPwd.frame = CGRectMake(leftEdge, pwdBtnEdge, (70.0/414.0)*self.width, (30.0/736.0)*self.height);
    self.forgetPwdBtn.frame = CGRectMake(CGRectGetMaxX(self.lineSecon.frame)-(60.0/414.0)*self.width, pwdBtnEdge, (60.0/414.0)*self.width, (30.0/736.0)*self.height);
    // self.forgetPwdBtn.center = CGPointMake(self.width/2, CGRectGetMaxY(self.loginBtn.frame)+(20.0/736.0)*self.height);
    
    
    // 登陆/注册 3>
    
    self.loginBtn.frame = CGRectMake(leftEdge+width*0.12, CGRectGetMaxY(self.lineSecon.frame)+loginBtnEdge, width*0.3, btnHeight);
    self.registerBtn.frame = CGRectMake(CGRectGetMaxX(self.loginBtn.frame)+width*0.16, CGRectGetMaxY(self.lineSecon.frame)+loginBtnEdge, width*0.3, btnHeight);
    
    
    // 其他方式登陆
    CGFloat otherEdge = (100.0/736.0)*self.height;
    self.lineLeft.frame = CGRectMake(leftEdge, CGRectGetMaxY(self.registerBtn.frame)+otherEdge, width/3, lineHeight);
    self.otherLogin.frame = CGRectMake(CGRectGetMaxX(self.lineLeft.frame)+five, CGRectGetMaxY(self.lineLeft.frame)-(20.0/414.0)*self.width, width/3-ten, labelHeight);
    self.lineRight.frame = CGRectMake(CGRectGetMaxX(self.otherLogin.frame)+five, CGRectGetMaxY(self.lineLeft.frame), width/3, lineHeight);
    
    CGFloat qqEdge = (30.0/736.0)*self.height;
    CGFloat qqW = (40.0/414.0)*self.width;
    CGFloat qqH = (40.0/736.0)*self.height;
    CGFloat qqX = (width-qqW*3-qqEdge*2)/4;
    
    self.sinaBtn.frame = CGRectMake(leftEdge+qqX, CGRectGetMaxY(self.lineRight.frame)+qqEdge, qqW, qqH);
    self.qqBtn.frame = CGRectMake(CGRectGetMaxX(self.sinaBtn.frame)+leftEdge, CGRectGetMaxY(self.lineRight.frame)+qqEdge, qqW, qqH);
    self.weChatBtn.frame = CGRectMake(CGRectGetMaxX(self.qqBtn.frame)+leftEdge, CGRectGetMaxY(self.lineRight.frame)+qqEdge, qqW, qqH);
}
@end
