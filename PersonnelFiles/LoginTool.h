//
//  LoginTool.h
//  ShareDemo
//
//  Created by Solo on 15/5/27.
//  Copyright (c) 2015年 Solo. All rights reserved.
//



#import <Foundation/Foundation.h>


#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "userModel.h"
@interface LoginTool : NSObject

@property(nonatomic,strong)NSDictionary *para;

//单例
+ (instancetype)sharedInstance;
/**
 *  微博登陆
 */
-(void)weiBoLogin;
/**
 *  qq登陆
 */
-(void)qQLogin;
/**
 *  wechat登陆
 */
-(void)weChatLogin;
/**
 *  初始化登陆sdk
 */
-(void)initSdk;
/**
 *  微博登陆回调
 */
-(BOOL)weiBoHandleWith:(NSURL *)url;
/**
 *  qq登陆回调
 */
-(BOOL)qQHandleWith:(NSURL *)url;
/**
 *  wechat登陆回调
 */
-(BOOL)weChatHandleWith:(NSURL *)url ;
/**
 *  返回randID
 */
+(NSString*)returnRandId;
/**
 *  返回token
 */
+(NSString*)returnToken;
/**
 *  返回头像url
 */
+(NSURL*)returnHeadImage;
/**
 *  返回用户头像
 */
+(NSString*)returnName;
/**
 *  返回用户性别
 */
+(NSNumber*)returnGender;
/**
 *  返回区
 */
+(NSString*)returnstreet;
/**
 *  返回城市
 */
+(NSString*)returnCity;
/**
 *  返回用户数据
 */
+(userModel*)returnUserModel;
//分享

/**
 *  判断是否第一次打开应用
 */
+(userModel*)returnLoginKey;
/**
 *  后台判断是否隐藏登陆按钮
 */
+(userModel*)returnjudgeKey;



-(void)QQShareWithTitle:(NSString*)title
              WithIntro:(NSString*)intro
                WithURL:(NSString*)url
           WithImageURL:(NSString*)imgUrl;

-(void)QQZoneShareWithTitle:(NSString*)title
                  WithIntro:(NSString*)intro
                    WithURL:(NSString*)url
               WithImageURL:(NSString*)imgUrl
                WithComment:(NSString*)comment;

-(void)WeChatFriendsShareWithTitle:(NSString*)title
                         WithIntro:(NSString*)intro
                           WithURL:(NSString*)url
                     WithImageData:(NSData*)imgData
                         WithImage:(UIImage*)image;

-(void)WeChatFriendsCircleShareWithTitle:(NSString*)title
                               WithIntro:(NSString*)intro
                                 WithURL:(NSString*)url
                           WithImageData:(NSData*)imgData
                               WithImage:(UIImage*)image;

-(void)postRequestWith:(NSDictionary*)dict;
-(void)setNameAndImage:(userModel*)model;

@end
