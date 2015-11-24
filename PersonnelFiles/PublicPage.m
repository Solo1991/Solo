//
//  PublicPage.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/4.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "PublicPage.h"
#import "MainTableVIewCell.h"
#import "MainNavModel.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+MJRefresh.h"

#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "LoadData.h"
#import "UserInfoVC.h"
#import "LoginTool.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "AdWebViewVC.h"
#import "shareModel.h"
#import "CommentPage.h"

static NSString *cellId = @"MainTableVIewCell";
@interface PublicPage()<UITableViewDelegate,UITableViewDataSource>
{
    int             pages;
    shareModel      *shareModelData;
}
@property(nonatomic,strong)UIScrollView  *titleView;
@property(nonatomic,strong)NSString     *urlStr;
@end
@implementation PublicPage

- (void)awakeFromNib
{
    self.publicTableView.delegate    = self;
    self.publicTableView.dataSource  = self;
    self.publicTableView.rowHeight= 95;
    [self initRefreshControl];
 
}


-(shareModel*)returnShareModel
{
    MainNavModel *model = self.modelArray[self.shareIndex];
    
    UserDetailModel *detail  = model.detailModel;

    //要等加载数据后  再实现该方法。 否则获取不到数据
    shareModelData =[[shareModel alloc] initWithImgURL:model.userImg
                                                  With:[NSString stringWithFormat:@"http://www.rm520.cn/rmda/index/%@",detail.bdID]
                                                  With:[NSString stringWithFormat:@"%@ 的档案",detail.bdname]
                                                  With:[NSString stringWithFormat:@"我的职业是%@,今年%@,爱好是%@,我想%@"
                                                        ,detail.bdjob,
                                                        detail.bdage,
                                                        detail.bdhobby,
                                                        detail.bddo
                                                        ]];
    
    return shareModelData;
}

/**
 *  初始化下拉刷新控件
 */
-(void) initRefreshControl
{
    //初始化UIRefreshControl
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerEndRefreshing) name:@"headerEndRefreshing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(footerEndRefreshing) name:@"footerEndRefreshing" object:nil];
    [self.publicTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.publicTableView addFooterWithTarget:self action:@selector(addMoreData)];
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
     [self.publicTableView headerEndRefreshing];
}
-(void)footerEndRefreshing
{
        [self.publicTableView footerEndRefreshing];
}

-(void)reloadTableView
{
    if (!self.modelArray)
    {
        [self refreshData];
    }
    
    [self.publicTableView reloadData];
}

-(void)loadFirstAd
{
    [self createTitelView:@-1];
}

-(void)loadSecondAd
{
    [self createTitelView:@1];
}

/**
 *  创建广告
 */

-(void)createTitelView:(NSNumber*)count
{
    NSDictionary *type =@{
                          @"type" :count
                          };
    if (!self.titleView)
    {
        self.titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainWidth/5)];
        self.titleView.userInteractionEnabled = YES;
        self.titleView.pagingEnabled = YES;
       
    }

    LoadData *getTwoAdData = [LoadData LoadDatakWithUrl:@"/ads/get" WithDic:type withCount:19];
    getTwoAdData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *arr)
    {
        
        self.urlStrArr = [NSMutableArray array];
        if (!arr)
        {
            [quickMethod setSize: CGSizeMake(MainWidth, 0) with:self.titleView];
            self.publicTableView.tableHeaderView = self.titleView;
            return ;
        }
        
        [quickMethod setSize:CGSizeMake(MainWidth, MainWidth/5) with:self.titleView];
        self.titleView.contentSize              = CGSizeMake(MainWidth*arr.count, MainWidth/5);
        self.titleView.bounces                  = NO;
        self.publicTableView.tableHeaderView    = self.titleView;
        
        
        for (int count = 0; count < arr.count; count++)
        {
            /**
             创建每一个广告页面
             
             */
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth*count, 0, MainWidth, MainWidth/5)];
            [imageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToWebView)];
            [imageView addGestureRecognizer:tap];
            imageView.tag =count;
            [imageView sd_setImageWithURL:[NSURL URLWithString:arr[count][@"img"]]];
            [self.urlStrArr addObjectsFromArray:arr];
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(MainWidth-30, self.titleView.height - 10, 30, 10)];
            textLabel.textColor = [UIColor lightGrayColor];
            textLabel.text = [NSString stringWithFormat:@"%d / %d",count+1,arr.count];
            textLabel.font = [UIFont systemFontOfSize:10];
            [imageView addSubview:textLabel];
            [self.titleView addSubview:imageView];
        }
        
        
        if (self.timer == nil)
        {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(carsousel) userInfo:nil repeats:YES];
        }

    };

}

/**
 *   定时轮播回调函数
 */
-(void)carsousel
{
    if (offCount == self.urlStrArr.count)
    {
        offCount  = 0;
    }

    [self.titleView setContentOffset:CGPointMake(MainWidth * offCount,0) animated:YES];
    offCount++;
}


/**
 *  打开广告
 */
