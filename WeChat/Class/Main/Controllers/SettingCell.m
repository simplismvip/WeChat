//
//  SettingCell.m
//  SettIngView
//
//  Created by JM Zhao on 16/7/29.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell()
@property (nonatomic, weak) UIImageView *leftView;
@property (nonatomic, strong) NSArray *imageName;
@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置背景透明
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor blackColor];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 25, 25)];
        [self.contentView addSubview:image];
        self.leftView = image;
        
        self.setLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+5, 2, 100, 40)];
        [self.contentView addSubview:self.setLabel];
        self.imageName = @[@[@"set"], @[@"saveStar"], @[@"books"], @[@"list"], @[@"tribune"], @[@"logout"]];
    }
    
    return self;
}

+ (SettingCell *)lrcCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {cell = [[SettingCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    
    if (indexPath.section==0) {
        
        [self addsubViews:cell];
    }else{
    
        NSArray *name = cell.imageName[indexPath.section-1];
        cell.leftView.image = [UIImage imageNamed:name[indexPath.row]];
    }
    
    return cell;
}

+ (void)addsubViews:(SettingCell *)cell
{
    
    [cell.leftView removeFromSuperview];
    [cell.setLabel removeFromSuperview];
    CGRect rect = [UIScreen mainScreen].bounds;
    
    UIButton *left = [UIButton buttonWithType:(UIButtonTypeSystem)];
    left.tag = 1000;
    left.frame = CGRectMake(0, 0, rect.size.width/2, 44);
    [left setTintColor:[UIColor blackColor]];
    [left addTarget:cell action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [left setImage:[UIImage imageNamed:@"alumb"] forState:(UIControlStateNormal)];
    [left setTitle:@"相册" forState:(UIControlStateNormal)];
    left.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [cell.contentView addSubview:left];
    
    UIView *image = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(left.frame), 5, 3, 35)];
    image.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:image];
    
    UIButton *right = [UIButton buttonWithType:(UIButtonTypeSystem)];
    right.tag = 1001;
    right.frame = CGRectMake(CGRectGetMaxX(image.frame), 0, rect.size.width/2, 44);
    [right setTintColor:[UIColor blackColor]];
    [right addTarget:cell action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [right setImage:[UIImage imageNamed:@"cloud"] forState:(UIControlStateNormal)];
    [right setTitle:@"云共享" forState:(UIControlStateNormal)];
    right.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [cell.contentView addSubview:right];
}

// 按钮
- (void)clickBtn:(UIButton *)sender {
    
    if (sender.tag == 1000) {
        
        if ([self.delegate respondsToSelector:@selector(albumClick)]) {[self.delegate albumClick];}
        
    }else if (sender.tag == 1001) {
        
        if ([self.delegate respondsToSelector:@selector(cloudShareClick)]) {[self.delegate cloudShareClick];}
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
