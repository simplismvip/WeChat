//
//  JMFriendCell.h
//  WeChat
//
//  Created by JM Zhao on 16/8/21.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    btnMessage,
    btnDelete
}btnType;

@protocol JMFriendCellDelegate <NSObject>
- (void)btnAction:(btnType)type;
@end

@interface JMFriendCell : UITableViewCell
@property (nonatomic, weak) id<JMFriendCellDelegate>delegate;
+ (JMFriendCell *)lrcCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dataArr:(NSMutableArray *)dataArr;
@end