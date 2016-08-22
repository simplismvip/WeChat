//
//  QqModel.h
//  
//
//  Created by Mac on 16/1/21.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    MessageFromMe = 0,
    MessageFromOther = 1
} MessageFrom;

typedef enum{
    MsgFailedType = 0,
    MsgSuccessedType = 1,
    MsgSendingdType = 2
} MsgSendResultType;

typedef enum {
    MessageTypeText,
    MessageTypeImage,
    MessageTypeVoice
}MsgType;

@interface QqModel : NSObject
@property (nonatomic, assign) BOOL readtype;

@property (nonatomic, assign) NSInteger mid;
@property (nonatomic, copy) NSString *meetingID;
@property (nonatomic, copy) NSString *sendNo;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, copy) NSString *loginName;

// 后来新家的属性
@property (nonatomic, copy) NSString *msgFrom;
@property (nonatomic, copy) NSString *msgTo;
@property (nonatomic, copy) NSString *msgDevice;
@property (nonatomic, copy) NSString *msgBare;
@property (nonatomic, copy) NSString *imageName;
// 是否发送成功
@property (nonatomic, assign) MsgSendResultType successtype;
@property (nonatomic, assign) MessageFrom messageFrom;
@property (nonatomic, assign) MsgType messageType;

/**
 *  是否隐藏事件
 */
@property (nonatomic, assign)BOOL hideTime;

@end
