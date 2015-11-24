//
//  CommentPage.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/27.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "UserInfoCell.h"
#import "CommentModel.h"
@interface CommentPage : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UITableView *commentPage;


@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,copy) void (^ReturnStrBlock)(NSString *urlStr);

@property (nonatomic, copy) void (^ReturnTextBlock)(int count);

@property (nonatomic, copy) void (^PushToNewVCBlock)(NSNumber * bdID);

@property(nonatomic,copy) void (^ReturnCopyWeChatBlock)(NSString *urlStr);
-(void)reloadComTableView;
-(void)refreshData;
-(void)addMoreData;


-(void)headerEndRefreshing;
-(void)footerEndRefreshing;
@property(nonatomic)BOOL isOpenUserInteraction;
@property (nonatomic, copy) void (^ReturnIsOpenUserInteractionBlock)(BOOL isOpenUserInteraction);
@end
