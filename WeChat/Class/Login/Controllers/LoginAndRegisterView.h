//
//  LoginAndRegisterView.h
//  LogInView
//
//  Created by JM Zhao on 16/7/14.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    loginBtnStatus,
    remPwdStatus,
    forgetPwdBtnStatus,
    registerBtnStatus,
    sinaBtnStatus,
    qqBtnStatus,
    weChatBtnStatus
} loginViewBtnStatus;

@protocol LoginAndRegisterViewDelegate <NSObject>
- (void)actionByStatus:(loginViewBtnStatus)status;
- (void)actionByremPwdn:(loginViewBtnStatus)status rem:(BOOL)isRem;
- (void)actionByLogin:(NSString *)acc pwd:(NSString *)pwd;
@end


@interface LoginAndRegisterView : UIView

@property (nonatomic, weak) id<LoginAndRegisterViewDelegate>delegate;

+ (void)initWithLoginView:(UIView *)view delegate:(id)delegate;
@end
