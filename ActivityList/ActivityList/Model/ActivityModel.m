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
        _activityID=[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
    self.imgUrl =[dict [@"imgUrl"]isKindOfClass:[NSNull class] ] ? @"" : dict[@"imgUrl"];
    self.content = [dict[@"content"]isKindOfClass:[NSNull class]] ?@"活动" : dict[@"content"];
    self.name = [dict[@"name"]isKindOfClass:[NSNull class]] ?@"暂无内容" : dict[@"name"];
    self.like = [dict[@"reliableNumber"]isKindOfClass:[NSNull class]] ? 0 :[dict[@"reliableNumber"] integerValue] ;
    self.unlike = [dict[@"unReliableNumber"]isKindOfClass:[NSNull class]] ? 0 :[dict[@"unReliableNumber"] integerValue] ;
    self.isFavo = [dict[@"isFavo"]isKindOfClass:[NSNull class]] ? NO : [dict[@"isFavo"] boolValue];
   
    }
     return self;
}
-(id)initWithDetailDictionary:(NSDictionary *)dict{
    //    if ([dict[@"imgURL"] isKindOfClass:[NSNull class]]) {
    //        _imgUrl = @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A";
    //
    //    }else{
    //        _imgUrl = dict[@"imgURL"];
    //
    //    }
    self = [super init];
    if (self) {
        _activityID=[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
        _imgUrl =[Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@"0"];

        _content = [Utilities nullAndNilCheck:dict[@"content"] replaceBy:@"暂无内容"];

        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"活动"];

        _like = [dict[@"reliableNumber"]isKindOfClass:[NSNull class]] ? 0 :[dict[@"reliableNumber"] integerValue] ;
        _unlike = [dict[@"unReliableNumber"]isKindOfClass:[NSNull class]] ? 0 :[dict[@"unReliableNumber"] integerValue] ;
        _isFavo = [dict[@"isFavo"]isKindOfClass:[NSNull class]] ? NO : [dict[@"isFavo"] boolValue];
        _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
        _applyFee = [Utilities nullAndNilCheck:dict[@"applicationFee"] replaceBy:@"0"];
        _attendence = [Utilities nullAndNilCheck:dict[@"participantsNumber"] replaceBy:@"0"];
        _limitation = [Utilities nullAndNilCheck:dict[@"attendenceAmount"] replaceBy:@"0"];
        _type = [Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@"普通活动"];
        _issuer = [Utilities nullAndNilCheck:dict[@"issuerName"] replaceBy:@"未知发布者"];
        _phone = [Utilities nullAndNilCheck:dict[@"issuerPhone"] replaceBy:@""];
        _dueTime = [dict[@"applicationExpirationDate"]isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : [dict[@"applicationExpirationDate"]integerValue];
        _startTime = [dict[@"startDate"]isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : [dict[@"startDate"]integerValue];
        _endTime = [dict[@"endDate"]isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : [dict[@"endDate"]integerValue];
        _status = [dict[@"applyStatus"]isKindOfClass:[NSNull class]] ? -1 : [dict[@"applyStatus"]integerValue];
    }
    return self;
}

@end
