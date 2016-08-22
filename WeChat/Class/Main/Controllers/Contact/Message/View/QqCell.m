//
//  QqCell.m
//  
//
//  Created by Mac on 16/1/21.
//
//

#import "QqCell.h"
#import "QqModel.h"
#import "QqFrameModel.h"

@interface QqCell ()
@property (nonatomic, weak) UILabel *timeL;
@property (nonatomic, weak) UIImageView *iconV;
@property (nonatomic, weak) UIButton *textB;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArr;
@end

@implementation QqCell

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        
        self.modelArr = [NSMutableArray array];
    }
    
    return _modelArr;
}

+ (QqCell *)initQqCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath array:(NSMutableArray *)array
{
    static NSString *ID = @"MessageCell";
    QqCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {cell = [[QqCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    
    cell.tableView = tableView;
    cell.modelArr = array;
    cell.messageFrame = array[indexPath.row];
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *timeL = [[UILabel alloc] init];
        timeL.textColor = [UIColor blackColor];
        timeL.textAlignment = 1;
        timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:timeL];
        self.timeL = timeL;
        
        UIButton *textB = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [textB setTintColor:[UIColor blackColor]];
        [self.contentView addSubview:textB];
        textB.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        textB.titleLabel.numberOfLines = 0;//自动换行
        [textB addTarget:self action:@selector(clickMessage:event:) forControlEvents:(UIControlEventTouchUpInside)];
        self.textB = textB;
        
        UIImageView *iconV = [[UIImageView alloc] init];
        [self.contentView addSubview:iconV];
        self.iconV = iconV;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


// 设置frame大小
- (void)setMessageFrame:(QqFrameModel *)messageFrame
{
    _messageFrame = messageFrame;
    
    // frame模型里面有数据模型
    QqModel *model = messageFrame.message;
    
    self.textB.frame = _messageFrame.textF;
    switch (model.messageType) {
        case MessageTypeText:
            
            [self textMessage:model];
            NSLog(@"字符串");
            break;
            
        case MessageTypeImage:
            [self voiceMessage:model];
            NSLog(@"照片");
            break;
            
        case MessageTypeVoice:
            [self imageMessage:model];
            NSLog(@"声音");
            break;
            
        default:
            break;
    }
    
    self.iconV.frame = _messageFrame.iconF;
    
    // 时间
    self.timeL.frame = _messageFrame.timeF;
    self.timeL.text = model.sendTime;

}

- (void)textMessage:(QqModel *)model
{
    [self.textB setTitle:model.msgContent forState:(UIControlStateNormal)];
    
    // 这里需要做判断, 看是哪个人发过来的消息
    switch (model.messageFrom) {
        case MessageFromOther:
            [self.textB setBackgroundImage:[self resizeImageWithName:@"chat_send_nor"] forState:(UIControlStateNormal)];
            self.iconV.image = [UIImage imageNamed:@"ironMan"];
            break;
            
        case MessageFromMe:
            [self.textB setBackgroundImage:[self resizeImageWithName:@"chat_recive_nor"] forState:(UIControlStateNormal)];
            self.iconV.image = [UIImage imageNamed:@"yaoyao"];
            break;
            
        default:
            break;
    }
}

- (void)voiceMessage:(QqModel *)model
{
    [self.textB setTitle:@"voice" forState:(UIControlStateNormal)];
    
    UIImageView *voice = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    voice.image = [UIImage imageNamed:@"voice-32"];
    [self.textB addSubview:voice];
    
    // 这里需要做判断, 看是哪个人发过来的消息
    switch (model.messageFrom) {
        case MessageFromOther:
            [self.textB setBackgroundImage:[self resizeImageWithName:@"chat_send_nor"] forState:(UIControlStateNormal)];
            self.iconV.image = [UIImage imageNamed:@"ironMan"];
            break;
            
        case MessageFromMe:
            [self.textB setBackgroundImage:[self resizeImageWithName:@"chat_recive_nor"] forState:(UIControlStateNormal)];
            self.iconV.image = [UIImage imageNamed:@"yaoyao"];
            break;
            
        default:
            break;
    }
}

- (void)imageMessage:(QqModel *)model
{
    // 这里需要做判断, 看是哪个人发过来的消息
    switch (model.messageFrom) {
        case MessageFromOther:
            [self.textB setBackgroundImage:[self resizeImageWithName:model.imageName] forState:(UIControlStateNormal)];
            self.iconV.image = [UIImage imageNamed:@"ironMan"];
            break;
            
        case MessageFromMe:
            [self.textB setBackgroundImage:[self resizeImageWithName:model.imageName] forState:(UIControlStateNormal)];
            self.iconV.image = [UIImage imageNamed:@"yaoyao"];
            break;
            
        default:
            break;
    }
}

- (void)clickMessage:(UIButton *)sender event:(id)event
{
    
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        
        QqFrameModel *af = self.modelArr[indexPath.row];
        QqModel *msg = af.message;
        
        NSLog(@"%@", msg.msgContent);
        NSLog(@"%ld", indexPath.row);
    }
    
}

- (UIImage *)resizeImageWithName:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width*0.5f - 1;
    CGFloat h = normal.size.height*0.5f - 1;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}



@end
