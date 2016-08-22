//
//  WCXmppTool.h
//  WeChat
//
//  Created by lanouhn on 16/2/29.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"
// 实现回调
typedef enum {
    
    XMPPResultTypeSucess,// 登陆成功
    XMPPResultTypeFailure,// 登录失败
    XMPPResultTypeNetErr,// 网络错误
    XMPPResultTypeResignSucess,// 注册成功
    XMPPResultTypeResignFailure// 注册失败
    
}XMPPResultType;

typedef void (^XMPPResultBlack)(XMPPResultType type);



@interface WCXmppTool : NSObject

singleton_interface(WCXmppTool)

/**
 *标记是否是注册操作, YES为注册, NO为登陆
 */
@property (nonatomic, assign, getter=isResignOpertion) BOOL resign;
@property (nonatomic, strong) XMPPvCardTempModule *vCard;// 电子名片
@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterStorage;// 花名册数据存储
@property (nonatomic, strong) XMPPRoster *roster;// 花名册模块

// 发送聊天数据模块
@property (nonatomic, strong) XMPPMessageArchiving *messageArching;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *messageArchingStorage;
@property (nonatomic, strong) XMPPStream *xmppStream;
// 用户登录方法
- (void)login:(XMPPResultBlack)resultBlack;

// 用户注册方法
- (void)resign:(XMPPResultBlack)resignBlack;

// 注销
- (void)logOut;


@end
