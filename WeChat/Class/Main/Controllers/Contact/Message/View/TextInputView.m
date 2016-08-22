//
//  KeyBoardView.m
//  CustomKeyBoard-自定义键盘输入框
//
//  Created by Mac on 16/6/15.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "TextInputView.h"
#import "RecorderTool.h"
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface TextInputView ()<UITextFieldDelegate, RecorderToolDelegate>
@property (nonatomic, weak) UIButton *send;
@property (nonatomic, weak) UITextField *textFied;
@property (nonatomic, assign) BOOL keyBoardStatus;
@property (nonatomic, strong) RecorderTool *record;
@end

@implementation TextInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.keyBoardStatus = NO;
        self.backgroundColor = JMColor(232, 233, 235);
        
        // OK按钮
        UIButton *send = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [send addTarget:self action:@selector(EventTouchDown:) forControlEvents:(UIControlEventTouchDown)];
        [send addTarget:self action:@selector(TouchUpInside:) forControlEvents:(UIControlEventTouchUpInside)];
        [send addTarget:self action:@selector(DragExit:) forControlEvents:(UIControlEventTouchDragExit)];
        UIImage *bacImage = [UIImage imageNamed:@"voice-32"];
        [send setImage:[bacImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
        [self addSubview:send];
        self.send = send;
        
        // 输入框
        UITextField *textFied = [[UITextField alloc] init];
        textFied.borderStyle = UITextBorderStyleRoundedRect;
        textFied.delegate = self;
        [textFied becomeFirstResponder];
        textFied.backgroundColor = JMColor(242, 243, 245);
        [self addSubview:textFied];
        self.textFied = textFied;
        
        // 注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        
        // 注册键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

//// 点击发送响应方法
//- (void)okAction:(UIButton *)send
//{
//    // 点击录音按钮开始录音
//    self.record = [[RecorderTool alloc] init];
//    self.record.delegateRec = self;
//    
//    if ([self.delegate respondsToSelector:@selector(textInputFinished:)]) {
//        
//        [self.delegate textInputFinished:self.textFied.text];
////        self.textFied = nil;
//    }
//}

#pragma mark -- UITextFieldDelegate
// 开始textField是调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // [textField becomeFirstResponder];
    self.keyBoardStatus = YES;
}

// 结束textField时调用
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textFied = textField;
    if ([self.delegate respondsToSelector:@selector(textInputFinished:)]) {
        
        [self.delegate textInputFinished:textField.text];
//        self.textFied = nil;
    }

}

// 点击return时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textInputFinished:)]) {
        [self.delegate textInputFinished:self.textFied.text];
//        self.textFied = nil;
    }
    
    return YES;
}

- (BOOL)switchKeyBoard
{
    BOOL isSucess;
    if (self.keyBoardStatus) {
        
        isSucess = [self.textFied resignFirstResponder];
        self.keyBoardStatus = !self.keyBoardStatus;
    }else{
        isSucess = [self.textFied becomeFirstResponder];
    }
    return isSucess;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textFied.frame = CGRectMake(10, 5, self.bounds.size.width-60, self.bounds.size.height-10);
    self.send.frame = CGRectMake(CGRectGetMaxX(self.textFied.frame)+3, 5, 50, self.bounds.size.height-10);
}

// 弹出键盘
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // 键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyBoardFrame.origin.y;
    CGRect rect = CGRectMake(self.frame.origin.x, height-44, self.frame.size.width, self.frame.size.height);
    self.frame = rect;

    if ([self.delegate respondsToSelector:@selector(textHeight:)]) {
        
        [self.delegate textHeight:height];
    }
}

// 隐藏键盘
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // 键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyBoardFrame.origin.y;
    CGRect rect = CGRectMake(self.frame.origin.x, height-44, self.frame.size.width, self.frame.size.height);
    self.frame = rect;
    
    if ([self.delegate respondsToSelector:@selector(textHeight:)]) {
        
        [self.delegate textHeight:height];
    }
}

// 移除通知中心
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (TextInputView *)initWithKeyBoardViewAndAddDelegate:(id)delegate
{
    if ([delegate isKindOfClass:[UIViewController class]]) {
        
        UIViewController *vc = (UIViewController *)delegate;
        TextInputView *key = [[TextInputView alloc] initWithFrame:CGRectMake(0, vc.view.bounds.size.height - 44, vc.view.bounds.size.width, 44)];
        key.delegate = delegate;
        [vc.view addSubview:key];
        return key;
    }
    return nil;
}

#pragma mark -- 语音按钮
- (void)EventTouchDown:(UIButton *)sender
{
    [self.record playEventTouchDown];
}

- (void)TouchUpInside:(UIButton *)sender
{
    [self.record playTouchUpInside];
}

- (void)DragExit:(UIButton *)sender
{
    [self.record playDragExit];
}

- (void)removeFromView:(UIButton *)sender
{
    [self.record playerRecordByPath:nil];
}

- (void)getBase64Str:(NSString *)baseStr
{
    if ([self.delegate respondsToSelector:@selector(textInputFinished:)]) {
        [self.delegate textInputFinished:baseStr];
        //        self.textFied = nil;
    }
    NSLog(@"baseStr = %@", baseStr);
}

@end
