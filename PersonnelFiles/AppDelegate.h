//
//  AppDelegate.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shareModel.h"
#import "APService.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+(AppDelegate*) sharedInstance;
- (void)shareActionWithShareModel:(shareModel*)model With:(UIViewController*)parentVC;



-(void)alert:(NSString*)data ;
-(void)alert:(NSString*)title andData:(NSString*)data andDelegate:(id)object;
-(void)ShowAlert:(NSString*)data ;

-(void)ShowAlertWith:(UIView*)view;
- (void)showTextDialog:(NSString*) text ;

-(void)removeHUD;
-(void)setHUDHide;

- (void)showResultTextDialog:(NSString*)text withImageName:(NSString*)picture ;
@end

