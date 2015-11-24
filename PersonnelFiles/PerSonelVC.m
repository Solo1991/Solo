//
//  PerSonelVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "PerSonelVC.h"
#import "PublicPage.h"
#import "BuildFileVC.h"
#import "FeedBackVC.h"
#import "UserInfoVC.h"
#import "ModifyUserInfoVC.h"
#import "LoadData.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "LoginTool.h"
#import "quickMethod.h"
@interface PerSonelVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
{
    NSInteger lastIndex;
    CGAffineTransform transform;
    UIImageView *headImgView;
}

@property (weak, nonatomic) IBOutlet UIButton *publish;
@property (weak, nonatomic) IBOutlet UIButton *praise;
@property (weak, nonatomic) IBOutlet UIButton *message;
@property (weak, nonatomic) IBOutlet UILabel *selectLab;


@property(nonatomic,strong)NSMutableArray *modelPublicArray;
@property(nonatomic,strong)NSMutableArray *modelZanArray;
@property(nonatomic,strong)NSMutableArray *modelMessageArray;
@end

@implementation PerSonelVC

- (IBAction)wouldPublishBtn:(id)sender
{
    BuildFileVC *buildFileVC = [[BuildFileVC alloc] init];
    [self.navigationController pushViewController:buildFileVC animated:YES];
    
}


/**
 *  登陆
 *
 */
-(UIButton *)coverView
{
    
    if (!_coverView)
    {
        _coverView = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, MainWidth, MainHeight)];
        _coverView.backgroundColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:0.85];
        [_coverView addTarget:self action:@selector(touchCover) forControlEvents:UIControlEventTouchUpInside];

        [self.view.window addSubview:_coverView];    
    }
    
    return _coverView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    self.navigationItem.backBarButtonItem =  [UIBarButtonItem setUIBarButtonItem];

    
    /**
     *  等待加载动画
     */
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
//    lab.text = @"个人中心";
//    lab.textColor = [UIColor whiteColor];
//    lab.font = [UIFont systemFontOfSize:24];
//    lab.textAlignment = UITextAlignmentCenter;
//    
//    UIView *titleView = [[UIView alloc] init];
//    [titleView addSubview:lab];
//    [quickMethod setSize:CGSizeMake(80, 44) with:titleView];
//    self.navigationItem.titleView = titleView;
//    [titleView addSubview:[customActivityIndicator returnActivityIndicator]];
    

    

    
    [quickMethod doCornerRadiusWith:self.buttonView WithRadius:0 WithBorderWidth:0.5 WithColor:[UIColor lightGrayColor]];
    
    /**
     *  设置姓名
     */
    self.userName.text = self.name;

    /**
     *  设置头像
     */
    [self setHeadImage];

    /**
     *  设置性别
     */
    if ([self.userGenderText  isEqual: @1])
    {
        self.userGender.image = [UIImage imageNamed:@"性别-男.png"];
        self.sex = @"他";
       
//        NSLog(@"男生");
    }else if([self.userGenderText isEqual:@-1])
    {
        self.userGender.image = [UIImage imageNamed:@"性别-女.png"];
        self.sex = @"她";
    }else
    {
        self.userGender.image = [UIImage imageNamed:@"boyAndGirl.png"];
        self.sex = @"他/她";
    }
    
    /**
     *  底部是否显示为微信
     */
    [self.footView setHidden:!self.isOpenUserInteraction];
    if (!self.isOpenUserInteraction)
    {
        
        UIView * weChatView = [[UIView alloc] initWithFrame:CGRectMake(MainWidth/2-100, 5, 200, 40)];
        weChatView.backgroundColor = [UIColor clearColor];
        [self.footTwoView addSubview:weChatView];
        
        UIImageView *chatImage = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 34, 34)];
        chatImage.image = [UIImage imageNamed:@"微信小图标.png"];
        chatImage.backgroundColor = [UIColor whiteColor];
        [quickMethod doCornerRadiusWith:chatImage WithRadius:5 WithBorderWidth:1 WithColor:[UIColor whiteColor]];
        [weChatView addSubview:chatImage];
       
        [weChatView addSubview:[CUSFlashLabel setCUSFlashLabel:[NSString stringWithFormat:@"点击加%@微信号",self.sex]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyChat)];
        [self.footTwoView addGestureRecognizer:tap];
    }
    
    
    
    
    [self.personCollectionVIew registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
          forCellWithReuseIdentifier:CellIdentifier];
    
    [self.personCollectionVIew registerNib:[UINib nibWithNibName:@"CommentPage" bundle:nil]
                forCellWithReuseIdentifier:@"CommentPage"];
    
    
    UICollectionViewFlowLayout *layout = (id) self.personCollectionVIew.collectionViewLayout;
    
    CGFloat personCollectionVIewHeight = MainHeight - self.headView.height - self.buttonView.height - self.footView.height -MainNavHeight;
    layout.itemSize = CGSizeMake(MainWidth,personCollectionVIewHeight);
    self.personCollectionVIew.delegate   = self;
    self.personCollectionVIew.dataSource = self;
    
    [self btnIsSelected:YES with:NO with:NO];
}


