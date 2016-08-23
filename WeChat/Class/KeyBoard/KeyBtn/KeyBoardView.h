//
//  KeyBoardView.h
//  EmojiKey-自定义键盘
//
//  Created by ZhaoJM on 15/12/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardViewDelegate <NSObject>
- (void)KeyBoardViewDic:(NSDictionary *)dic;
@end

@interface KeyBoardView : UIView
@property (nonatomic, weak) id <KeyBoardViewDelegate>delegate;
@end
