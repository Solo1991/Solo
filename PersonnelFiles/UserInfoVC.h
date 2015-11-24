//
//  UserInfoVC.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/18.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailModel.h"
#import "quickMethod.h"
#import "WXApi.h"
#import "CUSFlashLabel.h"
#import "AAShareBubbles.h"
#import "ReportVC.h"
#import "FBShimmering/FBShimmeringView.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "ZHPickView.h"




@interface UserInfoVC : UIViewController<AAShareBubblesDelegate>
{
    FBShimmeringView *_shimmeringView;
    AAShareBubbles *shareBubbles;
    float radius;
    float bubbleRadius;
    int  offCount;
}




@property(strong,nonatomic)UIButton     *coverView;
@property(strong,nonatomic)UserDetailModel *model;
@property(strong,nonatomic)NSString* IuserName;
@property(strong,nonatomic)NSString* IuserImg;
@property(strong,nonatomic)NSString* IuserSex;
@property(strong,nonatomic)NSString*detailImg;
@property(nonatomic,strong)UIButton *buildFileBtn;



@property(nonatomic,strong)UIImageView* oneImageView;
@property(nonatomic,strong)UIImageView* twoImageView;
@property(nonatomic,strong)UIImageView* threeImageView;
@property(nonatomic,strong)UIImageView* fourImageView;

@property(nonatomic,strong)NSMutableArray *userImageArr;


@property(nonatomic,strong)UIImageView *chatImage;

/**
 *  页数
 */
@property(nonatomic)int pages;




@property(nonatomic)int countReply;



@property(nonatomic,strong)NSMutableArray *urlStrArr;

@property(nonatomic,strong)UIScrollView * adView;


/**
 *  定时器
 */
@property (strong, nonatomic) NSTimer * timer;
@end