-(void)setHeadImage
{
    
    [_userImage.layer setCornerRadius:39];
    [_userImage.layer setBorderColor:(__bridge CGColorRef)([UIColor whiteColor])];
    [_userImage.layer setBorderWidth:1.0];
    [_userImage.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLogoutOrModification)];
    [_userImage addGestureRecognizer:tap];
   
    
//    NSLog(self.isOpenUserInteraction ? @"MainTableVIewCell.h isOpenUserInteraction Yes" : @"MainTableVIewCell.h isOpenUserInteraction No");
    [_userImage sd_setImageWithURL:self.headImageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];
    [_userImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

/**
 *  判断是否登录
 */
-(void)selectLogoutOrModification
{
    /**
     *  如果是自己的个人中心
     */
    if (self.isOpenUserInteraction)
    {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"修改用户信息",@"注销登陆", nil];
        
        sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [sheet showInView:self.view];
    
        
    }else
    {
        /**
         *  如果是别人的个人中心
         */
        [UIView animateWithDuration:0.5 animations:^
        {
            self.coverView.hidden = NO;
//            [self.coverView.imageView setContentMode:UIViewContentModeScaleAspectFit];
            headImgView = [[UIImageView alloc]init];
            headImgView.frame = CGRectMake(0, 0, MainWidth, MainWidth );
            headImgView.image = [UIImage imageNamed:@"个人中心-头像.png"];
            
            SDWebImageManager * manager = [SDWebImageManager new];
            [manager downloadImageWithURL:self.headImageUrl options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if(error)
                {
                    NSLog(@"error ======%@",error);
                }else
                {
                    NSLog(@"%f=====%f",image.size.width,image.size.height);
                    float d = image.size.height/image.size.width;
                    headImgView.frame = CGRectMake(0, 0, MainWidth, MainWidth * d);
                    headImgView.center = self.view.window.center;
                    headImgView.image = image;
                }
                
                
            }];
            [self.coverView addSubview:headImgView];
            
            
        }completion:^(BOOL finished){
        }];


    }
//    [headImgView sd_setImageWithURL:self.headImageUrl placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];

}


-(void)touchCover
{
    [UIView animateWithDuration:0.5 animations:^
    {
        self.coverView.hidden = YES;
        [headImgView removeFromSuperview];
        
    }completion:^(BOOL finished){
    }];
    
}

/**
 *  复制微信
 */
-(void)copyChat
{
    [quickMethod copyWechat:self.model.weChat];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            
            [self pushToUserInfoVC];
            break;
            // 更换账号
        case 1:
            [self layout];
            
            break;
 
    }
}

-(void)layout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"randId"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


/**
 *  进入修改档案界面
 */
-(void)pushToUserInfoVC
{
    ModifyUserInfoVC *info = [[ModifyUserInfoVC alloc] init];
    info.perSonVC = self;
    [self.navigationController pushViewController:info animated:YES];
}



- (IBAction)publishBtn:(id)sender
{
    [self btnIsSelected:YES with:NO with:NO];
    [self judgeStatusWith:0];
}

- (IBAction)praiseBtn:(id)sender
{
    [self btnIsSelected:NO with:YES with:NO];
    [self judgeStatusWith:1];
}

