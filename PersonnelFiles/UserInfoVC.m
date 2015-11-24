//
//  UserInfoVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/18.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "UserInfoVC.h"
#import "LoadData.h"
#import "UIImageView+WebCache.h"
#import "UserInfoCell.h"
#import "CommentModel.h"
#import "inputView.h"
#import "TitleViewVC.h"
#import "LoginTool.h"
#import "AppDelegate.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
static NSString * UserInfoCellID = @"UserInfoCell";
@interface UserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    inputView   * myInputView;
    shareModel  * shareModelData;
    NSUInteger    imageArrCount;
    CGSize maxSize;
    CGSize hopeLabelSize;
    CGSize hobbyLabelSize;
    CGSize idoLabelSize;
    UIImageView *headImgView;
 

}


@property(nonatomic,strong)UIView *putImageView;
@property(nonatomic,strong)UIView *putButtonView;


@property(nonatomic,strong)UIImageView *zanImage;
@property(nonatomic,strong)UIImageView *shareImage;

@property(nonatomic,strong)UILabel *zanLabel;
@property(nonatomic,strong)UILabel *shareLabel;

@property(nonatomic,strong)UITableView *commentTableView;

@property(nonatomic,strong)NSMutableArray *modelArray;





@property(nonatomic,strong)CommentModel *commentModel;
@property(nonatomic,strong)TitleViewVC *titleViewVC;
@property(nonatomic,strong)UIView *titleView;

@property(nonatomic,strong)UIView *buttonView;

@property(nonatomic,strong)NSNumber *userToID;

@property(nonatomic,strong)UIScrollView *titleScrollView;
@end

@implementation UserInfoVC

-(UIView *)buttonView
{
    
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleViewVC.view.frame), MainWidth-20, 50)];
        _buttonView.userInteractionEnabled = YES;
        

        
        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainWidth-60, 17, 30, 20)];
        
        [_buttonView addSubview:commentBtn];
        UIImageView *commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,16, 16)];
        [commentImage setImage:[UIImage imageNamed:@"分享.png"]];
        [commentBtn addSubview:commentImage];
        [commentBtn addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];

    }
    return _buttonView;
}

-(void)addZan
{
    
    NSDictionary * para = @{@"randId"   :[LoginTool returnRandId],
                            @"id"       : self.model.bdID};
    LoadData *getZanData = [LoadData LoadDatakWithUrl:@"/usercollect/create" WithDic:para withCount:12];
    
    getZanData.ReturnStrBlock = ^(NSString *Str)
    {
        [[AppDelegate sharedInstance] ShowAlert:Str];
    };
}

-(void)touch_ShareAction
{

    if(shareBubbles)
    {
        shareBubbles = nil;
    }
    shareBubbles = [[AAShareBubbles alloc] initWithPoint:self.view.center radius:radius inView:self.view.window.rootViewController.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = bubbleRadius;
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showGooglePlusBubble = YES;
    shareBubbles.showTumblrBubble = YES;
    [shareBubbles show];
    
}

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    switch (bubbleType)
    {
            
        case AAShareBubbleTypeFacebook:
            
            [self pushToNewVC];
            break;
            
        case AAShareBubbleTypeTwitter:
            // 分享
            [[AppDelegate sharedInstance] shareActionWithShareModel:shareModelData With:self];
            break;
            
        case AAShareBubbleTypeGooglePlus:
            // 点赞
            if (![LoginTool returnName])
            {
                [[AppDelegate sharedInstance] ShowAlert:@"想点赞请先登录哦~~"];
                return;
            }

            [self addPraise];
            break;
            
            
        case AAShareBubbleTypeTumblr:
           
//            NSLog(@"Tumblr");
            break;
        default:
            break;
    }
}


//***************************************************************************//

-(void)pushToNewVC
{
    
    if (![LoginTool returnRandId])
    {
        [[AppDelegate sharedInstance] ShowAlert:@"要举报的话，请先登录哦~~"];
        return;
    }
    ReportVC *reportVC = [[ReportVC alloc] init];
    reportVC.berandId = self.model.randId;
    reportVC.beid     = self.model.bdID;
    [self.navigationController pushViewController:reportVC animated:YES];
}

