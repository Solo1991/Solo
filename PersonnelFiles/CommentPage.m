//
//  CommentPage.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/27.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "CommentPage.h"


#import "MainTableVIewCell.h"
#import "MainNavModel.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "LoadData.h"
#import "UserInfoVC.h"
#import "LoginTool.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "AdWebViewVC.h"
#import "shareModel.h"
@interface CommentPage()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    int pages;
    MBProgressHUD *HUD;
    shareModel *shareModelData;
}
@property(nonatomic,strong)UIImageView  *titleView;
@property(nonatomic,strong)NSString     *urlStr;
@end
@implementation CommentPage

- (void)awakeFromNib
{
    
    self.commentPage.delegate    = self;
    self.commentPage.dataSource  = self;
    self.commentPage.rowHeight   = 80;
    [self initRefreshControl];
    
    
    
    //要等加载数据后  再实现该方法。 否则获取不到数据
    shareModelData =[[shareModel alloc] initWithImgURL:@"http://baike.baidu.com/picture/590814/590814/16943870/f11f3a292df5e0fe23ae6649586034a85fdf72c0.html?fr=lemma&ct=cover#aid=16943873&pic=0823dd54564e9258b2c38d629f82d158cdbf4e42"
                                                  With:@"http://southpeak.github.io/blog/2015/03/07/uiresponder/"
                                                  With:@"人脉档案"
                                                  With:@"某某某"];
    
}

/**
 *  初始化下拉刷新控件
 */
-(void) initRefreshControl
{
    //初始化UIRefreshControl
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerEndRefreshing) name:@"headerEndRefreshing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(footerEndRefreshing) name:@"footerEndRefreshing" object:nil];
    [self.commentPage addHeaderWithTarget:self action:@selector(refreshData)];
    [self.commentPage addFooterWithTarget:self action:@selector(addMoreData)];
}

/**
 *  下拉回调函数，开始刷新数据
 */
-(void)refreshData
{
    pages = 1;
    
    if (self.ReturnTextBlock)
    {
        self.ReturnTextBlock(pages);
        
    }
    
}



/**
 *  上拉加载更多数据
 */
-(void)addMoreData
{
    ++pages;
    if (self.ReturnTextBlock)
    {
        self.ReturnTextBlock(pages);
        
    }
}

-(void)headerEndRefreshing
{
    [self.commentPage headerEndRefreshing];
}
-(void)footerEndRefreshing
{
    [self.commentPage footerEndRefreshing];
}

-(void)reloadComTableView
{
    if (!self.modelArray)
    {
        [self refreshData];
    }
    
    [self.commentPage reloadData];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserInfoCell * cell = [self.commentPage dequeueReusableCellWithIdentifier:commentCellID];
    CommentModel *model = self.modelArray[indexPath.row];
    
    
    if (!cell)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:commentCellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    NSLog(@"userfromName = %@",model.userFromName);
    cell.userName.text = model.userFromName;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.userFromImg]];
    cell.userReply.text = [NSString stringWithFormat:@"评论了你:%@",model.body];
    cell.userTime.text = [quickMethod quickGetTimeFormWith:[quickMethod transformTimeToString:model.createdAt]];
    return cell;
}


#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *model = self.modelArray[indexPath.row];
    if (self.PushToNewVCBlock)
    {
        self.PushToNewVCBlock(model.parentId);
    }
}


@end
