//
//  UserModel.h
//  ActivityList
//
//  Created by admin1 on 2017/8/23.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (strong,nonatomic) NSString *memberID;
@property (strong,nonatomic) NSString *phone;
@property (strong,nonatomic) NSString *nickname;
@property (strong,nonatomic) NSString *age;
//出生日期
@property (strong,nonatomic) NSString *dob;
@property (strong,nonatomic) NSString *idCardNo;
//性别
@property (strong,nonatomic) NSString *gender;
//用户头像网址
@property (strong,nonatomic) NSString *avatarUrl;
//令牌钥匙
@property (strong,nonatomic) NSString *tokenkey;
//积分
@property (strong,nonatomic) NSString *creadit;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
