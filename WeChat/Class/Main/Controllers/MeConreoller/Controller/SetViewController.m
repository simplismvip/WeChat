//
//  SetViewController.m
//  SettIngView
//
//  Created by JM Zhao on 16/7/29.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "SetViewController.h"
#import "SettingCell.h"
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define Screenheight [[UIScreen mainScreen] bounds].size.height
#define kImageOriginHight 160

@interface SetViewController ()<UITableViewDelegate, UITableViewDataSource, SettingCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UITableView *setTableView;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
}

- (void)setupTableView
{
    NSArray *array = @[@[@"设置账户"], @[@"我的产品"], @[@"我的书库"], @[@"我的订单"], @[@"论坛"], @[@"退出"]];
    self.dataArray = [array mutableCopy];
    
    UITableView *setTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    [setTableView registerClass:[SettingCell class] forCellReuseIdentifier:@"cell"];
    
    setTableView.delegate = self;
    setTableView.dataSource = self;
    [self.view addSubview:setTableView];
    self.setTableView = setTableView;
    
    // 设置表头刷新
    self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kImageOriginHight)];
    self.headView.image = [UIImage imageNamed:@"setheader"];
    UIView *clearView = [[UIView alloc] initWithFrame:_headView.frame];
    self.setTableView.tableHeaderView = clearView;
    [self.setTableView addSubview:self.headView];
    
    // 设置头像和用户名
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    image.layer.cornerRadius = 40;
    image.layer.masksToBounds = YES;
    image.center = CGPointMake(ScreenWidth/2, kImageOriginHight/2);
    image.image = [UIImage imageNamed:@"001"];
    [self.setTableView addSubview:image];
    self.image = image;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30)];
    nameLabel.center = CGPointMake(ScreenWidth/2, kImageOriginHight/2+65);
    nameLabel.text = @"作业写不完";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.setTableView addSubview:nameLabel];
    self.nameLabel = nameLabel;
}


#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [SettingCell lrcCell:tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.section>0) {
        
        NSArray *nameArr = self.dataArray[indexPath.section-1];
        cell.setLabel.text = nameArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"选中%ld行", indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7.0;
}

#pragma mark -- SettingCellDelegate
- (void)cloudShareClick
{
    NSLog(@"云共享");
}
- (void)albumClick
{
    NSLog(@"相册");
}

- (void)setimage:(NSURL *)headPhoto naem:(NSString *)name
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@", name];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:headPhoto]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.image.image = image;
        });
    });
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
//    NSLog(@"%f", yOffset);
    
    if (yOffset < 0) {
        
        CGRect f = self.headView.frame;
        
        //下拉的偏移量赋给
        f.origin.y = yOffset;
        
        //加上下拉的偏移量得到一个新的高度
        f.size.height = -yOffset + kImageOriginHight;
        
        //x位置 f.size.height/kImageOriginHight * ScreenWidth 通过高度比例得到宽度的值，然后减去原来宽度，边长的宽度 除以2得到x轴位置
        f.origin.x = -(f.size.height*ScreenWidth/kImageOriginHight -  ScreenWidth)/2;
        
        ////f.size.height/kImageOriginHight * ScreenWidth 通过高度比例得到宽度的值，
        f.size.width = f.size.height*ScreenWidth/kImageOriginHight;
        
        self.headView.frame = f;
        
    }
    
//    NSLog(@"%@", NSStringFromCGRect(self.headView.frame));
}

@end
