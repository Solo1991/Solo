//
//  quickMethod.h
//  inche
//
//  Created by MIX on 15/1/20.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface quickMethod : NSObject

//缩小图片
+ (UIImage *) imageWithImageSimple:(UIImage*)image;

//对比图片 大小进行压缩。
+(UIImage*)CompressionImageDataWith:(UIImage*)image;

//给控件添加圆角
+(void)doCornerRadiusWith:(UIView*)view
               WithRadius:(float)radius
          WithBorderWidth:(float)width
                WithColor:(UIColor*)color;

//从服务器获取的 more图片地址字符串  截取转成 图片地址数组。
+(NSArray*)getImageUrlArrayFromString:(NSString*)imageUrl_more;

//从服务器下传的时间字符串  改成天数差的格式
+(NSString *)quickGetTimeFormWith:(NSString*)compareDate;

//服务器时间码转化
+(NSString*)transformTimeToString:(NSString*)time;
//设置尺寸
+(void)setSize:(CGSize)size with:(UIView*)view;

/**
 *  复制打开微信
 */
+(void)copyWechat:(NSString*)weChat;
@end
