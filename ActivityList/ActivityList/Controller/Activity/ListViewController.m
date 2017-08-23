//
//  ViewController.m
//  ActivityList
//
//  Created by admin on 17/7/24.
//  Copyright © 2017年 self. All rights reserved.
//

#import "ListViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "IssueViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL isLoading;
    BOOL firstVisit;
}
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
- (IBAction)searchAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
//@property(strong,nonatomic) NSArray *arr;
- (IBAction)switchAction:(UIBarButtonItem *)sender;
- (IBAction)favoAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic) UIImageView *zoomTV;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSMutableArray *arr;
@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;
@end

@implementation ListViewController

//第一次将要开始渲染这个页面的时候
-(void)awakeFromNib{
    [super awakeFromNib];
}

//第一次来到这个页面的时候
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self naviConfig];
    [self uiLayout];
    [self locaionConfig];
    [self dataInitialize];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
   
    // [self networkRequest];
//    //过2秒执行networkRequest方法
//    [self performSelector:@selector(networkRequest) withObject:nil afterDelay:2 ];
  }
//每次将要来到这个页面的时候
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
}
//每次到达了这个页面的时候
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//每次将要离开这个页面的时候
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locMgr stopUpdatingLocation];
}
//每次离开了这个页面的时候
-( void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //获得当前页面的导航控制器所谓系的关于导航关系的数组，判断该数组中是否包含自己来得知当前操作是离开本页面还是退出本页面
    if(![self.navigationController.viewControllers containsObject:self]){
        //在这里先释放所有监听（包括：Action事件；Protocol协议；Gesture手势；Notification通知......）
        
    }
}


//一旦退出这个页面的时候（并且所有的监听都已经全部释放了）
-(void)dealloc{
    //在这里释放所有内存（设置为nil）
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//这个专门处理跟定位有关系的基本设置
- (void)locaionConfig{
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //识别定位到的设备位移多少距离进行一次是别
    _locMgr.distanceFilter = kCLDistanceFilterNone;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
}
//这个方法处理开始定位
- (void)locationStart{
    //判断用户有没有选择过是否使用定位
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //询问用户是否愿意使用定位
#ifdef __IPHONE_8_0
        //if ([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            //使用“使用中打开定位”这个策略去运行定位功能
            [_locMgr requestWhenInUseAuthorization];
        //}
#endif
    }
    //打开定位服务的开关（开始定位）----只要开了就要关
    [_locMgr startUpdatingLocation];
}
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title = @"活动列表";
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

//这个方法专门做界面的操作
- (void)uiLayout{
    //为表格视图创建footer（该方法可以去除表格视图底部多余的下划线）
    _activityTableView.tableFooterView = [UIView new];
    //创建下拉刷新器
    [self refreshConfiguration];
}
-(void)refreshConfiguration{
    
    //初始化一个下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tag = 10001;
    //设置标题
    NSString *title = @"加载中....";
    //创建属性字典
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : [UIColor grayColor] , NSBackgroundColorAttributeName : [UIColor groupTableViewBackgroundColor]};
    //将文字和属性字典包裹成一个带属性的字符串
    NSAttributedString *attriTitle = [[NSAttributedString alloc]initWithString:title attributes:attrDict];
    refreshControl.attributedTitle = attriTitle;
    //设置风格颜色为黑色（风格颜色：刷新指示器的颜色）
    refreshControl.tintColor = [UIColor grayColor];
    //设置背景色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //定义用户触发下拉事件时执行的方法
    [refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到activityTableView中（在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置）
    [self.activityTableView addSubview:refreshControl];
}
//- (void)refreData:(UIRefreshControl *)sender{
//   //过2秒执行eng方法
//    [self performSelector:@selector(end) withObject:nil afterDelay:2];
//
//}
- (void)end{
     //在activityTableView中，根据下标10001获得其子视图： 下拉刷新控件
    UIRefreshControl *refresh = (UIRefreshControl *)[self.activityTableView viewWithTag:10001];
    //结束刷新
    [refresh endRefreshing];
}

