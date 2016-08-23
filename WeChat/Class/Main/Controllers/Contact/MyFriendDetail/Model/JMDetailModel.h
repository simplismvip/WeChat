//
//  JMDetailModel.h
//  WeChat
//
//  Created by JM Zhao on 16/8/23.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMDetailModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, strong) NSArray *imageArr;
@end
