//
//  ActivityModel.m
//  ActivityList
//
//  Created by admin on 17/7/26.
//  Copyright © 2017年 self. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel
-(id)initWithDictionary:(NSDictionary *)dict{
//    if ([dict[@"imgURL"] isKindOfClass:[NSNull class]]) {
//        _imgUrl = @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A";
//
//    }else{
//        _imgUrl = dict[@"imgURL"];
//        
//    }
    self = [super init];
    if (self) {
        
    self.imgUrl =[dict [@"imgUrl"]isKindOfClass:[NSNull class] ] ? @"" : dict[@"imgUrl"];
    self.content = [dict[@"content"]isKindOfClass:[NSNull class]] ?@"活动" : dict[@"content"];
    self.name = [dict[@"name"]isKindOfClass:[NSNull class]] ?@"暂无内容" : dict[@"name"];
    self.like = [dict[@"reliableNumber"]isKindOfClass:[NSNull class]] ? 0 :[dict[@"reliableNumber"] integerValue] ;
    self.unlike = [dict[@"unReliableNumber"]isKindOfClass:[NSNull class]] ? 0 :[dict[@"unReliableNumber"] integerValue] ;
    self.isFavo = [dict[@"isFavo"]isKindOfClass:[NSNull class]] ? NO : [dict[@"isFavo"] boolValue];
   
    }
     return self;
}
@end
