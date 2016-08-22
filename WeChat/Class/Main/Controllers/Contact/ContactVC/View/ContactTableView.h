//
//  ContactTableView.h
//  Contacts
//
//  Created by JM Zhao on 16/7/8.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactTableViewDelegate <NSObject>
@optional
- (void)historyUrl:(NSURL *)url;
- (void)callBackKeyBoard;
@end

@interface ContactTableView : UITableView

@property (nonatomic, weak) id <ContactTableViewDelegate>contactDelegate;
+ (instancetype)initContactTableView:(UIView *)view dataArray:(NSMutableArray *)dataArray addDelegate:(id)conDelegate;
//- (void)relodData;
@end
