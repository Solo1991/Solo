//
//  PerSonelVC.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavModel.h"
#import "CommentPage.h"
@interface PerSonelVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIImageView *userGender;

@property (weak, nonatomic) IBOutlet UICollectionView *personCollectionVIew;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIView *footTwoView;
@property(strong,nonatomic)UIButton     *coverView;

@property (weak, nonatomic) IBOutlet UIButton *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property(nonatomic,strong)NSURL *headImageUrl;
@property(nonatomic,strong)NSString *name;
@property(strong,nonatomic)NSString *randId;


@property(strong,nonatomic)NSNumber *userGenderText;


@property(nonatomic,strong)MainNavModel *model;
@property(nonatomic)BOOL isOpenUserInteraction;



@property(nonatomic,strong)NSString *sex;

@end
