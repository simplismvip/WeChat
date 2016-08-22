//
//  ContactCell.m
//  ContactSQLite-聊天界面数据库设计
//
//  Created by JM Zhao on 16/7/7.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "ContactCell.h"
#import "ContactModel.h"
#import "NSString+Extension.h"

@interface ContactCell()
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UIImageView *photo;
@end

@implementation ContactCell

- (void)setModel:(ContactModel *)model
{
    _model = model;
    self.name.text = model.nickname;
    
    UIImage *image = [UIImage imageWithData:model.photo];
    if (image == nil) {self.photo.image = [UIImage imageNamed:@"header"];}
    else{self.photo.image = image;}
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:name];
        self.name = name;
        
        UIImageView *image = [[UIImageView alloc] init];
        [self.contentView addSubview:image];
        self.photo = image;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat edgeLeft = 10;
    CGFloat edgeRight = 10;
    CGFloat edgeTop = 3;
    CGFloat width = self.bounds.size.width*0.7;
    CGFloat height = self.bounds.size.height-6;
    
    self.photo.frame = CGRectMake(edgeLeft, edgeTop, height, height);
    self.name.frame = CGRectMake(CGRectGetMaxX(self.photo.frame)+edgeRight, edgeTop, width, height);
    
}

+ (instancetype)contactCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[ContactCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
