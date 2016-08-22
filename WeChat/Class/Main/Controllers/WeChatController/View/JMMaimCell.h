//
//  JMMaimCell.h
//  WeChat
//
//  Created by JM Zhao on 16/8/10.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewModel;
@interface JMMaimCell : UITableViewCell

@property (nonatomic, strong) MainViewModel *model;
+ (instancetype)contactCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
