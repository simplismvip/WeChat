//
//  ContactCell.h
//  ContactSQLite-聊天界面数据库设计
//
//  Created by JM Zhao on 16/7/7.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ContactModel;
@interface ContactCell : UITableViewCell

@property (nonatomic, strong) ContactModel *model;
+ (instancetype)contactCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
