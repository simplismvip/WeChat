//
//  InputImageView.m
//  EmojiKey-自定义键盘
//
//  Created by JM Zhao on 16/7/6.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "InputImageView.h"
#import "UIView+Extension.h"
#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface InputImageView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageContorl;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation InputImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *names = @[@"image", @"camera", @"lettleVideo", @"video", @"collect"];
        for (int i = 0; i < names.count; i ++) {
            
            UIButton *btnAction = [UIButton buttonWithType:(UIButtonTypeSystem)];
            btnAction.tag = i;
            btnAction.layer.cornerRadius = 10;
            btnAction.layer.borderWidth = 1;
            btnAction.layer.borderColor = [UIColor grayColor].CGColor;
            btnAction.backgroundColor = HMColor(255, 255, 255);
            UIImage *image = [UIImage imageNamed:names[i]];
            image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
            [btnAction setImage:image forState:(UIControlStateNormal)];
            [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:btnAction];
        }
        
        [self configurePageControl];
    }
    return self;
}

- (void)btnAction:(UIButton *)sender
{

}

- (void)configurePageControl{
    
    self.pageContorl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 30)];
    _pageContorl.numberOfPages = 2;
    _pageContorl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageContorl.pageIndicatorTintColor = [UIColor greenColor];
    [_pageContorl addTarget:self action:@selector(handlePageControl:) forControlEvents:(UIControlEventValueChanged)];
    [self addSubview:_pageContorl];
}

- (void)handlePageControl:(UIPageControl *)sender{
    
    // 取出当前分页
    NSInteger number = sender.currentPage;
    
    // 通过分页控制scrollview的偏移量
    self.contentOffset = CGPointMake(number * kScreenWidth, 0);
}

#pragma UISlider使用方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 结束减速时的偏移量
    CGPoint offSet = scrollView.contentOffset;
    CGFloat number = offSet.x / kScreenWidth;
    self.pageNum = (NSInteger)number;
    _pageContorl.currentPage = _pageNum;
    
}

#pragma mark --- 代理方法
- (void)changeValue:(NSInteger)page
{
    _pageContorl.currentPage = page-1;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.contentOffset = CGPointMake((page)*kScreenWidth, 0);
    }];

}

+ (instancetype)initWithInputImageView:(CGRect)rect delegate:(id)delegate
{
    InputImageView *inputView = [[InputImageView alloc] initWithFrame:rect];
    inputView.backgroundColor = [UIColor redColor];
    inputView.pagingEnabled = YES;
    inputView.bounces = NO;
    inputView.contentSize = CGSizeMake(2 * kScreenWidth, 0);
    
    // 设置代理
    inputView.Inputdelegate = delegate;
    return inputView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat edgeW = 30;
    CGFloat edgeH = 30;
    CGFloat w = (self.width-5*edgeW)/4;
    CGFloat h = (self.height-3*edgeH)/2;
    
    int i = 0;
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            if (i < 4) {
                
                view.frame = CGRectMake(i*(edgeW+w)+edgeW, edgeH, w, h);
            }else{
                view.frame = CGRectMake((i-4)*(edgeW+w)+edgeW, 2*edgeH+h, w, h);
            }
            
            i++;
        }
    }
}

@end
