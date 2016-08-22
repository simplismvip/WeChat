//
//  WCResignController.h
//  WeChat
//
//  Created by lanouhn on 16/2/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  WCResignControllerDelegate <NSObject>

- (void)regisgerViewControllerDidfinish;

@end

@interface WCResignController : UIViewController
@property (nonatomic, weak) id<WCResignControllerDelegate> delegate;
@end
