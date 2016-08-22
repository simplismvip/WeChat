//
//  WCEditProfireViewController.h
//  WeChat
//
//  Created by lanouhn on 16/3/1.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCEditProfireViewController <NSObject>

- (void)editProfireViewControllerDidSave;

@end

@interface WCEditProfireViewController : UITableViewController
@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, strong) id<WCEditProfireViewController> deldegate;
@end
