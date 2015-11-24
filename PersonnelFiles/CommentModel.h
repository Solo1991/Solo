//
//  CommentModel.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/20.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/**
 *  parentId
 */
@property(nonatomic,strong)NSNumber* parentId;
/**
 *  From 随机 ID
 */
@property(nonatomic,strong)NSNumber* userFromId;
/**
 *  To ID
 */
@property(nonatomic,strong)NSNumber* userToId;
/**
 *  From 用户名
 */
@property(nonatomic,strong)NSString* userFromName;
/**
 *  To用户名
 */
@property(nonatomic,strong)NSString* userToName;
/**
 *  From 头像
 */
@property(nonatomic,strong)NSString* userFromImg;
/**
 *  To 头像
 */
@property(nonatomic,strong)NSString* userToImg;
/**
 *  回复内容
 */
@property(nonatomic,strong)NSString *body;
/**
 *  回复时间
 */
@property(nonatomic,strong)NSString* createdAt;
/**
 *   来自性别
 */
@property(nonatomic,strong)NSNumber* userFromGender;
/**
 *  To性别
 */
@property(nonatomic,strong)NSString* userToGender;
@end
