//
//  QqCell.h
//  
//
//  Created by Mac on 16/1/21.
//
//

#import <UIKit/UIKit.h>
@class QqFrameModel;

@interface QqCell : UITableViewCell
@property (nonatomic, strong)QqFrameModel *messageFrame;
+ (QqCell *)initQqCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath array:(NSMutableArray *)array;
@end
