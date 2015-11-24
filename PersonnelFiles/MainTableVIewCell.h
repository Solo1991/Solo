//
//  MainTableVIewCell.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavModel.h"
@class MainTableVIewCell;
@protocol MainTableVIewCellDelegate

-(void)beOnClick:(MainTableVIewCell*) cell;
@end

@interface MainTableVIewCell : UITableViewCell

@property(assign,nonatomic)id<MainTableVIewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *userGender;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *iWant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iWantWidthToSuperView;//label距离遍框宽度，默认为10，如果显示删除按钮，宽度设置为65

@property (weak, nonatomic) IBOutlet UIButton *zan;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property(nonatomic)BOOL isOpenUserInteraction;

@property (nonatomic, copy) void (^ReturnCopyWeChatBlock)(NSInteger indexRow);
@property (nonatomic, copy) void (^ReturnZanBtnBlock)(NSInteger count);
@property (nonatomic, copy) void (^ReturnMessageBtnBlock)(NSInteger count);
@property (nonatomic, copy) void (^ReturnShareBtnBlock)(NSInteger count);
@property (nonatomic, copy) void (^ReturnHeadBtnBlock)(NSInteger count);

@property (nonatomic, copy) void (^ReturnIsOpenUserInteractionBlock)(BOOL isOpenUserInteraction);

@property(nonatomic,strong)UILabel *zanLabel;
@property(nonatomic,strong)UILabel *messageLabel;
@property(nonatomic,strong)UILabel *shareLabel;
@property (nonatomic)  NSInteger indexRow;

@property (weak, nonatomic) IBOutlet UIButton *weChatCopyBtn;


@property(nonatomic)BOOL isCanBeHit;


@property(nonatomic) NSInteger indexPath;
/**
 *  删除按钮
 */
@property (nonatomic, copy) void (^ReturnremoveBtnBlock)(NSInteger row,NSInteger path);



@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UIButton *upToBtn;
@property (nonatomic, copy) void (^ReturnUpDateBtnBlock)(NSInteger count);




@property(nonatomic,strong)MainNavModel *model;



@property(nonatomic)BOOL isShowHideBtn;
@end