-(void)addPraise
{
    NSDictionary * para = @{@"randId"   :[LoginTool returnRandId],
                            @"id" : self.model.bdID};
    LoadData *getZanData = [LoadData LoadDatakWithUrl:@"/usercollect/create" WithDic:para withCount:12];
    
    getZanData.ReturnCodeBlock = ^(NSNumber *count)
    {
        if ([count intValue] ==0)
        {
            [[AppDelegate sharedInstance] ShowAlert:@"你已经点赞过了~~"];
            return ;
        }
        [[AppDelegate sharedInstance] ShowAlert:@"点赞成功~~"];
    };
}
-(void)aaShareBubblesDidHide
{
//    NSLog(@"All Bubbles hidden");
}


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


-(void)showPhoto
{
    self.coverView.hidden =NO;
    [UIView animateWithDuration:0.5 animations:^
     {
         headImgView = [[UIImageView alloc]init];
         headImgView.frame = CGRectMake(0, 0, MainWidth, MainWidth );
         headImgView.image = [UIImage imageNamed:@"个人中心-头像.png"];
         
         SDWebImageManager * manager = [SDWebImageManager new];
         [manager downloadImageWithURL:[NSURL URLWithString:self.IuserImg] options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             if(error)
             {
                 NSLog(@"error ======%@",error);
             }else
             {
//                 NSLog(@"%f=====%f",image.size.width,image.size.height);
                 float d = image.size.height/image.size.width;
                 headImgView.frame = CGRectMake(0, 0, MainWidth, MainWidth * d);
                 headImgView.center = self.view.window.center;
                 headImgView.image = image;
             }
             
             
         }];
         [self.coverView addSubview:headImgView];
     }completion:^(BOOL finished){
     }];
    
//    [headImgView sd_setImageWithURL:[NSURL URLWithString:self.IuserImg] placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];
//    [headImgView setContentMode:UIViewContentModeScaleAspectFit];
    
//    [self.coverView setContentMode:UIViewContentModeScaleAspectFit];
}
-(void)touchCover
{
    self.coverView.hidden = YES;
    [headImgView removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    radius = 130;
    bubbleRadius = 40;
    

    self.countReply = [self.model.replyCount intValue];
    
    self.pages = 1;
    

    //要等加载数据后  再实现该方法。 否则获取不到数据
    NSString * ageStr = [NSString stringWithFormat:@"%@",self.model.bdage];
    if ([self.model.bdage intValue] == -1)
    {
        ageStr = @"年龄保密哦";
    }else
    {
        ageStr = [NSString stringWithFormat:@"今年%@",self.model.bdage];
    }
    shareModelData =[[shareModel alloc] initWithImgURL:self.IuserImg
                                                  With:[NSString stringWithFormat:@"http://www.rm520.cn/rmda/index/%@",self.model.bdID]
                                                  With:[NSString stringWithFormat:@"%@ 的档案",self.IuserName]
                     
                                                  With:[NSString stringWithFormat:@"我是%@,%@,我是做%@,爱好是%@,我想%@"
                                                        ,self.model.bdname,
                                                        ageStr,
                                                        self.model.bdjob,
                                                        self.model.bdhobby,
                                                        self.model.bddo
                                                        ]];
    
    
    self.userImageArr = [NSMutableArray arrayWithObjects:
                   @"http://img2.hao123.com/data/1_c552876dfafe1f1aabb88e53825babfe_510",
                   @"http://img0.hao123.com/data/1_5a7d424a05e4786533c209ebdea526bd_510",
                   @"http://img3.hao123.com/data/1_f5655149f505585b3ba7d06198c20e79_0",
                   @"http://img6.hao123.com/data/1_1a67f326e1272606bb89bad1df110cf6_0", nil];
    
    
    
    [self InitNav];
    self.userToID = self.model.randId;
    NSDictionary *type =@{
                          @"type" :@0
                          };
    LoadData *getAdData = [LoadData LoadDatakWithUrl:@"/ads/get" WithDic:type withCount:19];
    getAdData.ReturnLoadDataWithDictBlock = ^(NSDictionary *dict)
    {
        if (!dict[@"img"])
        {
            return ;
        }
    };
    self.commentModel = [[CommentModel alloc] init];
    [quickMethod setSize:CGSizeMake(MainWidth, MainHeight) with:self.view];
    self.title = [NSString stringWithFormat:@"%@的档案",self.model.bdname];
   
    
    self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,10,MainWidth,MainHeight-64-10-50) style:UITableViewStylePlain];
    self.commentTableView.separatorStyle = UITableViewCellAccessoryNone;
    
    self.titleViewVC = [[TitleViewVC alloc] init];
    NSString *bddoStr = [NSString stringWithFormat:@"我希望通过人脉档案:  %@",self.model.bddo];
    self.titleViewVC.str = bddoStr;
    
    [self addChildViewController:self.titleViewVC];
    self.titleView = [[UIView alloc] initWithFrame:self.titleViewVC.view.frame];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardSel)];
    [self.titleView addGestureRecognizer:tap];
    self.titleViewVC.view.frame = CGRectMake(10, 0, self.titleView.width-20, self.titleViewVC.view.height);
    [self.titleView addSubview:self.titleViewVC.view];

    

    
    [self.titleViewVC.headImage sd_setImageWithURL:[NSURL URLWithString:self.IuserImg] placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];
    [self.titleViewVC.headImage setContentMode:UIViewContentModeScaleAspectFill];
    UITapGestureRecognizer *headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhoto)];
    
    [self.titleViewVC.headImage addGestureRecognizer:headImageTap];
    
    if ([self.IuserSex  integerValue] ==1)
    {
        self.titleViewVC.genterImage.image = [UIImage imageNamed:@"性别-男.png"];
        self.titleViewVC.mainName.textColor = [UIColor blueColor];
    }else if([self.IuserSex integerValue] ==-1)
    {
        self.titleViewVC.genterImage.image = [UIImage imageNamed:@"性别-女.png"];
        self.titleViewVC.mainName.textColor = [UIColor redColor];
    }else
    {
        self.titleViewVC.genterImage.image = [UIImage imageNamed:@"boyAndGirl.png"];
        self.titleViewVC.mainName.textColor = [UIColor lightGrayColor];
    }
