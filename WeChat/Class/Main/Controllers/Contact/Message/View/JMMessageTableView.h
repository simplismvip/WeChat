//
//  JMMessageTableView.h
//  WeChat
//
//  Created by JM Zhao on 16/8/11.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QqModel;
@interface JMMessageTableView : UITableView
/**
 *  初始化JMMessageTableView
 *
 *  @param viewC     父控制器
 *  @param dataArray 装有模型的数组
 *
 *  @return 返回自身
 */
+ (instancetype)initMessageTableView:(UIViewController *)viewC dataArray:(NSMutableArray<QqModel *> *)modelArray;

- (void)tableViewFrameSet:(CGFloat)height;
- (void)refrashByModel:(QqModel *)model;
@property (nonatomic, strong) NSMutableArray<QqModel *> *modelArray;

@end
