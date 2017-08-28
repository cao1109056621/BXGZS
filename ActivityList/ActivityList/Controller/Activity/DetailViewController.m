//
//  DetailViewController.m
//  ActivityList
//
//  Created by admin on 17/8/1.
//  Copyright © 2017年 self. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PurchaseTableViewController.h"
@interface DetailViewController ()



@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UILabel *applyFeeLbl;
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *applyStateLbl;
@property (weak, nonatomic) IBOutlet UILabel *attenndenceLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *issuerLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *applyDueLbl;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *applyStartView;
@property (weak, nonatomic) IBOutlet UIView *applyDue;
@property (weak, nonatomic) IBOutlet UIView *applyingView;
@property (weak, nonatomic) IBOutlet UIView *applyEndView;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (strong,nonatomic) UIImageView *zoomTV;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self networkRwquest];
    [self addTapGestureRecognizer:_activityImgView];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title = _activity.name;
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
-(void)networkRwquest{
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    NSString *request = [NSString stringWithFormat:@"/event/%@",_activity.activityID];
    NSMutableDictionary *parmeters =
    [NSMutableDictionary new];
    if ([Utilities loginCheck]) {
        [parmeters setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberID"] forKey:@"memberID"];
    }
    [RequestAPI requestURL:request withParameters:parmeters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSLog(@"responseObject = %@", responseObject);
            [aiv stopAnimating];
            NSDictionary *result = responseObject[@"result"];
            _activity = [[ActivityModel alloc]initWithDetailDictionary:result];
            [self uiLayout];
        }else{
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
-(void)uiLayout{
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString:_activity.imgUrl] placeholderImage:[UIImage imageNamed:@"image"]];
    _applyFeeLbl.text = [NSString stringWithFormat:@"%@元",_activity.applyFee];
    _attenndenceLbl.text = [NSString stringWithFormat:@"%@/%@",_activity.attendence,_activity.limitation];
    _typeLbl.text = _activity.type;
    _issuerLbl.text = _activity.issuer;
    _addressLbl.text = _activity.address;
    _contentLbl.text = _activity.content;
    [_callBtn setTitle:[NSString stringWithFormat:@"联系活动发布者:%@",_activity.phone] forState:UIControlStateNormal];
    
    NSString *dueTimeStr = [Utilities dateStrFromCstampTime:_activity.dueTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startTimeStr = [Utilities dateStrFromCstampTime:_activity.startTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endTimeStr = [Utilities dateStrFromCstampTime:_activity.endTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLbl.text = [NSString stringWithFormat:@"%@ ~ %@",startTimeStr,endTimeStr];
    _applyDueLbl.text = [NSString stringWithFormat:@"报名截止时间(%@)",dueTimeStr];
    NSDate *now = [NSDate date];
    NSTimeInterval nowTime = [now timeIntervalSince1970InMilliSecond];
    _applyStartView.backgroundColor = [UIColor grayColor];
    if (nowTime >= _activity.dueTime) {
        _applyDue.backgroundColor = [UIColor grayColor];
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"报名截止" forState:UIControlStateNormal];
        if (nowTime >= _activity.startTime) {
            _applyingView.backgroundColor = [UIColor grayColor];
            if (nowTime >= _activity.endTime) {
                _applyEndView.backgroundColor = [UIColor grayColor];
            }
        }
    }
    if (_activity.attendence >= _activity.limitation) {
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"活动满员" forState:UIControlStateNormal];
    }
    switch (_activity.status) {
        case 0:{
            _applyStateLbl.text = @"已取消";
        }
            
            break;
        case 1:{
            _applyStateLbl.text = @"待付款";
            [_applyBtn setTitle:@"去付款" forState:UIControlStateNormal];
        }
            
            break;
            
        case 2:{
            _applyStateLbl.text = @"已报名";
            [_applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
        }
            
            break;
            
        case 3:{
            _applyStateLbl.text = @"退款中";
            [_applyBtn setTitle:@"退款中" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
        }
            
            break;
            
        case 4:{
            _applyStateLbl.text = @"已退款";
        }
            
            break;
            

        default:{
            _applyStateLbl.text = @"待报名";
        }
            break;
    }
}

//添加单击手势事件
- (void) addTapGestureRecognizer : (id)any{
    //初始化一个单击手势，设置响应的事件为tapClick:
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    //将手势添加给入参
    [self.zoomTV addGestureRecognizer:tap];
}
//小图单击手势的响应事件
- (void)tapClick: (UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateRecognized) {
       
//        //拿到长按手势在_activityTableView中的位置
//        CGPoint location = [tap locationInView:_activityImgView];
//
        //设置大图片的位置大小
            _zoomTV = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            //用交互启用
            _zoomTV.userInteractionEnabled = YES;
            _zoomTV.backgroundColor = [UIColor blackColor];
            [_zoomTV sd_setImageWithURL:[NSURL URLWithString:_activity.imgUrl]placeholderImage:[UIImage imageNamed:@"image"]];
            
            //设置图片的内容模式
            _zoomTV.contentMode = UIViewContentModeScaleAspectFit;
            //获得窗口实例的，并将大图放置到窗口实例上，根据苹果规则，后添加的控件会覆盖前添加的控件
            [[UIApplication sharedApplication].keyWindow addSubview:_zoomTV];
            UITapGestureRecognizer *zoomTVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomTap:)];
            [_zoomTV addGestureRecognizer:zoomTVTap];
        }
}

//大图的单击手势响应事件
- (void)zoomTap: (UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        //把大图本身的东西扔掉（大图的手势）
        [_zoomTV removeGestureRecognizer:tap];
        //把自己从父级视图移除
        [_zoomTV removeFromSuperview];
        //彻底移除（这样就不会造成内存的滥用）
        _zoomTV = nil;
    }
    
}


- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event
     {
        if ([Utilities loginCheck]) {
            PurchaseTableViewController *purchaseVC = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"purchase"];
            purchaseVC.activity = _activity;
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }else {
            UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
            [self presentViewController:signNavi animated:YES completion:nil];
        }
    }

- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event{
    //配置“电话”app的路径，并将要拨打的号码组合到路径中
    NSString *targetAppStr = [NSString stringWithFormat:@"telprompt://%@",_activity.phone];
    NSURL *targetAppUrl = [NSURL URLWithString:targetAppStr];
    //从当前app跳转到其他制定的app中
    [[UIApplication sharedApplication]openURL:targetAppUrl];
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
