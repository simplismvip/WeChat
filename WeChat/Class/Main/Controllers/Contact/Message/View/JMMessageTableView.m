//
//  JMMessageTableView.m
//  WeChat
//
//  Created by JM Zhao on 16/8/11.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "JMMessageTableView.h"
#import "QqCell.h"
#import "QqModel.h"
#import "QqFrameModel.h"

@interface JMMessageTableView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
// @property (nonatomic, strong) NSMutableArray<QqModel *> *modelArray;
@property (nonatomic, strong) UIViewController *superVC;
@end

@implementation JMMessageTableView

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        
        [self registerClass:[QqCell class] forCellReuseIdentifier:@"MessageCell"];
        self.allowsSelection = NO;
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

// 给模型赋值
- (void)setModelArray:(NSMutableArray<QqModel *> *)modelArray
{
    _modelArray = modelArray;
    for (QqModel *model in modelArray) {
        
        QqFrameModel *af = [[QqFrameModel alloc] init];
        af.message = model;
        [self.dataArray addObject:af];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QqCell *cell = [QqCell initQqCellWith:tableView indexPath:indexPath array:self.dataArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QqFrameModel *mf = self.dataArray[indexPath.row];
    return mf.cellHeight;
}

#pragma mark -- IMageCell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QqFrameModel *af = self.dataArray[indexPath.row];
    
    QqModel *msg = af.message;
    
    switch (msg.messageType) {
        case MessageTypeImage:
            
            
            break;
            
        case MessageTypeVoice:
            
            
            break;
            
        default:
            break;
    }
}

+ (instancetype)initMessageTableView:(UIViewController *)viewC dataArray:(NSMutableArray<QqModel *> *)modelArray
{
    JMMessageTableView *base = [[JMMessageTableView alloc] initWithFrame:viewC.view.bounds];
    base.modelArray = modelArray;
    base.superVC = viewC;
//    base.backgroundColor = [UIColor redColor];
    [viewC.view addSubview:base];
    return base;
}

// 刷新界面
- (void)refrashByModel:(QqModel *)model
{
    QqFrameModel *af = [[QqFrameModel alloc] init];
    af.message = model;
    [self.dataArray addObject:af];
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self insertRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationBottom)];
    [self scrollToRowAtIndexPath:path atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.superVC.view endEditing:YES];
}

- (void)keyBoardRun
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self insertRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationBottom)];
    [self scrollToRowAtIndexPath:path atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
}

- (void)tableViewFrameSet:(CGFloat)height
{
    CGFloat x = 0.0;
    CGFloat w = self.superVC.view.bounds.size.width;
    CGFloat h = height-44;
    CGFloat y = 0.0;
    
    for (UIView *subView in self.superVC.view.subviews) {
        
        if ([subView isKindOfClass:self.class]) {
            
            subView.frame = CGRectMake(x, y, w, h);
            
        }
    }
}

@end
