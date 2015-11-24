//
//  MainNavModel.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/17.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetailModel.h"
@interface MainNavModel : NSObject
/**
 *  动态id
 */
@property(nonatomic,strong)NSNumber *mainNewID;
/**
 *  用户名
 */
@property(nonatomic,strong)NSString *username;
/**
 *  用户头像
 */
@property(nonatomic,strong)NSString *userImg;
/**
 *  性别
 */
@property(nonatomic,strong)NSNumber *userGender;
/**
 *  用户编号
 */
@property(nonatomic,strong)NSString *randId;
/**
 *  回复数
 */
@property(nonatomic,strong)NSNumber *replys;
/**
 *  分享数数
 */
@property(nonatomic,strong)NSNumber *parised;
/**
 *  点赞数
 */
@property(nonatomic,strong)NSNumber *collect;
/**
 *  发布时间
 */
@property(nonatomic,strong)NSString *createdAt;
/**
 *  我想
 */
@property(nonatomic,strong)NSString *bddo;
/**
 *  微信
 */
@property(nonatomic,strong)NSString *weChat;

/**
 *  是否被分享过
 */
@property(nonatomic,strong)NSString *isParised;
/**
 *  是否点赞过
 */
@property(nonatomic,strong)NSString *isCollect;
/**
 *  是否被评论过
 */
@property(nonatomic,strong)NSString *isReply;

//访问量
@property(nonatomic,strong)NSString *visited;
/**
 *  body
 */
@property(nonatomic,strong)UserDetailModel *detailModel;

@end
