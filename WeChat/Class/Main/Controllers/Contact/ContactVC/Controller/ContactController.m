//
//  ContactController.m
//  Contacts
//
//  Created by JM Zhao on 16/8/9.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "ContactController.h"
#import "ContactTableView.h"
#import "ContactModel.h"
#import "JMArrayHelper.h"
#import "AppDelegate.h"

@interface ContactController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *resultController;
@property (nonatomic, strong) ContactTableView *base;
@end

@implementation ContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFriends2];    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 加载好友操作
- (void)loadFriends2
{
    // 获取上下文
    NSManagedObjectContext *contect = [WCXmppTool sharedWCXmppTool].rosterStorage.mainThreadManagedObjectContext;
    
    // 设置查找条件, 查找哪一张表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 设置过滤条件
    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", jid];
    request.predicate = predicate;
    
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 执行请求
    self.resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:contect sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    NSError *err = nil;
    [_resultController performFetch:&err];
    if (err) {WCLog(@"Contact err = %@", err);}
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    // 1> 判断数据库是否有表
    if (delegate.isExistSQLite) {
        
        // 来到这里说明存在表, 直接加载数据库数据
        [self readContactFromSQL];
    }else{
        
        // 1> 来到这里说明不存在表, 获取好友数据
        [self getGroupe:_resultController];
        
        // 2> 来到这里说明存在表, 直接加载数据库数据
        [self readContactFromSQL];
    }
}

- (BOOL)isExistInFields
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    docsdir = [docsdir stringByAppendingPathComponent:@"Contact/contact.sqlite"];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    BOOL isDir;
    return [filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
}

#pragma mark - NSFetchedResultsController 数据库发生改变会调用这个方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)resultController
{
    // 首先拿到数据库所有元素
    NSArray *he = [ContactModel findAll];
    
    // 着这里拿到更新后的数据, 将更新后的数据添加到数据库
    for (XMPPUserCoreDataStorageObject *friend in resultController.fetchedObjects) {
        for (ContactModel *cModel in he) {
            
            // 遍历数据库, 如果这个jid和数据库的元素都不相同, 则添加, 只要找到一个相同就停止
            if ([friend.jidStr isEqualToString:cModel.jidStr]) {return;}
        }
        
        // 如果能够来到这里说明没有相同的元素则添加
        ContactModel *cModel = [[ContactModel alloc] init];
        cModel.nickname = friend.nickname;
        cModel.weChatNumber = friend.jid.user;
        cModel.jidStr = friend.jidStr;
        // model.photo = friend.photo;
        cModel.sectionNum = [friend.sectionNum stringValue];
        [cModel save];
        
        // 更新UI界面
    }
}

// 先把用户名转化为字母排序添加到数组, 在把数组返回
- (void)getGroupe:(NSFetchedResultsController *)resultController
{
    NSMutableArray *cArray = [NSMutableArray array];
    for (XMPPUserCoreDataStorageObject *friend in resultController.fetchedObjects) {
        
        ContactModel *cModel = [[ContactModel alloc] init];
        cModel.nickname = friend.nickname;
        cModel.weChatNumber = friend.jid.user;
        cModel.jidStr = friend.jidStr;
        // model.photo = friend.photo;
        cModel.sectionNum = [friend.sectionNum stringValue];
        [cArray addObject:cModel];
    }
    
    // 保存数据到数据库
    if (cArray.count>0) {[ContactModel saveObjects:cArray];}
    
}

// 加载展示数据
- (void)readContactFromSQL
{
    // 2> 将数据库中的数据取出来
    NSArray *he = [ContactModel findAll];
    NSMutableArray *outArray = [JMArrayHelper getSubArrayFromSuperArray:he];
    NSMutableArray *sortArray = [JMArrayHelper sortArray:outArray];
    
    self.base = [ContactTableView initContactTableView:self.view dataArray:sortArray addDelegate:self];
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
