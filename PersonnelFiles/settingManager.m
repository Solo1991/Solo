//
//  settingManager.m
//  inche
//
//  Created by MIX on 15/2/2.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//


static NSString *Inche_Frist_Run        = @"Frist_Run";
static NSString *Inche_Frist_Enter      = @"Inche_Frist_Enter";
static NSString *Inche_ISRemberPassWord = @"Inche_ISRemberPassWord";
static NSString *Inche_IsLogInEnter     = @"Inche_IsLogInEnter";


static NSString *Inche_DeviceToken      = @"Frist_Run";

static NSString *Inche_UserProvinces    = @"Inche_UserProvinces";
static NSString *Inche_UserCity         = @"Inche_UserCity";
static NSString *Inche_UserCityID       = @"Inche_UserCityID";
static NSString *Inche_UserCityPosition = @"Inche_UserCityPosition";
static NSString *Inche_UserCityStreet   = @"Inche_UserCityStreet";
static NSString *Inche_UserArea         = @"Inche_UserArea";

static NSString *Inche_UserLatitude     = @"Inche_UserLatitude";
static NSString *Inche_UserLongitude    = @"Inche_UserLongitude";


static NSString *Inche_UserCollection   = @"Inche_UserCollection";



#import "settingManager.h"

@interface settingManager()
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@end

@implementation settingManager

#pragma -mark ------------------------初始化------------------------
static settingManager *settingsManager=nil;
+(settingManager *)shardSettingsManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        settingsManager = [[self alloc] init];
    });
    return settingsManager;
}

-(id)init
{
    if (self = [super init])
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        NSObject *firstObject = [self.userDefaults objectForKey:Inche_Frist_Run];
        
        if (firstObject == nil){
            self.isFirstRun = YES;
        }else{
            self.isFirstRun = NO;
        }
        [self.userDefaults synchronize];
    }
    return self;
}

#pragma -mark- ------------------------程序设置------------------------
#pragma -mark 第一次开启配置
- (BOOL)isFirstRun
{
    return [self.userDefaults boolForKey:Inche_Frist_Run];
}




#pragma -mark  DeviceToken
-(NSString*)userToken
{
    return [self.userDefaults stringForKey:Inche_DeviceToken]?[self.userDefaults stringForKey:Inche_DeviceToken]:@"";
}
-(void)setUserToken:(NSString *)userToken
{
    [self.userDefaults setObject:userToken forKey:Inche_DeviceToken];
    [self.userDefaults synchronize];
}




#pragma -mark 用户省份
-(NSString*)userProvinces
{
    return [self.userDefaults stringForKey:Inche_UserProvinces];
}
-(void)setUserProvinces:(NSString *)userProvinces
{
    [self.userDefaults setObject:userProvinces forKey:Inche_UserProvinces];
    [self.userDefaults synchronize];
}

#pragma -mark 用户城市
-(NSString*)userCity
{
    return [self.userDefaults stringForKey:Inche_UserCity];
}
-(void)setUserCity:(NSString *)userCity
{
    [self.userDefaults setObject:userCity forKey:Inche_UserCity];
    [self.userDefaults synchronize];
}
#pragma -mark 用户城市定位
-(NSString*)userCityPosition
{
    return [self.userDefaults stringForKey:Inche_UserCityPosition];
}
-(void)setUserCityPosition:(NSString *)userCityPosition
{
    [self.userDefaults setObject:userCityPosition forKey:Inche_UserCityPosition];
    [self.userDefaults synchronize];
}
#pragma -mark 用户街道定位
-(NSString*)userStreet
{
    return [self.userDefaults stringForKey:Inche_UserCityStreet];
}
-(void)setUserStreet:(NSString *)userStreet
{
    [self.userDefaults setObject:userStreet forKey:Inche_UserCityStreet];
    [self.userDefaults synchronize];
}
#pragma -mark 用户城市区域
-(NSString*)userArea
{
    return [self.userDefaults stringForKey:Inche_UserArea];
}
-(void)setUserArea:(NSString *)userArea
{
    [self.userDefaults setObject:userArea forKey:Inche_UserArea];
    [self.userDefaults synchronize];
}

#pragma -mark 用户纬度

-(NSString*)userLatitude
{
    return [self.userDefaults stringForKey:Inche_UserLatitude];
}
-(void)setUserLatitude:(NSString *)userLatitude
{
    [self.userDefaults setObject:userLatitude forKey:Inche_UserLatitude];
    [self.userDefaults synchronize];
}

#pragma -mark 用户经度
-(NSString*)userLongitude
{
    return [self.userDefaults stringForKey:Inche_UserLongitude];
}
-(void)setUserLongitude:(NSString *)userLongitude
{
    [self.userDefaults setObject:userLongitude forKey:Inche_UserLongitude];
    [self.userDefaults synchronize];
}

#pragma -mark 用户城市ID
-(NSString*)userCityID
{
    return [self.userDefaults stringForKey:Inche_UserCityID];
}
-(void)setUserCityID:(NSString *)userCityID
{
    [self.userDefaults setObject:userCityID forKey:Inche_UserCityID];
    [self.userDefaults synchronize];
}



#pragma -mark 用户收藏车型ID列表
-(NSMutableArray *)userCollectionDatas
{
    if([self.userDefaults mutableArrayValueForKey:Inche_UserCollection].count<=0){
        return [[NSMutableArray alloc] init];
    }
    return [self.userDefaults mutableArrayValueForKey:Inche_UserCollection];
}
-(void)setUserCollectionDatas:(NSMutableArray *)datas{
    if(datas.count<=0){
         datas = [[NSMutableArray alloc] init];
    }
    [self.userDefaults setObject:datas forKey:Inche_UserCollection];
    [self.userDefaults synchronize];
}


@end
