//
//  postPic.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/25.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "postPic.h"
#import "LoginTool.h"
#import "LoadData.h"
#import "AppDelegate.h"
#import "MLSelectPhotoPickerViewController.h"

@implementation postPic


+(NSString*)PostImageWith:(UIImage*)imageName with:(NSMutableArray*)imageArr
{

    
    
    
    NSDictionary *dict = @{
                           @"randId":[LoginTool returnRandId],
                           @"code"  : [postPic imageToNSString:imageName],
                           };
    
    LoadData *getNewData = [LoadData LoadDatakWithUrl:@"" WithDic:dict withCount:30];
    
   __block NSString *urlStr = [[NSString alloc] init];
    
    getNewData.ReturnStrBlock = ^(NSString * callBack)
    {
        
        NSDictionary *userInfo = @{
                                   @"imageUrl":callBack
                                   };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postSeccess" object:self userInfo:userInfo];
        
        
    };

    return urlStr;
}


+ (NSString *)imageToNSString:(UIImage*)selectImage
{
    
    NSData      *data        = UIImagePNGRepresentation(selectImage);
    NSString    *dataStr     = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString    *baseCode    = [NSString stringWithFormat:@"data:image/png;base64,%@",dataStr];

    return  baseCode;
}
@end
