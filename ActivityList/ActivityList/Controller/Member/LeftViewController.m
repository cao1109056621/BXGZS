//
//  LeftViewController.m
//  ActivityList
//
//  Created by admin1 on 2017/8/19.
//  Copyright © 2017年 self. All rights reserved.
//

#import "LeftViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"
@interface LeftViewController ()

@property (strong,nonatomic) NSArray *arr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatrImage;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)seetingAction:(UIButton *)sender forEvent:(UIEvent *)event;


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uilayout];
    [self dataInitialize];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //已登陆
        _loginBtn.hidden = YES;
        _usernameLbl.hidden = NO;
        
        UserModel *user = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_avatrImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"Avatar"]];
        _usernameLbl.text = user.nickname;
    }else{
        //未登陆
        _loginBtn.hidden = NO;
        _usernameLbl.hidden = YES;
        
        _avatrImage.image = [UIImage imageNamed:@"Avatar"];
        _usernameLbl.text = @"游客";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uilayout{
    _avatrImage.layer.borderColor = [[UIColor lightGrayColor]CGColor];
}

- (void)dataInitialize{
    _arr = @[@"我的活动",@"我的推广",@"积分中心",@"意见反馈",@"关于我们"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _arr.count;
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
        cell.textLabel.text =_arr[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmpytCell" forIndexPath:indexPath];
        
        
        return cell;
    }
  
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.f;
    }else{
        return UI_SCREEN_H - 500;
    }
}
/*
 1、直接从可触摸的那个地方拖一个箭头
 快简单
 只能做点对点的跳转
 2、从页面拖一个箭头到另一个页面
 跳转的发生可以人为控制
 传值非常复杂
 3、不通过故事版  而靠代码在对故事版取得名字找到故事版惊醒跳转
 传值非常方便
 名字容易不匹配，故事版上没有箭头
 4、传说中的纯代码 用纯代码初始化的方法去跳转
 完全自定义
 用补了约束
 */

//选中后的调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([Utilities loginCheck]) {
            switch (indexPath.row) {
                case 0:{
                    [self performSegueWithIdentifier:@"Left2MyAct" sender:self];
                    
                }
                    
                    break;
                   
                case 1:{
                    
                }
                    
                    break;
                    
                case 2:{
                    
                }
                    
                    break;
                    
                case 3:{
                    
                }
                    
                    break;
                    
                case 4:{
                    
                }
                    
                    break;
                default:
                    break;
            }
            
        }else{
            //获取要跳转过去的那个页面
            UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
            //执行跳转
            [self presentViewController:signNavi animated:YES completion:nil];
        }
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转过去的那个页面
    UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
    //执行跳转
    [self presentViewController:signNavi animated:YES completion:nil];
}

- (IBAction)seetingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck]) {
        
    }else{
        //获取要跳转过去的那个页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
        
    }
}
@end
