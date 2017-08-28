//
//  ActivityModel.h
//  ActivityList
//
//  Created by admin on 17/7/26.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property (strong,nonatomic) NSString *activityID;
@property (strong,nonatomic) NSString *imgUrl; //活动图片url字符串
@property (strong,nonatomic) NSString *name;   //活动名称
@property (strong,nonatomic) NSString *content;//活动内容
@property (nonatomic) NSInteger like;                 //活动点赞数
@property (nonatomic) NSInteger unlike;             //活动被踩数
@property (nonatomic) BOOL isFavo;                   //活动是否被收藏
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *applyFee;
@property (strong,nonatomic) NSString *attendence;
@property (strong,nonatomic) NSString *limitation;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *issuer;
@property (strong,nonatomic) NSString *phone;
@property (nonatomic) NSTimeInterval dueTime;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;
@property (nonatomic) NSInteger status;

-(id)initWithDictionary:(NSDictionary *)dict;
-(id)initWithDetailDictionary:(NSDictionary *)dict;
@end
