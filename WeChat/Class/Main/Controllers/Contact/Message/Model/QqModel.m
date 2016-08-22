//
//  QqModel.m
//  
//
//  Created by Mac on 16/1/21.
//
//

#import "QqModel.h"


@implementation QqModel
- (QqModel *)init
{
    self = [super init];
    self.meetingID = @"";
//    self.icon = @"";
    self.sendTime = @"";
    self.userName = @"";
    self.msgContent = @"";
    self.loginName =@"";
//    self.mtype = -1;
//    self.successtype = MSGSUCCESSEDTYPE;
    self.readtype = YES;
    
    return self;
}
@end
