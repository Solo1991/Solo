//
//  postPic.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/25.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface postPic : NSObject
+(NSString*)PostImageWith:(UIImage *)imageName with:(NSMutableArray*)imageArr;

+ (NSString *)imageToNSString:(UIImage*)selectImage;
@end
