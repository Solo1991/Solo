//
//  shareModel.h
//  inche
//
//  Created by MIX on 15/2/9.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shareModel : NSObject

-(instancetype)initWithImgURL:(NSString*)imgURL
                         With:(NSString*)url
                         With:(NSString*)title
                         With:(NSString*)instro;


@property (nonatomic,strong) UIImage *shareImg;
@property (nonatomic,strong) NSString*shareImgURL;
@property (nonatomic,strong) NSData  *shareImgData;
@property (nonatomic,strong) NSString*shareURL;
@property (nonatomic,strong) NSString*shareTitle;
@property (nonatomic,strong) NSString*shareInstro;

@end