//这个方法专门做数据的处理
- (void)dataInitialize{
    BOOL appInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明是第一次打开app
        appInit = YES;
    } else {
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //说明是第一次打开app
            appInit = YES;
        }
        if (appInit) {
            //第一次来到app将默认城市与记忆城市同步
            NSString *userCity = _cityButton.titleLabel.text;
            [Utilities setUserDefaults:@"UserCity" content:userCity];
        } else {
            //不是第一次来到app则将记忆城市与按钮上的城市名反向同步
            NSString *userCity = [Utilities getUserDefaults:@"UserCity"];
            [_cityButton setTitle:userCity forState:UIControlStateNormal];
        }
    }
    firstVisit = YES;
    isLoading = NO;
    _arr = [NSMutableArray new];
    // 创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshPage];

}

-(void) refreshPage{
    page = 1;
    [self networkRequest];
}

//执行网络请求
- (void)networkRequest{
    perPage = 10;
    
//    NSDictionary *dictA = @{ @"name" : @"环太湖骑行", @"content":@"从无序滨湖区雪浪街街道太湖出发，绕道苏州、嘉兴、湖州、宜兴，返回无锡",@"like":@80,@"unlike":@8,@"imgURL":@"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A",@"isFavo":@YES};
//    NSDictionary *dictB = @{ @"name" : @"雪浪山骑马", @"content":@"首先让马走就有用送跨，腿夹马，腿蹭马肚子，向一侧 拉马缰绳，用鞭子晃悠，再不走用鞭打。",@"like":@780,@"unlike":@65,@"imgURL":@"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_1_885E76C7-7EA0-423D-B029-2085C0F769E6",@"isFavo":@NO};
//    NSDictionary *dictC = @{ @"name" : @"黄浦江浮潜", @"content":@"浮潜初学者仅需要短时间掌握少许技巧就可以使用浮潜三宝，因为通过呼吸管解决了游泳中最难掌握的换气呼吸问题，所以比起学会游泳要容易得多。",@"like":@855,@"unlike":@85,@"imgURL":@"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_3_2ADCF0CE-0A2F-46F0-869E-7E1BCAF455C1",@"isFavo":@NO};
//    
    
    
    
    
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:dictA,dictB,dictC, nil];
//    for (NSDictionary *dict in array) {
//        //用ActivityModel类中定义的初始化方法nitWithDictionary:将便利的来的字典转换成为ActivityModel 对象
//        ActivityModel *activityModel = [[ActivityModel alloc]initWithDictionary:dict];
//        //将上述实例化好的activityModel对象插入——arr数组中
//        [_arr addObject:activityModel];
//    }
    
    if (!isLoading) {
        isLoading = YES;
        //在这里开启一个真实的网络请求
        //设置接口地址
        NSString *request = @"/event/list";
        //设置接口入参
        NSDictionary *parameter = @{@"page":@(page),@"perPage":@(perPage),@"city" : _cityButton.titleLabel.text};
        //开始请求
        [RequestAPI requestURL:request withParameters:parameter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            //成功以后要做的事情在此处执行
            //NSLog(@"responseObject = %@", responseObject);
            [self endAnimation];
            if ([responseObject[@"resultFlag"] integerValue] == 8001){
                //业务逻辑成功的情况下
                NSDictionary *result = responseObject[@"result"];
                NSArray *models = result[@"models"];
                NSDictionary *pagingInfo = result[@"pagingInfo"];
                totalPage = [pagingInfo[@"totalPage"]integerValue];
                
                if (page == 1) {
                    // 清空数据
                    [_arr removeAllObjects];
                }
                for (NSDictionary *dict in models) {
                    //用ActivityModel类中定义的初始化方法nitWithDictionary:将便利的来的字典转换成为ActivityModel 对象
                    ActivityModel *activityModel = [[ActivityModel alloc]initWithDictionary:dict];
                    //将上述实例化好的activityModel对象插入——arr数组中
                    [_arr addObject:activityModel];
                }
                //刷新表格
                [_activityTableView reloadData];
                
            }else{
                //业务逻辑失败的情况下
                NSString *orrorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
                [Utilities popUpAlertViewWithMsg:orrorMsg andTitle:nil onView:self];
            }
        } failure:^(NSInteger statusCode, NSError *error) {
            //失败以后要做的事情在此处执行
            //NSLog(@"statusCode = %ld",(long)statusCode);
            [self endAnimation];
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }];
    }
}
//这个方法处理网络请求完成后所有不同类型的动画终止
-(void)endAnimation{
    isLoading = NO;
    [_aiv stopAnimating];
    [self end];
}