#pragma mark-----model
    
    self.titleViewVC.mainName.text  = self.IuserName;
    self.titleViewVC.nameLabel.text = self.model.bdname;
    self.titleViewVC.cityLabel.text = self.model.bdcity;
    //添加年龄判断
    int age = [[NSString stringWithFormat:@"%@",self.model.bdage]intValue];
    if (age == -1)
    {
        self.titleViewVC.ageLabel.text = @"就不告诉你";
    }else
    {
    self.titleViewVC.ageLabel.text  = [NSString stringWithFormat:@"%@",self.model.bdage];
    }
    self.titleViewVC.visitLabel.text = [NSString stringWithFormat:@"访问量 %@",self.model.visited];
//    NSLog(@"--------gender-----%@",self.model.bdgender);
    if ([self.model.bdgender intValue] ==1)
    {
        self.titleViewVC.genderLabel.text = @"帅哥";
    }else if([self.model.bdgender intValue] ==-1)
    {
        self.titleViewVC.genderLabel.text = @"美女";
    }else
    {
        self.titleViewVC.genderLabel.text = @"保密";
    }
    
    self.titleViewVC.idoLabel.text  = self.model.bdjob;
    self.titleViewVC.hobbyLabel.text  = self.model.bdhobby;
   
    
    self.titleViewVC.hopeLabel.text = bddoStr;

    self.titleViewVC.timeLabel.text = [quickMethod quickGetTimeFormWith:[quickMethod transformTimeToString:self.model.time]];
    hopeLabelSize = [self getLableHeight:bddoStr];
    idoLabelSize = [self getLableHeight:self.model.bdjob];
    hobbyLabelSize = [self getLableHeight:self.model.bdhobby];
//    [self.titleViewVC.hobbyLabel sizeToFit];
//    [self.titleViewVC.idoLabel sizeToFit];
//    [self.titleViewVC.hopeLabel sizeToFit];
//    self.titleViewVC.hopeLabel.height = hopeLabelSize.height;
//    self.titleViewVC.hobbyLabel.height = hobbyLabelSize.height;
//    self.titleViewVC.idoLabel.height = idoLabelSize.height;
    int height = 0;
