//
//  WCNavigationController.m
//  WeChat
//
//  Created by lanouhn on 16/2/28.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


+ (void)setupNavTheme
{
    // 设置导航栏样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置导航条背景
    [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置导航栏字体
    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];

    // 设置状态栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

//// 如果控制器有导航控制器, 设置状态栏的样式时要在导航控制器里面设置
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

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
