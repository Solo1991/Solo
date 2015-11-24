//
//  PublicPage.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/4.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavModel.h"
#import "PerSonelVC.h"
#import "UserDetailModel.h"

@interface PublicPage : UICollectionViewCell
{
    int offCount;
}

@property (weak, nonatomic) IBOutlet UITableView *publicTableView;

@property(nonatomic,strong)NSMutableArray *modelArray;

@property(nonatomic,copy) void (^ReturnStrBlock)(NSString *urlStr);

@property (nonatomic, copy) void (^ReturnTextBlock)(int count);

@property (nonatomic, copy) void (^PushToNewVCBlock)(UserDetailModel* model,NSString *userName,NSString*userIma,NSNumber*sex);

@property (nonatomic, copy) void (^PushToPersonVC)(MainNavModel*model, PerSonelVC *personVC);

@property (nonatomic, copy) void (^MakeTitleView)(MainNavModel*model, PerSonelVC *personVC);

@property(nonatomic,copy) void (^ReturnCopyWeChatBlock)(NSString *urlStr);


-(void)reloadTableView;
-(void)refreshData;
-(void)addMoreData;

-(void)loadFirstAd;
-(void)loadSecondAd;
-(void)headerEndRefreshing;
-(void)footerEndRefreshing;

@property(nonatomic)BOOL isOpenUserInteraction;

@property(nonatomic)BOOL isCanBeHit;

@property (nonatomic, copy) void (^ReturnIsOpenUserInteractionBlock)(BOOL isOpenUserInteraction);

@property(nonatomic) NSInteger indexPath;

/**
 *  定时器
 */
@property (strong, nonatomic) NSTimer * timer;

/**
 *  当前的pageControl
 */
@property (strong, nonatomic)  UIPageControl *pageControl;

/**
 *  模拟测试数组
 */
@property(nonatomic,strong)NSMutableArray *userImageArr;


@property(nonatomic)NSInteger shareIndex;

@property(nonatomic,strong)NSMutableArray *urlStrArr;

@property(nonatomic)BOOL isShowHideBtn;
@end

