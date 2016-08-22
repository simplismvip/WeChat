//
//  WCEditProfireViewController.m
//  WeChat
//
//  Created by lanouhn on 16/3/1.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCEditProfireViewController.h"

@interface WCEditProfireViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCEditProfireViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.cell.textLabel.text;
    
    self.textField.text = self.cell.detailTextLabel.text;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveClick)];
}


- (void)saveClick
{
    // 保存之后这里首先修改detail的text值, 然后当前的控制器需要消失
    self.cell.detailTextLabel.text = self.textField.text;
    
    // 刷新cell
    [self.cell layoutSubviews];
    
    // 当前控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    
    // 调用代理
    if ([self.deldegate respondsToSelector:@selector(editProfireViewControllerDidSave)]) {
        
        // 通知代理, 点击保存按钮, 调用代理方法
        [self.deldegate editProfireViewControllerDidSave];
        
    }
    
}



//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
