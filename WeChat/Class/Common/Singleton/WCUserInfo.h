//
//  WCUserInfo.h
//  WeChat
//
//  Created by lanouhn on 16/2/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

static NSString *domain = @"tonyzhao.local";
@interface WCUserInfo : NSObject

singleton_interface(WCUserInfo);

@property (nonatomic, copy) NSString *user;//用户名
@property (nonatomic, copy) NSString *pwd;//密码

@property (nonatomic, copy) NSString *resignUser;
@property (nonatomic, copy) NSString *resignPwd;

@property (nonatomic, copy) NSString *jid;

/**
 *  登录的状态 YES 登录过/NO 注销
 */
@property (nonatomic, assign) BOOL  loginStatus;

/**
 *  从沙盒里获取用户数据
 */
-(void)loadUserInfoFromSanbox;

/**
 *  保存用户数据到沙盒
 
 */
-(void)saveUserInfoToSanbox;
@end

