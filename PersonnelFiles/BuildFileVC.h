//
//  BuildFileVC.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/6.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AlartViewController.h"
#import "ZHPickView.h"
@interface BuildFileVC : UIViewController<ExpendableAlartViewDelegate,ZHPickViewDelegate>
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSNumber *sexNumber;
@end
