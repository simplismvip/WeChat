//
//  ImageThum.h
//  Image-缩略图
//
//  Created by lanouhn on 16/3/5.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageThum : NSObject

+ (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize;

+ (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewSize;
+ (UIImage *)image:(UIImage *)image centerInSize:(CGSize)viewsize;
+ (UIImage *)image:(UIImage *)image fillSize:(CGSize)viewsize;

+ (UIImage *)image:(UIImage *)image scale:(CGFloat)scale;
@end
