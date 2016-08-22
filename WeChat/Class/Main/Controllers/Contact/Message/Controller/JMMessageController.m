//
//  JMMessageController.m
//  WeChat
//
//  Created by JM Zhao on 16/8/11.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMMessageController.h"
#import "QqModel.h"
#import "MJExtension.h"
#import "JMMessageTableView.h"
#import "TextInputView.h"

#import "WCXmppTool.h"
#import "XMPPJID.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"

#import "ImageThum.h"
#import "RecorderTool.h"

@interface JMMessageController ()<XMPPStreamDelegate, TextInputViewDelegate>

@property (nonatomic, strong) JMMessageTableView *msgTable;
@property (nonatomic, strong) HttpTool *httpTool;

@end

@implementation JMMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加代理
    [[WCXmppTool sharedWCXmppTool].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 添加聊天界面
    self.msgTable = [JMMessageTableView initMessageTableView:self dataArray:nil];
    
    // 这里添加输入框
    [TextInputView initWithKeyBoardViewAndAddDelegate:self];
    
    [self loadAllMessage];
}

// 加载聊天消息
- (void)loadAllMessage
{
    // 拿到上下文找到聊天记录
    NSManagedObjectContext *content = [WCXmppTool sharedWCXmppTool].messageArchingStorage.mainThreadManagedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:content];
    [fetchRequest setEntity:entity];
    
    // 拿到对应好友的聊天记录
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@", self.jid.bare];
    [fetchRequest setPredicate:predicate];
    
    // 按照时间顺序排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    NSError *error = nil;
    NSArray *fetchedObjects = [content executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects != nil){
        
        // 如果读取到的数据为0, 直接返回
        if (fetchedObjects.count == 0) {return;}
        
        NSMutableArray *msgArr = [NSMutableArray array];
        for (XMPPMessageArchiving_Message_CoreDataObject *coreDateMessage in fetchedObjects) {
            
            XMPPMessage *message = coreDateMessage.message;
            QqModel *msg = [[QqModel alloc] init];
            
            NSArray *content = [message.body componentsSeparatedByString:@"-"];
            NSString *type = content.firstObject;
            if ([type isEqualToString:@"text"]) {
                
                msg.messageType = MessageTypeText;
                
            }else if ([type isEqualToString:@"voice"]){
                
                msg.messageType = MessageTypeVoice;
                
            }else if ([type isEqualToString:@"image"]){
                
                msg.messageType = MessageTypeImage;
            }
            
            msg.sendTime = [NSString stringWithFormat:@"%@", coreDateMessage.timestamp];
            msg.msgContent = content.lastObject;
            msg.msgFrom = [message.fromStr componentsSeparatedByString:@"/"].firstObject;
            msg.msgTo = [message.toStr componentsSeparatedByString:@"/"].firstObject;
            msg.msgDevice = [message.toStr componentsSeparatedByString:@"/"].lastObject;
            msg.msgBare = message.from.bare;
            if ([self.jid.bare isEqualToString:message.toStr]) {msg.messageFrom = MessageFromMe;}
            else{msg.messageFrom = MessageFromOther;}
            [msgArr addObject:msg];
            
        }
        
        self.msgTable.modelArray = msgArr;
    }
}

#pragma mark - TextInputViewDelegate
- (void)textInputFinished:(NSString *)string
{
    [self sendMessage:string bodyType:@"text"];
}

- (void)textHeight:(CGFloat)height
{
    [self.msgTable tableViewFrameSet:height];
}

#pragma mark -- XMPPStreamDelegate 发送消息
- (void)sendMessage:(NSString *)message bodyType:(NSString *)bodyType
{
    // 创建消息, 给XML编辑前添加一个属性
    XMPPMessage *sendMessage = [XMPPMessage messageWithType:@"chat" to:self.jid];
    [sendMessage addAttributeWithName:@"bodyType" stringValue:bodyType];
    [sendMessage addBody:message];
    [[WCXmppTool sharedWCXmppTool].xmppStream sendElement:sendMessage];
}

#pragma mark -- XMPPStreamDelegate 收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    // 判断是否发送消息的为同一个人
    if ([message.from.bare isEqualToString:self.jid.bare]) {
        
        // 判断消失是否为空
        if (message.body.length != 0) {
            
            QqModel *msg = [[QqModel alloc] init];
            NSArray *content = [message.body componentsSeparatedByString:@"-"];
            NSString *type = content.firstObject;
            if ([type isEqualToString:@"text"]) {
                
                msg.messageType = MessageTypeText;
                
            }else if ([type isEqualToString:@"voice"]){
            
                msg.messageType = MessageTypeVoice;
                
            }else if ([type isEqualToString:@"image"]){
            
                msg.messageType = MessageTypeImage;
            }
            
            msg.msgContent = content.lastObject;
            msg.messageFrom = MessageFromOther;
            msg.msgFrom = [message.fromStr componentsSeparatedByString:@"/"].firstObject;
            msg.msgTo = [message.toStr componentsSeparatedByString:@"/"].firstObject;
            msg.msgDevice = [message.toStr componentsSeparatedByString:@"/"].lastObject;
            msg.msgBare = message.from.bare;
            
            NSDate *date = [NSDate date];
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"MM-dd-HH:mm:ss";
            NSString *time = [fmt stringFromDate:date];
            msg.sendTime = time;
        
            [self sendmessageWithText:msg];
        }
    }
}

#pragma mark -- XMPPStreamDelegate 发送消息
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    
    // 如果发送消息不为空
    if (message.body.length != 0) {
        
        QqModel *msg = [[QqModel alloc] init];
        msg.msgContent = message.body;
        msg.messageFrom = MessageFromMe;
        msg.msgFrom = [message.fromStr componentsSeparatedByString:@"/"].firstObject;
        msg.msgTo = [message.toStr componentsSeparatedByString:@"/"].firstObject;
        msg.msgDevice = [message.toStr componentsSeparatedByString:@"/"].lastObject;
        msg.msgBare = message.from.bare;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM-dd-HH:mm:ss";
        NSString *time = [fmt stringFromDate:date];
        msg.sendTime = time;
        [self sendmessageWithText:msg];
    }
}

#pragma mark -- 在这里刷新聊天界面
- (void)sendmessageWithText:(QqModel *)model
{    
    if (model != nil) {
        
        [self.msgTable refrashByModel:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