//    int hobbyHeight = self.titleViewVC.hobbyLabel.height;
//    int hopeHeight = self.titleViewVC.hopeLabel.height;
//    int idoHeight = self.titleViewVC.idoLabel.height;
//    if (hobbyHeight != 16) {
//        height += hobbyHeight - 12;
//    }
//    if (hopeHeight != 16) {
//        height += hopeHeight - 12;
//    }
//    if (idoHeight != 16) {
//        height += idoHeight - 12;
//    }
    if (hobbyLabelSize.height > 21) {
        height += hobbyLabelSize.height -20;
    }
    if (hopeLabelSize.height >21) {
        height += hopeLabelSize.height -20;
    }if (idoLabelSize.height > 21) {
        height += idoLabelSize.height -20;
    }
     self.titleViewVC.view.height = self.titleViewVC.view.height +height;

    
//    NSLog(@"------%f",self.titleViewVC.beFriendLabel.y);
    // 110 178 68
    self.chatImage= [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 34, 34)];
    self.chatImage.backgroundColor = [UIColor whiteColor];
    
    
    
    [quickMethod doCornerRadiusWith:self.chatImage WithRadius:5 WithBorderWidth:1 WithColor:RGB(110, 178, 68)];
    self.chatImage.image = [UIImage imageNamed:@"微信小图标.png"];
    [self.titleViewVC.weChatBtn addSubview:self.chatImage];
    
 
    
  
    
    
    [self.titleViewVC.weChatBtn setBackgroundColor:RGB(110, 178, 68)];

    [self.titleViewVC.weChatBtn addSubview:[CUSFlashLabel setCUSFlashLabel:[NSString stringWithFormat:@"微信号: %@",self.model.bdwx]]];
    
    if (![[LoginTool returnjudgeKey]  isEqual:@"1"])
    {
        self.titleViewVC.weChatBtn.hidden = YES;
    }
    
    [self.titleViewVC.weChatBtn addTarget:self action:@selector(showCopyWeChat) forControlEvents:UIControlEventTouchUpInside];
    
    
    [quickMethod doCornerRadiusWith:self.titleViewVC.weChatBtn WithRadius:5 WithBorderWidth:1 WithColor:RGB(110, 178, 68)];
    
    

    
    self.commentTableView.tableHeaderView = self.titleView;
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.commentTableView];
    
    __weak UserInfoVC * myUserInfoVC =self;
    __weak inputView * weakInputView = myInputView;
//   NSLog(@"model = %@",self.model.bdID);
   NSDictionary *getCommenPara = @{@"id":self.model.bdID,
                                   @"page":[NSString stringWithFormat:@"%d",self.pages],
                                   @"pageSize":@"10"
                           
                           };
    LoadData *getCommentData = [LoadData LoadDatakWithUrl:@"/usercomment/detail" WithDic:getCommenPara withCount:10];
    getCommentData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *modelArray)
    {
        self.modelArray = modelArray;
        [self.commentTableView reloadData];
    };
    
    self.commentTableView.rowHeight = 80;
    
    myInputView = [[inputView alloc]initWith:NO With:NO];
    
    [self.view addSubview:myInputView];

    
