//
//  MTCityViewController.h
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTCityViewController : UIViewController
@property (nonatomic, copy) void (^ReturnTextBlock)(NSString* cityName);
@end