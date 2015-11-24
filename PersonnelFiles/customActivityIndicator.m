//
//  customActivityIndicator.m
//  PersonnelFiles
//
//  Created by Solo on 15/7/1.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "customActivityIndicator.h"
static UIActivityIndicatorView *testActivityIndicator;
@interface customActivityIndicator(){
    
     ;
}
@end
@implementation customActivityIndicator


+(UIActivityIndicatorView*)returnActivityIndicator
{
    testActivityIndicator= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(22, 22);
    testActivityIndicator.color = [UIColor whiteColor];
    return testActivityIndicator;
     // 开始旋转
}

+(void)startAnimating
{
    [testActivityIndicator startAnimating];
}

+(void)stopAnimating
{
        [testActivityIndicator stopAnimating]; // 结束旋转
}

+(void)hideAnimating
{
  [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

}

@end
