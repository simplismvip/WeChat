//
//  QqFrameModel.m
//  
//
//  Created by Mac on 16/1/21.
//
//

#import "QqFrameModel.h"
#define czBtnFontSize [UIFont systemFontOfSize:15.0f]
#define CZTextPadding 20


@implementation QqFrameModel

- (void)setMessage:(QqModel *)message
{
    _message = message;
    
    CGFloat s = [UIScreen mainScreen].bounds.size.width;
    CGFloat m = 10;
    
    // 设置时间
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = 320;
    CGFloat timeH = 30;
    _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    // 设置头像
    CGFloat iconX = 0;
    CGFloat iconY = CGRectGetMaxY(_timeF);
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    switch (message.messageFrom) {
        case MessageFromOther:
            
            iconX = s - iconW - m;
            break;
            
        case MessageFromMe:
            
            iconX = m;
            break;
        default:
            break;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    // 设置正文
    NSDictionary *dic = @{NSFontAttributeName:czBtnFontSize};
    
    CGSize textSize = [message.msgContent boundingRectWithSize:CGSizeMake(150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGSize lastSize = CGSizeMake(textSize.width + CZTextPadding * 2, textSize.height + CZTextPadding * 2);
    CGFloat textX;
    CGFloat textY = iconY;
    switch (message.messageFrom) {
        case MessageFromOther:
            
            textX = s - iconW - lastSize.width - m * 2;
            
            break;
        case MessageFromMe:
            textX = iconW + 2 * m;
            break;
        default:
            break;
    }
    
    _textF = (CGRect){{textX, textY}, lastSize};
    
    // 设置cell高度
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    CGFloat textMaxY = CGRectGetMaxY(_textF);
    _cellHeight = MAX(iconMaxY, textMaxY);
    
    
}


@end
