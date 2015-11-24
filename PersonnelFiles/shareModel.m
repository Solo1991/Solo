//
//  shareModel.m
//  inche
//
//  Created by MIX on 15/2/9.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import "shareModel.h"
#import "quickMethod.h"

@implementation shareModel

-(instancetype)initWithImgURL:(NSString*)imgURL
                         With:(NSString*)url
                         With:(NSString*)title
                         With:(NSString*)instro
{
    self = [super init];
    if (!self) {
        
    }
    
    self.shareImgURL =imgURL;
    self.shareURL    =url;
    self.shareTitle  =title;
    self.shareInstro =instro;
    [self handlePreShareWith:imgURL];
    
    return self;
}




-(void)handlePreShareWith:(NSString*)imgUrl
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
        NSData  *imgData;
        if(UIImagePNGRepresentation(image))
        {
            imgData = UIImagePNGRepresentation(image);
        }else{
            imgData= UIImageJPEGRepresentation(image, 1);
           
        }

        if(imgData.length >= 32000){
            image=[quickMethod imageWithImageSimple:image];
            imgData = UIImagePNGRepresentation(image);
        }
        
        if(imgData.length >= 32000){
            imgData = UIImageJPEGRepresentation(image, 0.1);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shareImg    = image;
            self.shareImgData= imgData;
        });
    });
}

@end
