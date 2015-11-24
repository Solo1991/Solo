//
//  ModifyUserInfoVC.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/20.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "postPic.h"
#import "PerSonelVC.h"
@interface ModifyUserInfoVC : UIViewController
@property(nonatomic,strong)NSNumber *sexNumber;
@property (weak, nonatomic) IBOutlet UIButton *selectSexBtn;
@property(nonatomic,strong)PerSonelVC *perSonVC;
@end
