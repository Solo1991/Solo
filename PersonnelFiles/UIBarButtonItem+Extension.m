//
//  UIBarButtonItem+Extension.m
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "quickMethod.h"
@implementation UIBarButtonItem (Extension)
/**
 *  创建一个item
 *  
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action btn:(UIButton*)originBtn imageStr:(NSString *)image highImageStr:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    [quickMethod setSize:CGSizeMake(20, 20) with:btn];
    originBtn = btn;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    // 设置尺寸
    [quickMethod setSize:CGSizeMake(30, 30) with:btn];
    
    [btn.layer setCornerRadius:16];
    [btn.layer setBorderColor:(__bridge CGColorRef)([UIColor redColor])];
    [btn.layer setBorderWidth:1.0];
    
    [btn.layer setMasksToBounds:YES];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

/**
 *  设置返回键无文字
 *
 */
+(UIBarButtonItem *)setUIBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    return item;
}

@end
