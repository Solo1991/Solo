//
//  customActivityIndicator.h
//  PersonnelFiles
//
//  Created by Solo on 15/7/1.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface customActivityIndicator : NSObject


/**
 *  返回一个ActivityIndicator
 *
 */
+(UIActivityIndicatorView*)returnActivityIndicator;
/**
 *  开始动画
 */
+(void)startAnimating;
/**
 *  停止动画
 */
+(void)stopAnimating;
/**
 *  隐藏动画
 */
+(void)hideAnimating;
@end
