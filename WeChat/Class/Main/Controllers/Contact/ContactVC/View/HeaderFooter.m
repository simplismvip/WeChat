//
//  HeaderFooter.m
//  FileManger
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "HeaderFooter.h"

@interface HeaderFooter ()
@property (nonatomic, weak) UILabel *name;
@end

@implementation HeaderFooter

// 创建headview
+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *headID = @"header";
    HeaderFooter *headView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    if (headView == nil) {
        
        headView = [[HeaderFooter alloc] initWithReuseIdentifier:headID];
        CGFloat f = 250 / 255.0;
        headView.contentView.backgroundColor = [UIColor colorWithRed:f green:f blue:f alpha:1.0];
    }
    
    return headView;
}

// 重用headView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:name];
        name.textAlignment = NSTextAlignmentLeft;
        self.name = name;
    }
    return self;
}


-(void)setGroups:(NSString *)groups
{
    _groups = groups;
    self.name.text = [NSString stringWithFormat:@"%@", groups];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat w = self.contentView.bounds.size.width;
    CGFloat h = 30;
    self.name.frame = CGRectMake(x, y, w*0.2, h);
}

@end
