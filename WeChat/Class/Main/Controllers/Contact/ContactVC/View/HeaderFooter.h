//
//  HeaderFooter.h
//  FileManger
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderFooter : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *groups;
+ (instancetype)headViewWithTableView:(UITableView *)tableView;
@end
