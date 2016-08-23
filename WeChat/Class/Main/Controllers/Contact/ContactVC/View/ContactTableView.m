//
//  ContactTableView.m
//  Contacts
//
//  Created by JM Zhao on 16/7/8.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "ContactTableView.h"
#import "ContactCell.h"
#import "ContactModel.h"
#import "pinyin.h"
#import "UIView+Extension.h"
#import "HeaderFooter.h"
#import "JMFriendDetailController.h"

@interface ContactTableView()<UITableViewDelegate, UITableViewDataSource, ContactTableViewDelegate>

// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

// 索引数据源
@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, weak)  UISearchBar *searchBar;
@property (nonatomic, strong) UIViewController *superViewController;
@end
@implementation ContactTableView

- (NSMutableArray *)indexArr
{
    if (!_indexArr) {self.indexArr = [NSMutableArray array];}
    return _indexArr;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        searchBar.tintColor = [UIColor grayColor];
        searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchBar.keyboardType = UIKeyboardTypeAlphabet;
        self.tableHeaderView = searchBar;
        self.searchBar = searchBar;
        
        [self registerClass:[ContactCell class] forCellReuseIdentifier:@"cell"];
        self.sectionIndexBackgroundColor = [UIColor clearColor];
        self.sectionIndexColor = [UIColor grayColor];
        self.delegate = self;
        self.dataSource = self;
        self.sectionHeaderHeight = 34;
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [ContactCell contactCell:tableView cellForRowAtIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSMutableArray *rowArr = self.dataArray[indexPath.section];
    JMFriendDetailController *mfVC = [[JMFriendDetailController alloc] init];
    mfVC.cModel = rowArr[indexPath.row];
    [self.superViewController.navigationController pushViewController:mfVC animated:YES];
}

#pragma mark -- headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderFooter *headView = [HeaderFooter headViewWithTableView:tableView];
    headView.groups = self.indexArr[section];
    return headView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPat
{}

//// 设置可以多行删除
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return UITableViewCellEditingStyleNone;
//    // return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"添加" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"添加");
    }];
    
    
    UITableViewRowAction *deleAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
       
        NSLog(@"删除");
        
    }];
    
    return @[addAction, deleAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

// 返回索引栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArr;
}

+ (instancetype)initContactTableView:(UIView *)view dataArray:(NSMutableArray *)dataArray addDelegate:(id)conDelegate
{
    ContactTableView *base = [[ContactTableView alloc] initWithFrame:view.bounds];
    base.contactDelegate = conDelegate;
    [self getSuperView:base addDelegate:conDelegate];
    
    // 侧边索引栏
    for (NSMutableArray *indexArr in dataArray) {
        
        ContactModel *model = indexArr.firstObject;
        NSString *name = [model.nickname uppercasePinYinFirstLetter];
        [base.indexArr addObject:name];
    }
    
    // 赋值
    base.dataArray = dataArray;
    [view addSubview:base];
    
    return base;
}

//- (void)relodData
//{
//    [self reloadData];
//}

// 通过View获取控制器方法
+ (UIViewController *)findViewController:(UIView *)sourceView
{
    id target = sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

// 根据代理获取控制器
+ (void)getSuperView:(ContactTableView *)base addDelegate:(id)conDelegate
{
    if ([conDelegate isKindOfClass:[UIView class]]) {
        
        UIView *view = (UIView *)conDelegate;
        base.superViewController = [self findViewController:view];
        
    }else if ([conDelegate isKindOfClass:[UIViewController class]]) {
        
        base.superViewController = (UIViewController *)conDelegate;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

@end