#pragma mark---发送评论

    myInputView.ReturnSendMessageBtn = ^(NSString* message)
    {
        
//        NSLog(@" id  =  %@, %@, %@, %@,",myUserInfoVC.model.bdID,[LoginTool returnRandId],myUserInfoVC.model.randId,message);
        if ([LoginTool returnToken])
        {
            
            if ([myUserInfoVC VefityWithName:message With:@"评论内容"])
            {
                NSDictionary *sendCommenPara = @{ @"id"         : [NSString stringWithFormat:@"%@",myUserInfoVC.model.bdID],
                                                  @"body"       : [NSString stringWithFormat:@"%@",message],
                                                  @"userFromId" :[NSString stringWithFormat:@"%@",[LoginTool returnRandId]],
                                                  @"userToId"   :[NSString stringWithFormat:@"%@",myUserInfoVC.userToID]
                                                  
                                                  };
                [[AppDelegate sharedInstance] showTextDialog:@"正在发送"];
                LoadData *sendCommentData = [LoadData LoadDatakWithUrl:@"/usercomment/reply" WithDic:sendCommenPara withCount:11];
                [myUserInfoVC hideKeyBoard];///usercomment/reply
                
                
                sendCommentData.ReturnStrBlock = ^(NSString *callBack)
                {
                    myUserInfoVC.countReply = myUserInfoVC.countReply + 1;
                    [[AppDelegate sharedInstance] setHUDHide];
                    weakInputView.textView.text =@"";
                    myUserInfoVC.pages =1;
                    
                    NSDictionary *getCommenPara = @{@"id"       :[NSString stringWithFormat:@"%@",myUserInfoVC.model.bdID],
                                                    @"page"     :[NSString stringWithFormat:@"%d",myUserInfoVC.pages],
                                                    @"pageSize" :@"10"
                                                    
                                                    };
                    LoadData *getCommentData = [LoadData LoadDatakWithUrl:@"/usercomment/detail" WithDic:getCommenPara withCount:10];
                    getCommentData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *modelArray){
                        myUserInfoVC.modelArray = modelArray;
                        [myUserInfoVC.commentTableView reloadData];
                    };
                };
                
            };
    }else
    {
        [[AppDelegate sharedInstance] ShowAlert:@"请先登录"];

    }
    };
    
    
        
    imageArrCount = self.model.imageArr.count;
    if (imageArrCount!=0)
    {
        [self showFirstImage];
    }else
    {
//        NSLog(@"0图片");
    }
    
    [self initRefreshControl];
}
-(CGSize)getLableHeight:(NSString *)str
{
    UIFont * font = [UIFont systemFontOfSize:13.0];
    maxSize = CGSizeMake(self.view.width-30, 2000);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:5.0f];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    return [str boundingRectWithSize:maxSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes context:nil].size;
    
}

-(void)makeBtnFeel
{
    float x = self.chatImage.x;
    float y = self.chatImage.y;
    [UIView animateWithDuration:2 animations:^(void)
    {
        self.chatImage.origin = CGPointMake(160, y);
    }completion:^(BOOL finished)
    {
        [UIView animateWithDuration:2 animations:^(void)
        {
             self.chatImage.origin = CGPointMake(x, y);
        }completion:^(BOOL finished)
        {

        }];
    }];
}

-(void)showForthImage
{
    
    self.fourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.threeImageView.frame)+10, MainWidth-40, 0)];
    self.fourImageView.backgroundColor = [UIColor redColor];
    [self.titleView addSubview:self.fourImageView];
    [self.fourImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageArr[3][@"img"]]];
    
    if (!self.model.img)
    {
        [self judgeFourImage:self.fourImageView];
    }
}

-(void)showThirdImage
{
    self.threeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.twoImageView.frame)+10, MainWidth-40, 0)];
    self.threeImageView.backgroundColor = [UIColor redColor];
    [self.titleView addSubview:self.threeImageView];
    [self.threeImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageArr[2][@"img"]]];
    
    if (!self.model.img)
    {
        [self judgeThreeImage:self.threeImageView];
    }

}

-(void)showSecondImage
{
    self.twoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.oneImageView.frame)+10, MainWidth-40, 0)];
    self.twoImageView.backgroundColor = [UIColor redColor];
    [self.titleView addSubview:self.twoImageView];
    [self.twoImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageArr[1][@"img"]]];
    
    if (!self.model.img)
    {
        [self judgeTwoImage:self.twoImageView];
    }

}

-(void)showFirstImage
{

    self.oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleViewVC.view.frame)-10, MainWidth-40, 0)];
    self.oneImageView.backgroundColor = [UIColor redColor];
    [self.titleView addSubview:self.oneImageView];
    [self.oneImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageArr[0][@"img"]]];
    
    if (!self.model.img)
    {
        [self judgeOneImage:self.oneImageView];
    }

    
}

-(void)viewWillAppear:(BOOL)animated
{
//     NSLog(@"self.titleViewVC.hopeLabel.height------%f",self.titleViewVC.hopeLabel.height);
}

-(void)judgeOneImage:(UIImageView*)imageView
{
    if (!imageView.image)
    {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self judgeOneImage:imageView];
                       });
        
    }else
    {

        [UIView animateWithDuration:0.3 animations:^(void)
         {
             [quickMethod setSize:CGSizeMake(MainWidth -20,(MainWidth-20)*imageView.image.size.height/imageView.image.size.width) with:imageView];
             [quickMethod setSize:CGSizeMake(MainWidth-20, self.titleViewVC.view.height+imageView.height) with:self.titleView];
             self.titleView.backgroundColor = RGB(237, 237, 237);
             self.commentTableView.tableHeaderView = self.titleView;
             [self.commentTableView reloadData];
             
             imageArrCount--;
             if (imageArrCount!=0)
             {
                 [self showSecondImage];
             }else
             {
                 [self loadAD];
//                 NSLog(@"1图片");
             }
             
         }completion:^(BOOL finished)
         {
         }];
        

        
    }
}

