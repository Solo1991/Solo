//
//  MainSearchVC.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/27.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCityViewController.h"
#import "MainNavModel.h"
#import "MainTableVIewCell.h"
#import "LoadData.h"
#import "LoginTool.h"
#import "AppDelegate.h"
#import "PerSonelVC.h"
#import "shareModel.h"
#import "quickMethod.h"
#import "UIImageView+WebCache.h"
#import "UserInfoVC.h"
#import "MainSearchBar.h"
#import "HotWordsView.h"

@interface MainSearchVC : UIViewController<MainSearchBarDelegate,HotWordsViewDelegate>
@property(nonatomic,strong)NSMutableArray *modelArray;

@property (nonatomic, copy) void (^PushToNewVCBlock)(UserDetailModel* model,NSString *userName,NSString*userIma,NSNumber*sex);

@property (nonatomic, copy) void (^PushToPersonVC)(MainNavModel*model, PerSonelVC *personVC);

@property(nonatomic,copy) void (^ReturnCopyWeChatBlock)(NSString *urlStr);


@property(nonatomic,strong)NSNumber * sexNumber;
@property(nonatomic,strong)NSString * cityName;
@property(nonatomic,strong)NSString * ageGroup;
@property(nonatomic,strong)UILabel  *selectAgeLabel;
@property(nonatomic)BOOL isOpenUserInteraction;

@property(nonatomic,strong)MainSearchBar *mainSearchBarSet;
/**
 *  是否搜索
 */
@property(nonatomic)BOOL isSearch;

@property(nonatomic)int pages;

@property(nonatomic,strong)NSString *searchStr;


@property(nonatomic)NSInteger shareIndex;

@property(strong,nonatomic)UIButton     *ageBtn;


@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) IBOutlet UIView *pickerBgView;

@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;


//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSMutableArray *fromArray;
@property (strong, nonatomic) NSMutableArray *toArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@end
