//
//  JMArrayHelper.m
//  WeChat
//
//  Created by JM Zhao on 16/8/10.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMArrayHelper.h"
#import "pinyin.h"

@implementation JMArrayHelper

// 1> 对取出的数组进行分组
+ (NSMutableArray *)getSubArrayFromSuperArray:(NSArray *)superArray
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:superArray];
    NSMutableArray *targetArray = [@[] mutableCopy];
    for (int i = 0; i < array.count; i ++) {
        
        id model = array[i];
        NSString *string = [[model nickname] uppercasePinYinFirstLetter];
        
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:model];
        
        for (int j = i+1; j < array.count; j ++) {
            
            id model = array[j];
            NSString *jstring = [[model nickname] uppercasePinYinFirstLetter];
            if([string isEqualToString:jstring]){
                
                [tempArray addObject:model];
                [array removeObjectAtIndex:j];
                j -= 1;
            }
        }
        
        [targetArray addObject:tempArray];
    }
    return targetArray;
}

// 2> 对分组的数组按字母排序
+ (NSMutableArray *)sortArray:(NSMutableArray *)dataArray
{
    // 对获得数组进行一次冒泡排序
    NSInteger number = dataArray.count;
    for (int i = 0; i < number-1; i ++) {
        for (int j = 0; j < number-i-1; j++) {
            
            NSMutableArray *subArr = dataArray[j];
            id model = subArr.firstObject;
            NSString *name = [[model nickname] uppercasePinYinFirstLetter];
            
            NSMutableArray *subArr1 = dataArray[j+1];
            id model1 = subArr1.firstObject;
            NSString *name1 = [[model1 nickname] uppercasePinYinFirstLetter];
            
            if (name>name1) {
                
                NSMutableArray *temp = subArr;
                [dataArray replaceObjectAtIndex:j withObject:subArr1];
                [dataArray replaceObjectAtIndex:j+1 withObject:temp];
            }
        }
    }
    
    return dataArray;
}

@end
