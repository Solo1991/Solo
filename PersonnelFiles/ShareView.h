//
//  ShareView.h
//  shareDemo
//
//  Created by MIX on 15/1/5.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ShareView : UIView

- (instancetype)initWithActionArray:(NSArray *)actions;
- (void)show;
- (void)dismiss;

@property(strong,nonatomic)void(^touchBnt)(int index);
@end


@interface shareData : NSObject
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) void(^handler)(void);
- (instancetype)initWithName:(NSString *)name
                    iconName:(NSString *)iconName
                     handler:(void(^)(void))handler;
@end


/*
 actions = @[@"row title one",                   //with title
 @[action1, action2, action3, ...],
 @"row title two",                   //with title
 @[action4, action5],
 @"",                                //without title
 @[action6, action7],
 ...];
 */