//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}

//设置当一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是不是最后一行细胞将要出现
    if (indexPath.row == _arr.count - 1) {
        //判断还有没有下一页存在
        if (page < totalPage) {
            //在这里执行上拉翻页的数据操作
            page ++;
            [self networkRequest];
        }
    }
}

//设置每一组每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据某个具体的名字找到该名字在页面上对应的细胞
   ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
    ActivityModel *activity = _arr[indexPath.row];
    //将http请求的字符串转换为NSURL
    NSURL *URL =[NSURL URLWithString:activity.imgUrl];
    //依靠SDWebImage来异步地下载一张远程路径下的图片并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
    [cell.activityImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"image"]];
    //将URL给NSDate（下载）
    //NSData *data = [NSData dataWithContentsOfURL:URL];
    //cell.activityImageView.image = [UIImage imageWithData:data];
    //给图片添加单击手势
    [self addTapGestureRecognizer:cell.activityImageView];
   
    cell.activityName.text =  activity.name;
    cell.activityInfoLable.text = activity.content;
    cell.activityLikeLable1.text = [NSString stringWithFormat:@"顶：%ld",(long)activity.like];
    cell.activityLikeLable2.text = [NSString stringWithFormat:@"踩：%ld",(long)activity.unlike];
    //给每一行的收藏按钮打上下标，用来区分它是哪一行的按钮
    cell.favoBtn.tag = 100000 + indexPath.row;
    //根据isFavo的值来判断按钮的标题是什么
   // NSString *title = activity.isFavo ? @"取消收藏" : @"收藏";
    //  cell.activityName.text = _arr[indexPath.row];
    [cell.favoBtn setTitle: activity.isFavo ? @"取消收藏" : @"收藏" forState:UIControlStateNormal];
    [self addlongPress:cell];
   

    /*
    //判断当前正在渲染的细胞属于第几行
    if ( indexPath.row == 0) {
        //第一行的情况下
        //修改图片视图中图片的内容
        cell.activityImageView.image = [UIImage imageNamed:@"image"];
        //修改标签中文字的内容
        cell.activityName.text = @"环太湖骑行";
        //
        cell.activityInfoLable.text = @"从无序滨湖区雪浪街街道太湖出发，绕道苏州、嘉兴、湖州、宜兴，返回无锡";
        cell.activityLikeLable1.text = @"顶：1328";
        cell.activityLikeLable2.text = @"踩：17";

    }else{
    //第二行的情况下
        cell.activityImageView.image = [UIImage imageNamed:@"image1"];
        //修改标签中文字的内容
        cell.activityName.text = @"环西湖骑行";
        //
        cell.activityInfoLable.text = @"由少年宫出发逆时针绕行西湖—断桥—白堤—西冷印社—苏堤春晓—六桥及花港观鱼—南山—中国美术学院还车。";
        cell.activityLikeLable1.text = @"顶：80";
        cell.activityLikeLable2.text = @"踩：8";
    }
   */
    
    return  cell;
}
//添加一个长按手势事件
- (void)addlongPress : (UITableViewCell *)cell{
    //初始化一个长按手势，设置响应的事件为choose：
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(choose:)];
    //设置长按手势相应的时间
    longPress.minimumPressDuration = 1.5;
    //将手势添加给cell
    [cell addGestureRecognizer:longPress];

}
//添加单击手势事件
- (void) addTapGestureRecognizer : (id)any{
    //初始化一个单击手势，设置响应的事件为tapClick:
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
     //将手势添加给入参
    [any addGestureRecognizer:tap];
}
//小图单击手势的响应事件
- (void)tapClick: (UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        

    //拿到长按手势在_activityTableView中的位置
    CGPoint location = [tap locationInView:_activityTableView];
    //通过上述的点拿到在_activityTableView 对应的indexPath
    NSIndexPath *indexPath = [_activityTableView indexPathForRowAtPoint:location];
    //防范！ 防范！
    if (_arr != nil && _arr.count != 0) {
        ActivityModel *activity = _arr[indexPath.row];
        //设置大图片的位置大小
        
        _zoomTV = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        //用交互启用
        _zoomTV.userInteractionEnabled = YES;
        _zoomTV.backgroundColor = [UIColor blackColor];
        //_zoomTV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activity.imgUrl]]];
        [_zoomTV sd_setImageWithURL:[NSURL URLWithString:activity.imgUrl]placeholderImage:[UIImage imageNamed:@"image"]];

        //设置图片的内容模式
        _zoomTV.contentMode = UIViewContentModeScaleAspectFit;
        //获得窗口实例的，并将大图放置到窗口实例上，根据苹果规则，后添加的控件会覆盖前添加的控件
        [[UIApplication sharedApplication].keyWindow addSubview:_zoomTV];
        UITapGestureRecognizer *zoomTVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomTap:)];
        [_zoomTV addGestureRecognizer:zoomTVTap];
        }
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
//长按手指响应事件
- (void)choose: (UILongPressGestureRecognizer *)longPress{
    //判断手势的状态（长按手势有时间间隔，对应的会有开始和结束两种状态）
//    if (longPress.state ==UIGestureRecognizerStateBegan) {
//        NSLog(@"长按!");
//    }else if (longPress.state ==UIGestureRecognizerStateEnded){
//        NSLog(@"结束长按！");
//    }
   
    if (longPress.state ==UIGestureRecognizerStateBegan) {
        //NSLog(@"长按!");
        //拿到长按手势在_activityTableView中的位置
        CGPoint location = [longPress locationInView:_activityTableView];
        //通过上述的点拿到在_activityTableView 对应的indexPath
        NSIndexPath *indexPath = [_activityTableView indexPathForRowAtPoint:location];
        //防范！ 防范！
        if (_arr != nil && _arr.count != 0) {
            //根据行号拿到数组中对应的数据
            ActivityModel *activity = _arr[indexPath.row];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"复制操作" message:@"复制活动名称或内容" preferredStyle: UIAlertControllerStyleActionSheet];
            UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"复制活动名称" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 创建复制版
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                //将活动名称复制
                [pasteboard setString:activity.name];
                
                            
            } ];
            UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"复制活动内容" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 创建复制版
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                //将活动内容复制
                [pasteboard setString:activity.content];
                
                
            } ];

         UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil ];
            [alert addAction:actionC];
            [alert addAction:actionA];
            [alert addAction:actionB];
           
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
}


