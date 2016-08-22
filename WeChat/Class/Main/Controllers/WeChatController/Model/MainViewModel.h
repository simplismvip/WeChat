//
//  MainViewModel.h
//  WeChat
//
//  Created by JM Zhao on 16/8/10.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "Tool_FMDBModel.h"

@interface MainViewModel : Tool_FMDBModel
@property(nonatomic, copy)NSString *weChatNumber;
@property(nonatomic, copy)NSString *nickname;
@property(nonatomic, copy)NSString *sectionNum;
@property(nonatomic, weak)NSData *photo;
@property(nonatomic, copy)NSString *jidStr;
@property(nonatomic, copy)NSString *number;
@end