-(void)turnToWebView
{
    if (self.ReturnStrBlock)
    {
        int currentPage = self.titleView.contentOffset.x  / MainWidth;
        self.ReturnStrBlock(self.urlStrArr[currentPage][@"link"]);
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainNavModel *model = self.modelArray[indexPath.row];
    MainTableVIewCell * cell = [self.publicTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    /**
     *  点赞
     */
    cell.ReturnZanBtnBlock= ^(NSInteger indexRow)
    {
        
        NSDictionary * para = @{@"randId"   :[LoginTool returnRandId],
                                @"id" : model.mainNewID};
        LoadData *getZanData = [LoadData LoadDatakWithUrl:@"/usercollect/create" WithDic:para withCount:12];
        
        getZanData.ReturnStrBlock = ^(NSString *Str)
        {
            
        };

    };
    
    /**
     *  评论
     */
    cell.ReturnMessageBtnBlock= ^(NSInteger indexRow)
    {
        MainNavModel *model = self.modelArray[indexPath.row];
        self.PushToNewVCBlock(model.detailModel,model.username,model.userImg,model.userGender);
    };
    
    /**
     *  分享
     */
    cell.ReturnShareBtnBlock= ^(NSInteger indexRow)
    {
        self.shareIndex = indexRow;
        [[AppDelegate sharedInstance] shareActionWithShareModel:[self returnShareModel] With:self];
    };
    
    /**
     *  处理头像点击事件
     */
    cell.ReturnHeadBtnBlock = ^(NSInteger indexRow)
    {
        MainNavModel *model = self.modelArray[indexRow];
        PerSonelVC *personVC = [[PerSonelVC alloc] init];
        personVC.userGenderText = model.userGender;
        self.PushToPersonVC(model,personVC);
        
    };
    
    /**
     *  删除个人资料
     */
    cell.ReturnremoveBtnBlock = ^(NSInteger indexRow,NSInteger indexPath)
    {
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"确定删除详情？"
                                                        contentText:@"删除后不能恢复哦~~亲~"
                                                    leftButtonTitle:@"取消"
                                                   rightButtonTitle:@"确定"];
            [alert show];
            alert.leftBlock = ^()
            {
            
            };
                alert.rightBlock = ^()
                {
                
                        MainNavModel *model = self.modelArray[indexRow];
#pragma 删除个人发布
                        if (indexPath == 0)
                        {
                            
                            [[AppDelegate sharedInstance] showTextDialog:@"删除中..."];
                            NSDictionary *para = @{
                                                   @"id"    :model.mainNewID,
                                                   @"randId":[LoginTool returnRandId],
                                                   @"type"  :@"0"
                                                   };
                
                            LoadData *delePubData = [LoadData LoadDatakWithUrl:@"/usercomment/delete" WithDic:para withCount:15];
                            delePubData.ReturnCodeBlock = ^(NSNumber *callBack)
                            {
                                if ([callBack intValue]==1)
                                {
                                    
                                    [self.modelArray removeObjectAtIndex:indexRow];
                                    [self.publicTableView reloadData];
                                    [[AppDelegate sharedInstance] ShowAlert:@"删除动态成功"];
                                }else
                                {
                                    [[AppDelegate sharedInstance] ShowAlert:@"删除动态失败"];
                                }
                            };
                        }else if (indexPath == 1)
                        {
#pragma 删除点赞
                            [[AppDelegate sharedInstance] showTextDialog:@"删除中..."];
                            NSDictionary *para = @{
                                                   @"id"    :model.mainNewID,
                                                   @"randId":[LoginTool returnRandId]
                                                   };
                
                            LoadData *delePubData = [LoadData LoadDatakWithUrl:@"/usercollect/delete" WithDic:para withCount:15];
                            delePubData.ReturnCodeBlock = ^(NSNumber *callBack)
                            {
                                if ([callBack intValue]==1)
                                {
                                    [self.modelArray removeObjectAtIndex:indexRow];
                                    [self.publicTableView reloadData];
                                    [[AppDelegate sharedInstance] ShowAlert:@"取消点赞成功"];
                                }else
                                {
                                    [[AppDelegate sharedInstance] ShowAlert:@"取消点赞失败"];
                                }
                            };
                
                        }
                
                };
            alert.dismissBlock = ^()
        {
            
            
        };
        


    };
    
    
    /**
     *  复制微信信息
     */
    __weak PublicPage *myPublicPage = self;
    cell.ReturnCopyWeChatBlock = ^(NSInteger indexRow)
    {
        MainNavModel *model = self.modelArray[indexRow];
        
        if (myPublicPage.ReturnCopyWeChatBlock)
        {
            myPublicPage.ReturnCopyWeChatBlock(model.weChat);
        }
  
    };
    
    /**
     *   刷新档案
     */
    cell.ReturnUpDateBtnBlock =^(NSInteger indexRow)
    {
        MainNavModel *model = self.modelArray[indexRow];
        
        NSDictionary *para = @{
                               @"randId" :[LoginTool returnRandId],
                               @"id"     :model.mainNewID
                               };
        
        LoadData *delePubData = [LoadData LoadDatakWithUrl:@"/usercomment/refreshtoup" WithDic:para withCount:31];

        delePubData.ReturnStrBlock = ^(NSString *str)
        {
            [[AppDelegate sharedInstance] ShowAlert:str];
        };
    };
    

    cell.model = model;
    cell.indexRow = indexPath.row;
    cell.indexPath = self.indexPath;
    
    cell.isOpenUserInteraction =self.isOpenUserInteraction;
    cell.isCanBeHit = self.isCanBeHit;
    cell.isShowHideBtn = self.isShowHideBtn;
//    NSLog(self.isOpenUserInteraction ? @"MainTableVIewCell.h isOpenUserInteraction Yes" : @"MainTableVIewCell.h isOpenUserInteraction No");

    return cell;
}



#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MainNavModel *model = self.modelArray[indexPath.row];
    self.PushToNewVCBlock(model.detailModel,model.username,model.userImg,model.userGender);
    
}
@end
