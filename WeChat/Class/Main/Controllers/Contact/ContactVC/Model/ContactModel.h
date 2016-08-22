//
//  ContactModel.h
//  Contacts
//
//  Created by JM Zhao on 16/8/9.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "Tool_FMDBModel.h"
@interface ContactModel : Tool_FMDBModel
@property(nonatomic, copy)NSString *weChatNumber;
@property(nonatomic, copy)NSString *nickname;
@property(nonatomic, copy)NSString *sectionNum;
@property(nonatomic, weak)NSData *photo;
@property(nonatomic, copy)NSString *jidStr;
@property(nonatomic, copy)NSString *number;
@end
