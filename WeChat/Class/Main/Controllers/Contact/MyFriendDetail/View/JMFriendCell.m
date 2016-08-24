//
//  JMFriendCell.m
//  WeChat
//
//  Created by JM Zhao on 16/8/21.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMFriendCell.h"
#import "JMDetailModel.h"
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@implementation JMFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置背景透明
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor blackColor];
    }
    
    return self;
}

+ (JMFriendCell *)lrcCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dataArr:(NSMutableArray *)dataArr;
{
    static NSString *ID = @"Detailcell";
    JMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[JMFriendCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    
    JMDetailModel *model = dataArr[indexPath.section][indexPath.row];
    cell.textLabel.text = model.title;
    [cell addSubViews:cell IndexPath:indexPath model:model];
    
    if (indexPath.section == 3) {cell.selectionStyle = UITableViewCellSelectionStyleNone;}
    else{cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;}
    
    
    return cell;
}

- (void)addSubViews:(JMFriendCell *)cell IndexPath:(NSIndexPath *)indexpath model:(JMDetailModel *)model
{
    CGFloat edge = 3.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSArray *array = @[@"发送消息", @"删除"];
    CGFloat imageW = (width-150)/4;
    CGFloat x = 100.0;
    
    if (indexpath.section == 0) {
        
        UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(edge*4, edge, 54, 54)];
        UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(header.frame)+edge*2, edge, width*0.5, 27)];
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(header.frame)+edge*2, CGRectGetMaxY(nickLabel.frame), width*0.5, 27)];
        
        header.image = [UIImage imageNamed:model.header];
        nickLabel.text = model.nickName;
        numberLabel.text = [NSString stringWithFormat:@"微信号: %@", model.number];
        numberLabel.font = [UIFont systemFontOfSize:13];
        numberLabel.textColor = [UIColor grayColor];
        
        [cell.contentView addSubview:header];
        [cell.contentView addSubview:nickLabel];
        [cell.contentView addSubview:numberLabel];
        
    }else if (indexpath.section == 3) {
        
        cell.backgroundColor = [UIColor clearColor];
        UIButton *message = [UIButton buttonWithType:(UIButtonTypeSystem)];
        message.tag = indexpath.row*1000;
        [message setTintColor:[UIColor blackColor]];
        message.frame = CGRectMake(width*0.1, edge, width*0.8, 38);
        [message addTarget:self action:@selector(messageBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [message setTitle:array[indexpath.row] forState:(UIControlStateNormal)];
        message.layer.borderWidth = 1;
        message.layer.borderColor = [UIColor grayColor].CGColor;
        message.layer.masksToBounds = YES;
        message.layer.cornerRadius = 9;
        [cell.contentView addSubview:message];
        
    }else if (indexpath.section == 2) {
        
        if (indexpath.row == 0) {
            
            UILabel *region = [[UILabel alloc] initWithFrame:CGRectMake(x, edge, 80, 38)];
            [cell.contentView addSubview:region];
            region.text = model.region;
            
        }else if(indexpath.row == 1) {
            
            int i = 0;
            for (NSString *imageString in model.imageArr) {
                
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(x+(edge+imageW)*i, edge*2, imageW, 68)];
                imageV.image = [UIImage imageNamed:imageString];
                [self.contentView addSubview:imageV];
                
                i ++;
            }
        }
    }
    
}

- (void)messageBtn:(UIButton *)sender
{
    if (sender.tag/1000 == 0) {
        
        if ([self.delegate respondsToSelector:@selector(btnAction:)]) {
            
            [self.delegate btnAction:btnMessage];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(btnAction:)]) {
            
            [self.delegate btnAction:btnDelete];
        }
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
