//
//  ActivityTableViewCell.h
//  ActivityList
//
//  Created by admin on 17/7/25.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *activityLikeLable1;
@property (weak, nonatomic) IBOutlet UILabel *activityLikeLable2;
@property (weak, nonatomic) IBOutlet UILabel *activityInfoLable;
@property (weak, nonatomic) IBOutlet UIButton *favoBtn;

@end
