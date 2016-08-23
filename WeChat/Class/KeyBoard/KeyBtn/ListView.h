//
//  ListView.h
//  EmojiKey-自定义键盘
//
//  Created by ZhaoJM on 15/12/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListViewDelegate <NSObject>
- (void)emojiDic:(NSDictionary *)dic;
@end

@interface ListView : UIView
@property (nonatomic, weak) id <ListViewDelegate>delegate;
@property (nonatomic, strong) NSArray *emojis;
@end
