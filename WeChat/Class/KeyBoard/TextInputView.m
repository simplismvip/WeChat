//
//  KeyBoardView.m
//  CustomKeyBoard-自定义键盘输入框
//
//  Created by Mac on 16/6/15.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "TextInputView.h"
#import "KeyBoardView.h"
#import "UIView+Extension.h"
#import "InputImageView.h"
#import "RecorderTool.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface TextInputView ()<UITextFieldDelegate, KeyBoardViewDelegate, RecorderToolDelegate>
@property (nonatomic, weak) UIButton *send;
@property (nonatomic, weak) UIButton *emoji;
@property (nonatomic, weak) UIButton *voice;
@property (nonatomic, weak) UIButton *recordBtn;
@property (nonatomic, weak) UITextField *textFied;
@property (nonatomic, copy) NSString *emojiStr;
@property (nonatomic, assign) BOOL keyBoardStatus;
@property (nonatomic, assign) BOOL isVoice;
@property (nonatomic, strong) RecorderTool *record;
@end

@implementation TextInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.keyBoardStatus = NO;
        self.isVoice = NO;
        self.backgroundColor = JMColor(232, 233, 235);
        
        // voice按钮
        UIButton *voice = [UIButton buttonWithType:(UIButtonTypeSystem)];
        UIImage *bacImage = [UIImage imageNamed:@"voice"];
        [voice setImage:[bacImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
        [voice addTarget:self action:@selector(voiceAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:voice];
        self.voice = voice;
        
        // 输入框
        UITextField *textFied = [[UITextField alloc] init];
        textFied.borderStyle = UITextBorderStyleRoundedRect;
        textFied.delegate = self;
        [textFied becomeFirstResponder];
        textFied.backgroundColor = JMColor(242, 243, 245);
        [self addSubview:textFied];
        self.textFied = textFied;
        
        // voice按钮
        UIButton *emoji = [UIButton buttonWithType:(UIButtonTypeSystem)];
        UIImage *emojiImage = [UIImage imageNamed:@"emoji"];
//        emoji.backgroundColor = [UIColor redColor];
        [emoji setImage:[emojiImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
        [emoji addTarget:self action:@selector(emojiAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:emoji];
        self.emoji = emoji;
        
        // send按钮
        UIButton *send = [UIButton buttonWithType:(UIButtonTypeSystem)];
        UIImage *sendImage = [UIImage imageNamed:@"add"];
//        send.backgroundColor = [UIColor redColor];
        [send setImage:[sendImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
        [send addTarget:self action:@selector(sendAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:send];
        self.send = send;
        
        // 注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        
        // 注册键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

// 表情键盘
- (void)emojiAction:(UIButton *)emoji
{
    // 切换自定义键盘
    if (self.textFied.inputView == nil) {
        
        KeyBoardView *keyView = [[KeyBoardView alloc] init];
        keyView.height = 216;
        keyView.width = self.width;
        keyView.delegate = self;
        self.textFied.inputView = keyView;
        
        // 切换系统键盘
    }else {
        
        self.textFied.inputView = nil;
    }
    
    [self.textFied endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.textFied becomeFirstResponder];
    });

}

// 录音
- (void)voiceAction:(UIButton *)voiceR
{
    if (self.isVoice == NO) {
        
        UIButton *record = [UIButton buttonWithType:(UIButtonTypeSystem)];
        record.backgroundColor = JMColor(242, 243, 245);
        record.layer.borderWidth = 1.0;
        record.layer.borderColor = JMColor(200, 200, 200).CGColor;
        record.layer.cornerRadius = 9;
        record.layer.masksToBounds = YES;
        [record setTintColor:[UIColor blackColor]];
        [record setTitle:@"按住 说话" forState:(UIControlStateNormal)];
        [record addTarget:self action:@selector(recordAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:record];
        self.recordBtn = record;
        
        [self.textFied removeFromSuperview];
        self.isVoice = !self.isVoice;
        
    }else{
    
        // 输入框
        UITextField *textFied = [[UITextField alloc] init];
        textFied.borderStyle = UITextBorderStyleRoundedRect;
        textFied.delegate = self;
        [textFied becomeFirstResponder];
        textFied.backgroundColor = JMColor(242, 243, 245);
        [self addSubview:textFied];
        self.textFied = textFied;
        
        [self.recordBtn removeFromSuperview];
        self.isVoice = !self.isVoice;
    }
    
}

- (void)recordAction:(UIButton *)recored
{
    
}

// 点击发送响应方法
- (void)sendAction:(UIButton *)send
{
    
    // 切换自定义键盘
    if (self.textFied.inputView == nil) {
        
        InputImageView *image = [[InputImageView alloc] initWithFrame:CGRectMake(0, 80, self.width, 216)];
        
        image.height = 216;
        image.width = self.width;
        self.textFied.inputView = image;
        
        // 切换系统键盘
    }else {
        
        self.textFied.inputView = nil;
    }
    
    [self.textFied endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.textFied becomeFirstResponder];
    });

    
//    self.textFied.inputView = image;
//    
//    if ([self.delegate respondsToSelector:@selector(textInputFinished:)]) {
//        
//        [self.delegate textInputFinished:self.textFied.text];
//    }
}

#pragma mark -- UITextFieldDelegate
// 开始textField是调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
    self.keyBoardStatus = YES;
}

// 结束textField时调用
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textFied = textField;
    if ([self.delegate respondsToSelector:@selector(textInputFinished:)]) {
        
        [self.delegate textInputFinished:textField.text];
    }

}

// 点击return时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textInputFinished:)]) {
        [self.delegate textInputFinished:self.textFied.text];
    }
    
    self.textFied.text = nil;
    self.emojiStr = nil;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@", string);
    
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
    CGFloat edge = 3.0;
    
    self.voice.frame = CGRectMake(edge, edge, 40, 40);
    if (self.isVoice == YES) {
        
        self.recordBtn.frame = CGRectMake(CGRectGetMaxX(self.voice.frame)+edge, 5, self.bounds.size.width-126, self.bounds.size.height-10);
        self.emoji.frame = CGRectMake(CGRectGetMaxX(self.recordBtn.frame), edge, 40, 40);

    }else{
        
        self.textFied.frame = CGRectMake(CGRectGetMaxX(self.voice.frame)+edge, edge, self.bounds.size.width-126, self.bounds.size.height-10);
        self.emoji.frame = CGRectMake(CGRectGetMaxX(self.textFied.frame), edge, 40, 40);
    }
    
    self.send.frame = CGRectMake(CGRectGetMaxX(self.emoji.frame), edge, 40, 40);
}

// 弹出键盘
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // 键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger height = keyBoardFrame.origin.y;
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
    NSInteger height = keyBoardFrame.origin.y;
    CGRect rect = CGRectMake(self.frame.origin.x, height-44, self.frame.size.width, self.frame.size.height);
    self.frame = rect;
    // [self removeFromSuperview];
    
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

- (void)KeyBoardViewDic:(NSDictionary *)dic
{
    if (self.emojiStr == nil) {self.emojiStr = dic[@"chs"];}
    else{
    
        self.emojiStr = [self.emojiStr stringByAppendingString:dic[@"chs"]];
    }
    self.textFied.text = _emojiStr;
    NSLog(@"KeyBoard = %@", dic[@"chs"]);
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
