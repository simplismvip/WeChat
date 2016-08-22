//
//  JMFriendCell.m
//  WeChat
//
//  Created by JM Zhao on 16/8/21.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMFriendCell.h"

@implementation JMFriendCell

+ (instancetype)friendCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    JMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[JMFriendCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    [self addsubViews:indexPath cell:cell];
    
    return cell;
}

+ (void)addsubViews:(NSIndexPath *)indexPath cell:(JMFriendCell *)cell
{
    switch (indexPath.section) {
        case 0:
            
            
            
            break;
            
        case 1:
            
            
            break;
            
        case 2:
            
            
            break;
            
        case 3:
            
            
            break;
            
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
   // UIImageView *headerPhoto = [UIImageView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
