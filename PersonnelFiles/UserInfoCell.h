//
//  UserInfoCell.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/20.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerSonelVC.h"
#import "MainNavModel.h"
@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *userReply;

@property (nonatomic, copy) void (^PushToPersonVC)(NSInteger indexRow);


@property(nonatomic)NSInteger indexRow;
@end
