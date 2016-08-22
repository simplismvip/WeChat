//
//  QqFrameModel.h
//  
//
//  Created by Mac on 16/1/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QqModel.h"

@interface QqFrameModel : NSObject

@property (nonatomic, assign) CGRect textF;
@property (nonatomic, assign) CGRect timeF;
@property (nonatomic, assign) CGRect iconF;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) QqModel *message;
@end
