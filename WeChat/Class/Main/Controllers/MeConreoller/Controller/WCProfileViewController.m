//
//  WCProfileViewController.m
//  WeChat
//
//  Created by lanouhn on 16/2/29.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WCEditProfireViewController.h"
#import "WCXmppTool.h"

@interface WCProfileViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, WCEditProfireViewController>
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *weChatNumber;
@property (weak, nonatomic) IBOutlet UILabel *twoCode;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *resign;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (nonatomic,strong)UIImagePickerController *imgPicker;
@end

@implementation WCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人信息";
    
    // 设置头像
    XMPPvCardTemp *myvCard = [WCXmppTool sharedWCXmppTool].vCard.myvCardTemp;
    
    if (myvCard.photo) {
        
        self.headPic.image = [UIImage imageWithData:myvCard.photo];
        
    }
    
    // 设置昵称
    self.nickName.text = myvCard.nickname;
    
    // 设置微信号
    self.weChatNumber.text = [WCUserInfo sharedWCUserInfo].user;
    
    // 设置相册
    self.twoCode.text = myvCard.orgName;
    
    // 设置保存
    if (myvCard.addresses.count > 0) {
        
        self.address.text = myvCard.addresses[0];
    }
    
    // 这里是有note字段充当电话
    self.gender.text = myvCard.note;
    
    // 设置我的卡包
    // 这里是有mailer充当邮箱
    self.resign.text = myvCard.mailer;
    
    // 设置表情
    self.signature.text = myvCard.note;
    
    WCLog(@"%@--%@--%@--%@--%@--%@", myvCard.nickname, [WCUserInfo sharedWCUserInfo].user, myvCard.orgName, myvCard.addresses, myvCard.note, myvCard.mailer);
    
}


// 获取选中的对应cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取cell.tag
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 2) {// 如果tag值为2不做任何操作
        return;
    }
    
    if (cell.tag == 0) {// 选中照片
       
        [self chouseImageByTag];
        
    }else {
    
        // 详情界面跳转到编辑界面, 这里传递一个选中的cell
        [self performSegueWithIdentifier:@"segue" sender:cell];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[WCEditProfireViewController class]]) {
        
        WCEditProfireViewController *editer = destVC;
        
        // 这里拿到上面传进来的cell
        editer.cell = sender;
        //遵循编辑控制器的代理
        editer.deldegate = self;
    }

}


- (void)chouseImageByTag
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                
                [self initImagePicker];
                
            }else {
                
                UIAlertController *subAlert = [UIAlertController alertControllerWithTitle:@"没有可用设备" message:@"请检查设备" preferredStyle:UIAlertControllerStyleAlert];
                [subAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
                [self presentViewController:subAlert animated:YES completion:nil];
            }
            
        }]];
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"图库" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
                
                [self initImagePicker];
                
            }else {
                
                UIAlertController *subAlert = [UIAlertController alertControllerWithTitle:@"没有可用设备" message:@"请检查设备" preferredStyle:UIAlertControllerStyleAlert];
                [subAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
                [self presentViewController:subAlert animated:YES completion:nil];
            }
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)]) {
                
                [self initImagePicker];
                
            }else {
                
                UIAlertController *subAlert = [UIAlertController alertControllerWithTitle:@"没有可用设备" message:@"请检查设备" preferredStyle:UIAlertControllerStyleAlert];
                [subAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
                [self presentViewController:subAlert animated:YES completion:nil];
            }
            
        }]];
    
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    
    
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

// 添加代理处理选中图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
    self.headPic.image = image;
    
    [self.imgPicker.view removeFromSuperview];
    
    // 更新全部属性到服务器
    [self editProfireViewControllerDidSave];
}

// 2.添加代码，处理选中图像又取消的情况
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imgPicker.view removeFromSuperview];
}

- (void)initImagePicker
{
    self.imgPicker = [[UIImagePickerController alloc] init];
    _imgPicker.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    _imgPicker.delegate = self;
    _imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imgPicker.allowsEditing = YES;
    [self.view addSubview:self.imgPicker.view];}


#pragma mark - 编辑个人信息的控制器代理
- (void)editProfireViewControllerDidSave
{
    // 保存
    // 先获取当前电子名片信息
    XMPPvCardTemp *myvCard = [WCXmppTool sharedWCXmppTool].vCard.myvCardTemp;
    
    // 保存照片头像
    myvCard.photo = UIImagePNGRepresentation(self.headPic.image);
    
    // 设置昵称
     myvCard.nickname = self.nickName.text;
    
    // 设置微信号
     [WCUserInfo sharedWCUserInfo].user = self.weChatNumber.text;
    
    // 设置相册
     myvCard.orgName = self.twoCode.text;
    
    // 设置保存
    if (myvCard.orgUnits.count > 0) {
        
        myvCard.orgUnits = @[self.address.text];
    }
    
    // 这里是有note字段充当电话
     myvCard.note = self.gender.text;
    
    // 设置我的卡包
    // 这里是有mailer充当邮箱
     myvCard.mailer = self.resign.text;
    
    // 设置表情
    myvCard.note = self.signature.text;

    // 更新所有操作到服务器
    [[WCXmppTool sharedWCXmppTool].vCard updateMyvCardTemp:myvCard];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
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
