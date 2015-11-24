//
//  LoadData.h
//  StoreDemo
//
//  Created by Solo on 15/5/7.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userModel.h"
@interface LoadData : NSObject
/**
 *  回调数组
 */
@property (nonatomic, copy) void (^ReturnLoadDataWithArrBlock)(NSMutableArray *array);
/**
 *  回调字典
 */
@property (nonatomic, copy) void (^ReturnLoadDataWithDictBlock)(NSDictionary *dict);
/**
 *  回调用户model
 */
@property (nonatomic, copy) void (^ReturnLoadDataWithUserModelBlock)(userModel *model);
@property (nonatomic, copy) void (^ReturnStrBlock)(NSString * callBack);

/**
 *  返回码
 */
@property (nonatomic, copy) void (^ReturnCodeBlock)(NSNumber * callCode);

+(LoadData*)LoadDatakWithUrl:(NSString*)url WithDic:(NSDictionary*)para withCount:(int)count;

+(LoadData*)LoadDataImageArrWithUrl:(NSString*)url WithDic:(NSDictionary*)para withArr:(NSMutableArray *)ImageArr;


/**
 *  返回码
 */
@property (nonatomic, copy) void (^ReturnErrorBlock)(NSString * callError);
@end