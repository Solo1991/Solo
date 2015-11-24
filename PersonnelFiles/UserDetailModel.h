//
//  UserDetailModel.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/18.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailModel : NSObject
/**
 *  用户编号
 */
@property(nonatomic,strong)NSNumber *randId;
/**
 *  动态id
 */
@property(nonatomic,strong)NSNumber *bdID;
/**
 *  姓名
 */
@property(nonatomic,strong)NSString *bdname;
/**
 *  年龄
 */
@property(nonatomic,strong)NSNumber *bdage;
/**
 *  性别
 */
@property(nonatomic,strong)NSString *bdgender;
/**
 *  职业
 */
@property(nonatomic,strong)NSString *bdjob;
/**
 *  省
 */
@property(nonatomic,strong)NSString *bdprovince;
/**
 *  城市
 */
@property(nonatomic,strong)NSString *bdcity;
/**
 *  区
 */
@property(nonatomic,strong)NSString *bdarea;
/**
 *  爱好
 */
@property(nonatomic,strong)NSString *bdhobby;
/**
 *  微信号
 */
@property(nonatomic,strong)NSString *bdwx;
/**
 *  我想
 */
@property(nonatomic,strong)NSString *bddo;
/**
 *  图片
 */
@property(nonatomic,strong)NSString *img;
/**
 *  评论总数
 */
@property(nonatomic,strong)NSNumber *replyCount;
/**
 *  赞数量
 */
@property(nonatomic,strong)NSNumber *zanCount;
/**
 *  分享数量
 */
@property(nonatomic,strong)NSString *shareCount;
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
/**
 *  图片数组
 */
@property(nonatomic,strong)NSMutableArray *imageArr;

/**
 *  用户编号
 */
@property(nonatomic,strong)NSString *time;

//访问量
@property(nonatomic,strong)NSString *visited;

@end
