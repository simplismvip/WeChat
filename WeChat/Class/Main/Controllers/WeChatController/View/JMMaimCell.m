//
//  JMMaimCell.m
//  WeChat
//
//  Created by JM Zhao on 16/8/10.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMMaimCell.h"
#import "MainViewModel.h"
#import "NSString+Extension.h"

@interface JMMaimCell()
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *message;
@property (nonatomic, weak) UILabel *rightLabel;
@property (nonatomic, weak) UIImageView *photo;
@property (nonatomic, weak) UIImageView *rightImage;
@end

@implementation JMMaimCell

- (void)setModel:(MainViewModel *)model
{
    _model = model;
    self.name.text = model.nickname;
    self.rightLabel.text = @"08-07";
    self.message.text = model.weChatNumber;
    self.rightImage.image = [UIImage imageNamed:@"mute"];
    UIImage *image = [UIImage imageWithData:model.photo];
    if (image == nil) {
        
        self.photo.image = [UIImage imageNamed:@"header"];
    }else{
        self.photo.image = image;
    }
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:name];
        self.name = name;
        
        UILabel *message = [[UILabel alloc] init];
        message.textColor = [UIColor grayColor];
        message.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:message];
        self.message = message;
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = [UIColor grayColor];
        rightLabel.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:rightLabel];
        self.rightLabel = rightLabel;
        
        UIImageView *image = [[UIImageView alloc] init];
        [self.contentView addSubview:image];
        self.photo = image;
        
        UIImageView *rightImage = [[UIImageView alloc] init];
        [self.contentView addSubview:rightImage];
        self.rightImage = rightImage;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat edgeLeft = 10;
    CGFloat edgeRight = 6;
    CGFloat edgeTop = 3;
    CGFloat width = self.bounds.size.width*0.7;
    CGFloat w = self.bounds.size.width-width-52;
    CGFloat heigh = 24;
    self.photo.frame = CGRectMake(edgeLeft, edgeTop, 52, 52);
    self.name.frame = CGRectMake(CGRectGetMaxX(self.photo.frame)+edgeRight, edgeTop, width, heigh);
    self.message.frame = CGRectMake(CGRectGetMaxX(self.photo.frame)+edgeRight, CGRectGetMaxY(self.name.frame)+2, width, heigh);
    self.rightLabel.frame = CGRectMake(CGRectGetMaxX(self.message.frame)+edgeRight, edgeTop, w, heigh);
    self.rightImage.frame = CGRectMake(CGRectGetMaxX(self.message.frame)+edgeRight, CGRectGetMaxY(self.rightLabel.frame)+2, heigh*0.8, heigh*0.8);
}

+ (instancetype)contactCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Maincell";
    JMMaimCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[JMMaimCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
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
