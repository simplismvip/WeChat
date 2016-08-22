//
//  RecorderTool.h
//  Reco--录音
//
//  Created by lanouhn on 16/3/4.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;
typedef void (^removeFromView)(UIView *superView, UIView *subView);
typedef void(^base64String)(NSString *base64);

@protocol RecorderToolDelegate <NSObject>
- (void)getBase64Str:(NSString *)baseStr;
@end

@interface RecorderTool : NSObject

#pragma mark -- 将文件转成base64并发送
+ (NSString *)transformToBase64:(NSURL *)sendStr type:(NSString *)type;

#pragma mark -- 将base64转成音频文件并返回地址
+ (NSString *)transfromByBase64:(NSString *)getString;

- (void)playDragExit;
- (void)playEventTouchDown;
- (void)playTouchUpInside;
- (void)playerRecordByPath:(NSString *)path;
- (BOOL)initWithFileRecorderWithName:(NSString *)path;
@property (nonatomic, weak) id <RecorderToolDelegate>delegateRec;
@property (nonatomic, assign) removeFromView removeBlock;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) UIView *subView;
@end
