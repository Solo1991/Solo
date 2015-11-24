//
//  settingManager.h
//  inche
//
//  Created by MIX on 15/2/2.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface settingManager : NSObject

+ (settingManager *)shardSettingsManager;
@property (nonatomic) BOOL isFirstRun;       //第一次开启配置
@property (nonatomic) BOOL isRemberPassWord; //是否记住密码
@property (nonatomic) BOOL isLogInEnter;     //用户是否登录




- (BOOL)isFirstRun;

#pragma -mark DeviceToken
-(NSString*)userToken;
-(void)setUserToken:(NSString *)userToken;
#pragma -mark 用户街道定位
-(NSString*)userStreet;
-(void)setUserStreet:(NSString *)userStreet;
#pragma -mark 用户纬度
-(NSString*)userLatitude;
-(void)setUserLatitude:(NSString *)userLatitude;
#pragma -mark 用户经度
-(NSString*)userLongitude;
-(void)setUserLongitude:(NSString *)userLongitude;





#pragma -mark 用户省份
-(NSString*)userProvinces;
-(void)setUserProvinces:(NSString *)userProvinces;
#pragma -mark 用户城市
-(NSString*)userCity;
-(void)setUserCity:(NSString *)userCity;
#pragma -mark 用户城市定位
-(NSString*)userCityPosition;
-(void)setUserCityPosition:(NSString *)userCityPosition;
#pragma -mark 用户城市区域
-(NSString*)userArea;
-(void)setUserArea:(NSString *)userArea;
#pragma -mark 用户城市ID
-(NSString*)userCityID;
-(void)setUserCityID:(NSString *)userCityID;


#pragma -mark 用户收藏车型ID列表
-(NSMutableArray *)userCollectionDatas;
-(void)setUserCollectionDatas:(NSMutableArray *)datas;

@end
