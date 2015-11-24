//
//  inputView.h
//  inche
//
//  Created by MIX on 15/1/19.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol inputViewDelegate<NSObject>

@optional
- (void)shareAction;
- (void)mediaAction;
- (void)cancelAction;
- (void)sureAction;
- (void)returnKeyAction;




@end

@interface inputView : UIView

@property (weak  , nonatomic) id<inputViewDelegate> delegate;
@property (strong, nonatomic) UITextView *textView;

- (id)initWith:(BOOL)hasMedia With:(BOOL)hasSend;
- (id)initWith:(BOOL)hasMedia With:(BOOL)hasSend hasNav:(BOOL)hasNav;


-(void)textViewResign;

@property (nonatomic, copy) void (^ReturnSendMessageBtn)(NSString *Str);

@end
