//
//  UIBarButtonItem+Extension.h
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action btn:(UIButton*)originBtn imageStr:(NSString *)image highImageStr:(NSString *)highImage;

+(UIBarButtonItem *)setUIBarButtonItem;
@end
