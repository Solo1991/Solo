//
//  quickMethod.m
//  inche
//
//  Created by MIX on 15/1/20.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import "quickMethod.h"
#import "WXApi.h"
@implementation quickMethod


//修改图片大小 图片太大 进行缩小
+ (UIImage *)imageWithImageSimple:(UIImage*)image {
    
    CGSize newSize =CGSizeMake(image.size.width/5,image.size.height/5);
    
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

//对比图片 大小进行压缩。
+(UIImage*)CompressionImageDataWith:(UIImage*)image
{
    float scale = image.size.height/1000;
    
    CGSize newSize =CGSizeMake(image.size.width/scale,image.size.height/scale);
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
    
    //NSData* imgData= UIImageJPEGRepresentation(image, 0.1);//对图片数据进行压缩.
    //if(imgData.length >= 1000*1000){
    //    image=[quickMethod imageWithImageSimple:image];
    //    imgData=UIImageJPEGRepresentation(image, 1);
    //}
    //return [UIImage imageWithData:imgData];
}


+(void)doCornerRadiusWith:(UIView*)view
               WithRadius:(float)radius
          WithBorderWidth:(float)width
                WithColor:(UIColor*)color
{
    [view.layer setCornerRadius:radius];
    [view.layer setBorderWidth:width];
    [view.layer setBorderColor:[color CGColor]];
    [view.layer setMasksToBounds:YES];
};




+(NSArray*)getImageUrlArrayFromString:(NSString*)imageUrl_more
{
    NSString * string = imageUrl_more;
    NSArray  * arr = [string componentsSeparatedByString:NSLocalizedString(@",", nil)];
    return arr;
}



/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)quickGetTimeFormWith:(NSString*)compareDate
//
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate *date =[dateFormat dateFromString:compareDate];
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+(NSString*)transformTimeToString:(NSString*)time
{
    
    NSInteger num = [time integerValue];//（重点）
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString*confromTimespStr =[formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

/**
 *  设置size
 */
+(void)setSize:(CGSize)size with:(UIView*)view
{
    
    CGRect frame = view.frame;
    frame.size  = size;
    view.frame = frame;
}


+(void)copyWechat:(NSString*)weChat
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = weChat;
    
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"已成功复制"
                                                contentText:@"是否添加为微信好友？"
                                            leftButtonTitle:@"拂袖而去"
                                           rightButtonTitle:@"打开看看"];
    [alert show];
    alert.leftBlock = ^() {
    };
    alert.rightBlock = ^() {
        [WXApi openWXApp];
    };
    alert.dismissBlock = ^() {
    };
}

@end
