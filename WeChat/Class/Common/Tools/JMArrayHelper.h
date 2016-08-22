//
//  JMArrayHelper.h
//  WeChat
//
//  Created by JM Zhao on 16/8/10.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMArrayHelper : NSObject

// 数组分组
+ (NSMutableArray *)getSubArrayFromSuperArray:(NSArray *)superArray;

// 数组排序
+ (NSMutableArray *)sortArray:(NSMutableArray *)dataArray;
@end