//设置每一组中每一行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取三要素（计算文字高度的三要素）
    //1、文字内容
    ActivityModel *activity =_arr[indexPath.row];

    NSString *activityContent = activity.content;
    //2、字体大小
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    UIFont *font =cell.activityInfoLable.font;
    //3、宽度尺寸
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    CGSize size = CGSizeMake(width, 1000);
    //根据三元素计算尺寸
     CGFloat height = [activityContent boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : font } context:nil].size.height;
    //活动内容标签的原点y轴位置加上活动内容标签根据文字自适应大小后获得的高度+活动内容标签距离细胞底部的间距
    return cell.activityInfoLable.frame.origin.y + height + 10;
}
//设置每一组中每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前tableView是否为_activityTableView（这个条件判断常用在一个页面中有多个taleView的时候）
    if ([tableView isEqual:_activityTableView]) {
        //取消选中
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }


}



- (IBAction)switchAction:(UIBarButtonItem *)sender {
    
    //注册策划通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftSwitch" object:nil];
    
}

- (IBAction)favoAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_arr !=nil && _arr.count != 0) {
        //通过按钮的下标值减去100000拿到行号，再通过行号拿到对应的数据模型
        ActivityModel *activity = _arr[sender.tag - 100000];
        
        NSString *message= activity.isFavo ? @"是否取消收藏该活动？" : @"是否收藏该活动？";
        
        //创建弹出框，标题为@“提示”，内容为@“是否收藏该活动？”
        UIAlertController *akert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        //创建取消按钮
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        //创建确定按钮
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (activity.isFavo) {
                activity.isFavo = NO;
            }else{
                activity.isFavo = YES;
            }
            [self.activityTableView reloadData];
        }];
        //将按钮添加到弹出框中，（添加按钮的顺序决定了按钮的排版：从左到右；从上到下，取消风格的按钮会在最左边）
        [akert addAction:actionA];
        [akert addAction:actionB];
        
        //用presentViewController的方法，以model的方式显示另一个页面（显示弹出框）
        [self presentViewController:akert animated:YES completion:^{
        }];

    }
}
- (IBAction)searchAction:(UIBarButtonItem *)sender {
    //1、获得要跳转的页面的实例
     IssueViewController *issueVC = [Utilities getStoryboardInstance:@"Issue" byIdentity:@"Issue"];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:issueVC];
    //2、用某种方式跳转到上述页面（这里用Model的方式跳转）
    [self presentViewController:nc animated:YES completion:nil];
    //（这里用Push的方式跳转）
    //[self.navigationController pushViewController:searchVC animated:YES];
}
//当某一个页面跳转行为将要发生的时候
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"List2Detail"]) {
        //当从列表页到详情页的这个跳转要发生的时候
        //1、获取要传递到下一页去的数据
        NSIndexPath *indexPath = [_activityTableView indexPathForSelectedRow];
        ActivityModel *activity = _arr[indexPath.row];
        //2、获取下一页这个实例
        DetailViewController *detailVC = segue.destinationViewController;
        //3、把数据给下一页预备好的接受容器
        detailVC.activity = activity;
    }
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;{
    if (error) {
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
                break;
                
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
                break;
                
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw", nil) andTitle:nil onView:self];
                break;
                
            default:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError", nil) andTitle:nil onView:self];
                break;
        }
    }
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    //NSLog(@"纬度：%f",newLocation.coordinate.latitude);
    //NSLog(@"经度：%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿到城市
    if (firstVisit) {
        firstVisit = !firstVisit;
        //根据定位拿到城市
        [self getRegeoViaCoordinate];
    }
}

