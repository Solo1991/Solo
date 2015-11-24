//
//  LoginViewController.h
//  PersonnelFiles
//
//  Created by 麦兜 on 15/7/28.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txt_name;
@property (strong, nonatomic) IBOutlet UITextField *txt_psd;
@property (weak, nonatomic) IBOutlet UILabel *NavTitleItem;

@end
