//
//  ImageThum.m
//  Image-缩略图
//
//  Created by lanouhn on 16/3/5.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "ImageThum.h"

@implementation ImageThum

+ (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize{

    // 计算比例
    CGFloat scale;
    CGSize newSize = thisSize;
    
    if (newSize.height &&(newSize.height > aSize.height)) {
        
        scale = aSize.height / newSize.height;
        newSize.height *= scale;
        newSize.width *= scale;
    }
    
    if (newSize.width && (newSize.width > aSize.width)) {
        
        scale = aSize.width / newSize.width;
        newSize.width *= scale;
        newSize.height *= scale;
    }
    
    NSLog(@"%@", NSStringFromCGSize(newSize));
    
    return newSize;
}



// 返回调整的缩略图
+ (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewSize
{
    
    CGSize size = [ImageThum fitSize:image.size inSize:viewSize];
    
    UIGraphicsBeginImageContext(viewSize);
    
    float dwidth = (viewSize.width - size.width) / 2.0f;
    float dheight = (viewSize.height - size.height) / 2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}


// 返回居中的缩略图

+ (UIImage *)image:(UIImage *)image centerInSize:(CGSize)viewsize
{
    CGSize size = image.size;
    
    UIGraphicsBeginImageContext(viewsize);
    float dwidth = (viewsize.width - size.width) / 2.0f;
    float dheight = (viewsize.height - size.height) / 2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

 // 返回填充的缩略图

+ (UIImage *)image:(UIImage *)image fillSize:(CGSize)viewsize

{
    CGSize size = image.size;
    
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(viewsize);
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *)image:(UIImage *)image scale:(CGFloat)scale
{
    CGSize size = image.size;
    
    CGFloat w = size.width * scale;
    CGFloat h = size.height * scale;
    size = CGSizeMake(w, h);
    
    UIGraphicsBeginImageContext(size);
    
    CGRect rect = CGRectMake(0, 0, 0, 0);
    rect.size = size;
    
    [image drawInRect:rect];
    
    UIImage *ima = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return ima;
 }

@end