-(void)judgeTwoImage:(UIImageView*)imageView
{
    if (!imageView.image)
    {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self judgeTwoImage:imageView];
                       });
        
    }else
    {
        
        [UIView animateWithDuration:0.3 animations:^(void)
         {
             
             [quickMethod setSize:CGSizeMake(MainWidth -20,(MainWidth-20)*imageView.image.size.height/imageView.image.size.width) with:imageView];
             [quickMethod setSize:CGSizeMake(MainWidth-20, self.titleViewVC.view.height+imageView.height) with:self.titleView];
             self.commentTableView.tableHeaderView = self.titleView;
             [self.commentTableView reloadData];
             
             imageArrCount--;
             if (imageArrCount!=0)
             {
                 [self showThirdImage];
             }else
             {
//                 NSLog(@"2图片");
             }
             
         }completion:^(BOOL finished)
        {
         }];

        
        
    }
}
-(void)judgeThreeImage:(UIImageView*)imageView
{
    if (!imageView.image)
    {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self judgeThreeImage:imageView];
                       });
        
    }else
    {
        
        [UIView animateWithDuration:0.3 animations:^(void)
         {
             [quickMethod setSize:CGSizeMake(MainWidth -20,(MainWidth-20)*imageView.image.size.height/imageView.image.size.width) with:imageView];
             [quickMethod setSize:CGSizeMake(MainWidth-20, self.titleViewVC.view.height+imageView.height) with:self.titleView];

             self.commentTableView.tableHeaderView = self.titleView;
             [self.commentTableView reloadData];
             
             imageArrCount--;
             
             if (imageArrCount!=0)
             {
                 [self showForthImage];
             }else
             {
                 [self loadAD];
//                 NSLog(@"3图片");
             }
             
         }completion:^(BOOL finished)
         {
         }];

        
    }
}

-(void)judgeFourImage:(UIImageView*)imageView
{
    if (!imageView.image)
    {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self judgeFourImage:imageView];
                       });
        
    }else
    {
        
        [UIView animateWithDuration:0.3 animations:^(void)
         {
             [quickMethod setSize:CGSizeMake(MainWidth -20,
                                             (MainWidth-20)*imageView.image.size.height/imageView.image.size.width) with:imageView];
             
             [quickMethod setSize:CGSizeMake(MainWidth-20, self.titleViewVC.view.height+imageView.height) with:self.titleView];
             self.commentTableView.tableHeaderView = self.titleView;
             [self.commentTableView reloadData];
             
//             NSLog(@"4图片");
             
         }completion:^(BOOL finished)
         {
         }];

        
        
        
    }
}


-(void)loadAD
{
//    NSLog(@"%f-----%f",self.titleView.y,self.titleView.height);
    self.titleScrollView = [[UIScrollView alloc] init];
    
    NSDictionary *type =@{
                          @"type" :@1
                          };
    LoadData *getTwoAdData = [LoadData LoadDatakWithUrl:@"/ads/get" WithDic:type withCount:19];
    getTwoAdData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *arr)
    {
        
        self.urlStrArr = [NSMutableArray array];
//        NSLog(@"arr== %d",arr.count);
        if (!arr)
        {
            [quickMethod setSize: CGSizeMake(MainWidth, 0) with:self.titleScrollView];
            return ;
        }
        [quickMethod setSize:CGSizeMake(MainWidth, MainWidth/5) with:self.titleScrollView];
        self.titleScrollView.origin                   = CGPointMake(0, self.titleView.height);
        self.titleScrollView.contentSize              = CGSizeMake(MainWidth*arr.count, MainWidth/5);
        self.titleScrollView.bounces                  = NO;
        //[quickMethod setSize:CGSizeMake(MainWidth-20, MainWidth/5) with:self.titleScrollView];
        self.titleView.height = self.titleView.height+MainWidth/5;
        [self.titleView addSubview:self.titleScrollView];
        self.commentTableView.tableHeaderView    = self.titleView;
        
        
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
            [self.titleScrollView addSubview:imageView];
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
    [self.titleScrollView setContentOffset:CGPointMake(MainWidth * offCount,0) animated:YES];
    
    offCount++;
}
-(void)showCopyWeChat
{
    [quickMethod copyWechat:self.model.bdwx];
}

