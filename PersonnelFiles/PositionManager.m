//
//  PositionManager.m
//  inche
//
//  Created by MIX on 15/1/15.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import "PositionManager.h"
#import "settingManager.h"
#import "LoadData.h"
#import "LoginTool.h"
@implementation PositionManager

static PositionManager *mobilePosition=nil;
+(PositionManager *)shardMobilePosition
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        mobilePosition = [[self alloc] init];
    });
    return mobilePosition;
}




#pragma -mark ---------------开始定位--------------
-(void)startAddress
{
    self.locationManager = [[CLLocationManager alloc] init] ;
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if (IOS_VERSION>=8.0) {
            [self.locationManager requestAlwaysAuthorization];//添加这句
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog( @"Cannot Starting CLLocationManager" );
    }
}






#pragma -mark ---------------Delegate--------------

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"x:%@ ",[locations lastObject]);
    CLLocation *currLocation = [locations lastObject];

    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    //[[settingManager shardSettingsManager] setUserLongitude:[NSString stringWithFormat:@"%f",currLocation.coordinate.longitude]];
    //[[settingManager shardSettingsManager] setUserLatitude:[NSString stringWithFormat:@"%f",currLocation.coordinate.latitude]];
    self.longitude = [NSString stringWithFormat:@"%f",currLocation.coordinate.longitude+0.018];
    self.latitude  = [NSString stringWithFormat:@"%f",currLocation.coordinate.latitude+0.0116];
    
    if (!self.gegoder) {
        self.gegoder=[[CLGeocoder alloc]init];
    }
    
    self.checkinLocation=[[CLLocation alloc]initWithLatitude:currLocation.coordinate.latitude+0.0116 longitude:currLocation.coordinate.longitude+0.018];
    
    [self.gegoder reverseGeocodeLocation:self.checkinLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *country = placemark.ISOcountryCode;//国家CN
            NSString *city = placemark.locality;//城市 厦门市
            NSString *street = placemark.subLocality;//中国福建省厦门市思明区莲前街道虎仔山路
            NSLog(@"%@",city);
//            NSLog(@"---%@..........%@......%@......cout:%@",country,city,street,placemark.administrativeArea);
            

            [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"city ---%@",[LoginTool returnCity]);   
            self.street = street;
        }else if(error||placemarks.count==0){
            
            NSLog(@"error:%@",error);
        }
    }];
    
    
    [self.locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    
    //UIAlertView *alter;
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:{
            if (IOS_VERSION>=8.0) {
            //[self.locationManager requestAlwaysAuthorization];//始终允许访问位置信息
            [self.locationManager requestWhenInUseAuthorization];//使用应用程序期间允许访问位置数据
            }
        }
            break;
        default:
            break;
    }
}



@end
