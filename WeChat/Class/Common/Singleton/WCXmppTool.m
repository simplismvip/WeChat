//
//  WCXmppTool.m
//  WeChat
//
//  Created by lanouhn on 16/2/29.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCXmppTool.h"

@interface WCXmppTool ()<XMPPStreamDelegate>
{
    
    XMPPResultBlack _resultBlack;
    XMPPResultBlack _resignBlack;
    
    // 电子名片模块
    XMPPvCardCoreDataStorage *_vCardStorage;// 电子名片的数据存储
    XMPPvCardAvatarModule *_vCardAvatar;// 头像模块
    XMPPReconnect *_reconnect;
    
    
}

// 1> 初始化XMPPStream
- (void)setUpXMPPStream;

// 2> 连接到服务器
- (void)connectDidToHost;

// 3> 连接到服务器成功后在发送密码授权
- (void)sendPwdToHost;

// 4> 授权成功后发送在线消息
- (void)sendOnlineToHost;

@end


@implementation WCXmppTool

// 创建单例类
singleton_implementation(WCXmppTool)

#pragma mark -- 私有方法
// 1> 初始化XMPPStream
- (void)setUpXMPPStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
    // 创建电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];// 激活
    
    // 头像模块
    _vCardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_vCardAvatar activate:_xmppStream];// 激活
    
    // 自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];// 激活
    
    // 添加花名册模块
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    // 消息模块
    self.messageArchingStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    self.messageArching = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.messageArchingStorage];
    [self.messageArching activate:_xmppStream];
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark -- 释放XMPP相关资源
- (void)tearDownXmpp
{
    // 1> 移除代理
    [_xmppStream removeDelegate:self];
    
    // 2> 停止代理
    [_reconnect deactivate];
    [_vCard deactivate];
    [_vCardAvatar deactivate];
    [_roster deactivate];
    [_messageArching deactivate];
    
    // 3> 断开连接
    [_xmppStream disconnect];
    
    // 4> 清空资源
    _vCardAvatar = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _reconnect = nil;
    _roster = nil;
    _rosterStorage = nil;
    _messageArching = nil;
    _messageArchingStorage = nil;
    _xmppStream = nil;
}


// 2> 连接到服务器
- (void)connectDidToHost
{
    if (!_xmppStream) {
        
        [self setUpXMPPStream];
    }
    
    // 在登录或者注册之前先做判断是登陆还是注册
    NSString *user = nil;
    if (self.isResignOpertion) {
        // 来到这里是注册
        user = [WCUserInfo sharedWCUserInfo].resignUser;
        
    }else {
        
        // 登陆首先需要从单例获取密码/用户名
        user = [WCUserInfo sharedWCUserInfo].user;
    }
    
    // 登录到相应账户需要设置JID(账户名)和主机名, 端口号
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:@"tonyzhao.local" resource:@"iphone"];
    _xmppStream.myJID = jid;
    _xmppStream.hostName = @"192.168.1.107";
    _xmppStream.hostPort = 5222;
    
    NSError *err = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        
        WCLog(@"%@", err);
    }
    
    
}

// 3> 连接到服务器成功后在发送密码授权
- (void)sendPwdToHost
{
    // 发送密码
    NSError *err = nil;
    
    // 首先获取密码
    NSString *pwd = [WCUserInfo sharedWCUserInfo].pwd;
    
    [_xmppStream authenticateWithPassword:pwd error:&err];
}



// 4> 授权成功后发送在线消息
- (void)sendOnlineToHost
{
    XMPPPresence *presence = [XMPPPresence presence];
    
    [_xmppStream sendElement:presence];
}


#pragma mark -- XMPP代理, 登陆成功/失败代理
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    WCLog(@"与主机连接成功");
    
    if (self.isResignOpertion) {
        
        [_xmppStream registerWithPassword:[WCUserInfo sharedWCUserInfo].resignPwd error:nil];
        
    }else {
        
        // 只有和主机连接成功后在发送密码
        [self sendPwdToHost];
    }
}


- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    
    WCLog(@"与主机断开连接 %@", error);
    
    if (error && _resultBlack) {
        
        _resultBlack(XMPPResultTypeNetErr);
    }
    
}


#pragma mark -- XMPP代理, 发送密码授权成功/失败代理
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    WCLog(@"授权成功");
    
    // 授权成功之后也进行一次回调, 让由WCOtherLoginController发起的登陆请求回到WCOtherLoginController里面处理, 而不是在这里处理
    if (_resultBlack) {
        
        _resultBlack(XMPPResultTypeSucess);
    }
    
    // 授权成功后发送在线消息
    [self sendOnlineToHost];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    WCLog(@"授权失败 %@", error);
    
    if (_resultBlack) {
        
        _resultBlack(XMPPResultTypeFailure);
    }
}


#pragma maek - 注册代理方法 成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    WCLog(@"注册成功");
    if (_resign) {
        
        _resignBlack(XMPPResultTypeResignSucess);
    }
}

#pragma maek - 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    WCLog(@"注册失败");
    if (_resign) {
        
        _resignBlack(XMPPResultTypeResignFailure);
    }
    
}


#pragma mark -- 公共方法
// 注销方法
- (void)logOut
{
    // 1> 发送离线消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:offline];
    
    // 2> 与服务器断开连接
    [_xmppStream disconnect];
    
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    // 退出登陆之后更改用户的登录状态为YES
    [WCUserInfo sharedWCUserInfo].loginStatus = NO;
    
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
}


#pragma maek -- 用户登录方法
- (void)login:(XMPPResultBlack)resultBlack
{
    // 每次连接账户之前要先断开之前连接, 因为只要先前连接不断开就没法在进行连接
    [_xmppStream disconnect];
    
    // 拿到block的结果存起来
    _resultBlack = resultBlack;
    
    // 连接到主机
    [self connectDidToHost];
}

#pragma maek -- 用户注册方法
- (void)resign:(XMPPResultBlack)resignBlack
{
    //还是注册之前先断开之前连接
    [_xmppStream disconnect];
    
    // 保存一下block
    _resignBlack = resignBlack;
    
    // 连接服务器发送注册消息
    [self connectDidToHost];
    
}


- (void)dealloc
{
    [self tearDownXmpp];

}

@end