- (IBAction)messageBtn:(id)sender
{
    [self btnIsSelected:NO with:NO with:YES];
    [self judgeStatusWith:2];
}

-(void)btnIsSelected:(BOOL)isPublish with:(BOOL)isPraise with:(BOOL)isMessage
{
    [self.publish setSelected:isPublish];
    [self.praise  setSelected:isPraise];
    [self.message setSelected:isMessage];
    
}
#pragma mark 打开点击事件
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark 设置分区

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}
#pragma mark 每个区内的元素个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 3;
}
#pragma mark 设置元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0)
    {
        PublicPage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.modelArray = self.modelPublicArray;
        cell.ReturnTextBlock= ^(int pages)
        {
            [customActivityIndicator startAnimating];
            
            NSDictionary * para = @{@"userId"   :self.randId,
                                    @"page" : [NSString stringWithFormat:@"%d",pages],
                                    @"pageSize"  : @"10" };
            
            LoadData *getProData = [LoadData LoadDatakWithUrl:@"/usercomment/get" WithDic:para withCount:3];
            getProData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *array)
            {
                
                if (pages==1)
                {
                    self.modelPublicArray = array;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                }else{
                    [self.modelPublicArray addObjectsFromArray:array];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
                }
                
                [self.personCollectionVIew reloadData];
                [customActivityIndicator stopAnimating];
                
            };
            getProData.ReturnErrorBlock =^(NSString *callBack)
            {
                [[AppDelegate sharedInstance] ShowAlert:STR(@"网络不给力！！")];
                [[AppDelegate sharedInstance] setHUDHide];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
            };
            

        };
        cell.ReturnCopyWeChatBlock = ^(NSString *weChat)
        {
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = weChat;
            
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"已成功复制"
                                                        contentText:@"是否添加为微信好友？"
                                                    leftButtonTitle:@"拂袖而去"
                                                   rightButtonTitle:@"打开看看"];
            [alert show];
            
            alert.leftBlock = ^()
            {
            };
            alert.rightBlock = ^()
            {
                [WXApi openWXApp];
            };
            alert.dismissBlock = ^()
            {
            };
        };
        
        /**
         *  跳转详情
         */
        cell.PushToNewVCBlock = ^(UserDetailModel* model,NSString *userName,NSString*userIma,NSNumber*sex)
        {
            UserInfoVC *info = [[UserInfoVC alloc] init];
            info.model = model;
            info.IuserImg  = userIma;
            info.IuserName = userName;
            info.IuserSex  = [NSString stringWithFormat:@"%@",sex];
            [self.navigationController pushViewController:info animated:YES];
        };
        cell.indexPath = 0;
        cell.isOpenUserInteraction = self.isOpenUserInteraction;
        cell.isCanBeHit = NO;
        
        /**
         *  显示置顶按钮
         */
        cell.isShowHideBtn = YES;
        [cell reloadTableView];
        return cell;
        
    }else if(indexPath.row ==1)
    {
        
      PublicPage*  cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.isOpenUserInteraction = self.isOpenUserInteraction;
        cell.modelArray = self.modelZanArray;
        cell.ReturnTextBlock= ^(int pages)
        {
            [customActivityIndicator startAnimating];
            
            NSDictionary * para = @{@"randId"   :self.randId,
                                    @"page"     : [NSString stringWithFormat:@"%d",pages],
                                    @"pageSize"  : @"10" };
            LoadData *getNewData = [LoadData LoadDatakWithUrl:@"/usercollect/get" WithDic:para withCount:3];
            getNewData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *array)
            {
          
                if (pages==1)
                {
                    self.modelZanArray = array;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                }else
                {
                    [self.modelZanArray addObjectsFromArray:array];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
                }
                
                [self.personCollectionVIew reloadData];
                [customActivityIndicator stopAnimating];
            };
            
            getNewData.ReturnErrorBlock =^(NSString *callBack)
            {
                [[AppDelegate sharedInstance] ShowAlert:STR(@"网络不给力！！")];
                [[AppDelegate sharedInstance] setHUDHide];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
            };
        };

        /**
         *  跳转详情
         */
        cell.PushToNewVCBlock = ^(UserDetailModel* model,NSString *userName,NSString*userIma,NSNumber*sex)
        {
            UserInfoVC *info = [[UserInfoVC alloc] init];
            info.model = model;
            info.IuserImg  = userIma;
            info.IuserName = userName;
            info.IuserSex  = [NSString stringWithFormat:@"%@",sex];

            [self.navigationController pushViewController:info animated:YES];
        };
        cell.isCanBeHit = NO;
        cell.indexPath = 1;
        [cell reloadTableView];
        return cell;
        
    }else
    {
      
      CommentPage*  cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentPage" forIndexPath:indexPath];
 
        cell.modelArray = self.modelMessageArray;
        cell.ReturnTextBlock= ^(int pages)
        {
            [customActivityIndicator startAnimating];
            
            NSDictionary * para = @{@"randId"       :   self.randId,
                                    @"page"         :   [NSString stringWithFormat:@"%d",pages],
                                    @"pageSize"     :   @"10" };
            
            LoadData *getNewData = [LoadData LoadDatakWithUrl:@"/userreply" WithDic:para withCount:4];
            getNewData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *array)
            {
                
                if (pages==1)
                {
                    self.modelMessageArray = array;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                }else
                {
                    [self.modelMessageArray addObjectsFromArray:array];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
                }
                
                [self.personCollectionVIew reloadData];
                [customActivityIndicator stopAnimating];
            };
        };
        
        cell.PushToNewVCBlock = ^(NSNumber *bdID)
        {
            [[AppDelegate sharedInstance] ShowAlert:@"正在加载..."];
            NSDictionary * para = @{@"id"       :bdID};
            
            LoadData *getNewData = [LoadData LoadDatakWithUrl:@"/usercomment/all" WithDic:para withCount:14];
            
            getNewData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *arr)
            {
                [[AppDelegate sharedInstance] ShowAlert:@"加载成功"];
                MainNavModel *model = arr[0];
                UserInfoVC *info = [[UserInfoVC alloc] init];
                UserDetailModel *infoModel = model.detailModel;
                info.model      = infoModel;
                info.IuserImg   = model.userImg;
                info.IuserName  = model.username;
                info.IuserSex   = [NSString stringWithFormat:@"%@",model.userGender];
                
                [self.navigationController pushViewController:info animated:YES];
            };
            
        };
        [cell reloadComTableView];
        return cell;
        
    }
    
    
    return nil;

}
- (IBAction)feedBackBtn:(id)sender
{
    
    FeedBackVC *feedBackVC = [[FeedBackVC alloc] init];
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

-(void)judgeStatusWith:(NSInteger)index
{
    if(index==lastIndex)
    {
        return;
    }
    
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:index inSection:0];
    
    //滚动到选择的item
    [self.personCollectionVIew selectItemAtIndexPath:indexpath
                                      animated:YES
                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

    
    [UIView animateWithDuration:0.5 animations:^
    {
        if (index<=0)
        {
            [self btnIsSelected:YES with:NO with:NO];
            transform = CGAffineTransformIdentity;
            self.selectLab.transform = transform;
        }else if(index ==1)
        {
            [self btnIsSelected:NO with:YES with:NO];
            float transformDistance = MainWidth/3;
            
            if(IOS_VERSION<8.0)
            {
                transformDistance   = transformDistance *2;
            }
            
            transform= CGAffineTransformMakeTranslation(transformDistance, 0.0);//位移
            self.selectLab.transform = transform;
        }else if (index ==2)
        {
            [self btnIsSelected:NO with:NO with:YES];
            float  transformDistance = MainWidth/3*2;
            if(IOS_VERSION<8.0)
            {
                transformDistance   = transformDistance *2;
            }
            transform= CGAffineTransformMakeTranslation(transformDistance, 0.0);//位移
            self.selectLab.transform = transform;
        }
    }completion:^(BOOL finished)
    {
    }];
    lastIndex = index;
    [self.personCollectionVIew reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!canMove)
    {
        return;
    }
    int index=(scrollView.contentOffset.x/MainWidth+0.5);
    [self judgeStatusWith:index];
}


static BOOL canMove = NO;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    canMove=YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    canMove=NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
