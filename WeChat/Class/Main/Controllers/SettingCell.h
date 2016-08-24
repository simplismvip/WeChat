//
//  SettingCell.h
//  SettIngView
//
//  Created by JM Zhao on 16/7/29.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingCellDelegate <NSObject>
- (void)cloudShareClick;
- (void)albumClick;
@end

@interface SettingCell : UITableViewCell
@property (nonatomic, strong) UILabel *setLabel;
@property (nonatomic, weak) id<SettingCellDelegate>delegate;

+ (SettingCell *)lrcCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
