//
//  userModel.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/18.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userModel : NSObject
/**
 *  用户名
 */
@property(nonatomic,strong)NSString* username;
/**
 *  手机号
 */
@property(nonatomic,strong)NSString* phone;
/**
 *  个性签名
 */
@property(nonatomic,strong)NSString* desc;
/**
 *  男女
 */
@property(nonatomic,strong)NSNumber* gender;
/**
 *  用户头像地址
 */
@property(nonatomic,strong)NSString* img;
/**
 *  随机ID
 */
@property(nonatomic,strong)NSString* randId;
/**
 *  年龄
 */
@property(nonatomic,strong)NSString* age;
@end