- (void)getRegeoViaCoordinate{
    //dispatch表示从now开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用dispatch设置好的策略去做这些事情
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                //NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                 cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"LocCity"];
                //将定位到的城市保存到单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:cityStr];
                if (![cityStr isEqualToString:_cityButton.titleLabel.text]) {
                    //当定位到的城市和当前选择的城市不一样的时候去弹窗询问用户是否要切换城市
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的的城市为%@,请问您是否要切换",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * yesAction = [UIAlertAction actionWithTitle: @"确认"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_cityButton setTitle:cityStr forState:UIControlStateNormal];
                        //修改用户选择城市记忆体
                        [Utilities removeUserDefaults:@"UserCity"];
                        
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                        //重新执行网络请求
                        [self networkRequest];
                    }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                    [alertView addAction:yesAction];
                    [alertView addAction:noAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                }
                
            }
        }];
        //关闭开关
        [_locMgr stopUpdatingLocation];
    });
}


- (void)checkCityState:(NSNotification *)note{
    NSString *cityStr = note.object;
    if (![cityStr isEqualToString:_cityButton.titleLabel.text]) {
        //修改城市按钮标题
        [_cityButton setTitle:cityStr forState:UIControlStateNormal];
        //修改用户选择城市记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新执行网络请求
        [self networkRequest];
    }
}

@end