// 初始化导航栏
-(void)InitNav
{
    self.buildFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickMethod setSize:CGSizeMake(20, 20) with:self.buildFileBtn];
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.buildFileBtn.bounds];
    image.image = [UIImage imageNamed:@"open.png"];
    [self.buildFileBtn addTarget:self action:@selector(touch_ShareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.buildFileBtn addSubview:image];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.buildFileBtn];
    
    NSArray *rightBtns=[NSArray arrayWithObjects:rightBarButtonItem, nil];
    self.navigationItem.rightBarButtonItems = rightBtns;
}

-(void)turnToBuildFile
{
    testPrint
}




-(NSString*)returnStr:(id)Str
{
    if (!Str)
    {
        return @"";
    }
    return Str;
}


-(BOOL)VefityWithName:(NSString*)name With:(NSString*)text
{
    if (![[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length])
    {
//        NSLog(@"%@为空",text);
        
        [[AppDelegate sharedInstance] ShowAlert:@"评论内容不能为空"];
                
        return NO;
    }
    return YES;
}


-(void)hideKeyBoard
{
    [myInputView textViewResign];
    self.userToID = self.model.randId;
    myInputView.textView.text = @"";
}
#pragma tableview delegate


/**
 *  初始化下拉刷新控件
 */
-(void)initRefreshControl
{

   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(footerEndRefreshing) name:@"footerEndRefreshing" object:nil];
   
    [self.commentTableView addFooterWithTarget:self action:@selector(addMoreDataSel)];
}

/**
 *  上拉加载更多数据
 */
-(void)addMoreDataSel
{
    ++self.pages;
//    NSLog(@"----------%d",self.pages);
    NSDictionary *getCommenPara = @{@"id":self.model.bdID,
                                    @"page":[NSString stringWithFormat:@"%d",self.pages],
                                    @"pageSize":@"10"
                                    };
    
    LoadData *getCommentData = [LoadData LoadDatakWithUrl:@"/usercomment/detail" WithDic:getCommenPara withCount:10];
    getCommentData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *modelArray)
    {
        [self.modelArray addObjectsFromArray:modelArray];
        [self.commentTableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
    };

}

-(void)footerEndRefreshing
{
    [self.commentTableView footerEndRefreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.modelArray.count;
}

#pragma mark --- 返回tableviewHead 个数
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   
    return [NSString stringWithFormat:@"评论( %d )",self.countReply];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserInfoCell * cell = [self.commentTableView dequeueReusableCellWithIdentifier:UserInfoCellID];
    CommentModel *model = self.modelArray[indexPath.row];
    
    
    if (!cell)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:UserInfoCellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.indexRow  = indexPath.row;
    
    /**
     *  跳转个人中心
     */
    cell.PushToPersonVC = ^(NSInteger indexRow)
    {
        PerSonelVC *personVC = [[PerSonelVC alloc] init];
        CommentModel *model = self.modelArray[indexRow];
        personVC.randId = [NSString stringWithFormat:@"%@",model.userFromId];
        personVC.headImageUrl = [NSURL URLWithString:model.userFromImg];
        personVC.name = model.userFromName;
        personVC.userGenderText = model.userFromGender;
       // personVC.model = model;
        [self.navigationController pushViewController:personVC animated:YES];
    
        
    };
    
    cell.userName.text = model.userFromName;
    [cell.headImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.userFromImg] placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];
  
    cell.userReply.text = model.body;
    cell.userTime.text = [quickMethod quickGetTimeFormWith:[quickMethod transformTimeToString:model.createdAt]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.commentModel = self.modelArray[indexPath.row];
    self.userToID = self.commentModel.userFromId;
    myInputView.textView.text = [NSString stringWithFormat:@"回复%@:  ",self.commentModel.userFromName];

}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)hideKeyBoardSel
{
    [self hideKeyBoard];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
