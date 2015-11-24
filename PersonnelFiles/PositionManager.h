//
//  PositionManager.h
//  inche
//
//  Created by MIX on 15/1/15.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PositionManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic,retain)CLLocationManager *locationManager;//用户定位管理
@property (nonatomic,strong)CLLocation *checkinLocation;//用于保存获取到的位置信息
@property (nonatomic,strong)CLGeocoder *gegoder;

+(PositionManager *)shardMobilePosition;
-(void)startAddress;


@property (nonatomic,strong) NSString*longitude;
@property (nonatomic,strong) NSString*latitude;
@property (nonatomic,strong) NSString*street;

@end
