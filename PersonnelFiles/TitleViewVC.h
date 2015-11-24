//
//  TitleViewVC.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/21.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleViewVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *genterImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *idoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *idoLabel;
@property (weak, nonatomic) IBOutlet UILabel *hobbyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hobbyLabel;
@property (weak, nonatomic) IBOutlet UILabel *hopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;


@property (weak, nonatomic) IBOutlet UILabel *beFriendLabel;

@property (weak, nonatomic) IBOutlet UILabel *visitLabel;
@property(assign,nonatomic)CGFloat viewHeight;//页面高度
@property(nonatomic,strong)NSString *str;
@end
