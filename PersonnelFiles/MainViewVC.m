//
//  MainViewVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "MainViewVC.h"
#import "MainTableVIewCell.h"
#import "PerSonelVC.h"
#import "BuildFileVC.h"
#import "LoginTool.h"
#import "PublicPage.h"
#import "MTCityViewController.h"
#import "UserInfoVC.h"
#import "LoadData.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "LoginTool.h"
#import "AppDelegate.h"
#import "AdWebViewVC.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "LoginViewController.h"

@interface MainViewVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,MainTableVIewCellDelegate,UIActionSheetDelegate>
{
    NSInteger lastIndex;
}


@property(strong,nonatomic)UIButton     *mainSearchBtn;
@property(strong,nonatomic)UIView       *buttonView;


@property(strong,nonatomic)UIButton     *sexBtn;
@property(strong,nonatomic)UIButton     *zoneBtn;
@property(strong,nonatomic)UIButton     *ageBtn;



@property(strong,nonatomic)UIButton     *recomendBtn;
@property(strong,nonatomic)UIButton     *lastestBtn;
@property(strong,nonatomic)UISegmentedControl * segmentedControl;
@property(strong,nonatomic)UIView       *coverView;
@property(strong,nonatomic)UIBarButtonItem *leftBarButtonItem;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (nonatomic,strong)UIButton        *cover  ;

@property(nonatomic,strong)NSMutableArray *modelNewArray;
@property(nonatomic,strong)NSMutableArray *modelProArray;

@property(nonatomic,strong)UIButton *personBtn;
@property(nonatomic,strong)UIButton *buildFileBtn;

@property(nonatomic,strong)UILabel  *selectZoneLabel;
@property(nonatomic,strong)UILabel  *selectSexLabel;
@property(nonatomic,strong)UILabel  *selectAgeLabel;
@end

@implementation MainViewVC

/**
 *   首页搜索按钮
 */
-(UIButton *)mainSearchBtn
{
    
//    NSLog(@"mainWidch = %f",MainWidth);
    if (!_mainSearchBtn)
    {
        _mainSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainWidth, mainSearchBarHeight)];
        _mainSearchBtn.backgroundColor = [UIColor lightGrayColor];
        if (MainWidth<325)
        {
            [_mainSearchBtn setBackgroundImage:[UIImage imageNamed:@"search5.png"] forState:UIControlStateNormal];
            [_mainSearchBtn setBackgroundImage:[UIImage imageNamed:@"search5.png"] forState:UIControlStateHighlighted];
            
        }else if(MainWidth<414)
        {
            [_mainSearchBtn setBackgroundImage:[UIImage imageNamed:@"search6.png"] forState:UIControlStateNormal];
            [_mainSearchBtn setBackgroundImage:[UIImage imageNamed:@"search6.png"] forState:UIControlStateHighlighted];
            
        }else
        {
            [_mainSearchBtn setBackgroundImage:[UIImage imageNamed:@"search6.5.png"] forState:UIControlStateNormal];
            [_mainSearchBtn setBackgroundImage:[UIImage imageNamed:@"search6.5.png"] forState:UIControlStateHighlighted];
            
        }
        
        [_mainSearchBtn addTarget:self action:@selector(turnToSearchVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_mainSearchBtn];
    }
    return _mainSearchBtn;
}



/**
 *  跳转搜索界面
 */
-(void)turnToSearchVC
{
    MainSearchVC *mainSearchVC = [[MainSearchVC alloc] init];
    mainSearchVC.sexNumber = @0;
    mainSearchVC.cityName  = self.selectZoneLabel.text;
    mainSearchVC.isSearch = NO;
    [self.navigationController pushViewController:mainSearchVC animated:YES];
}



-(UIView *)buttonView
{
    
    if (!_buttonView)
    {
        _buttonView.backgroundColor = [UIColor grayColor];
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, MainHeight -buttonViewHeight -MainNavHeight-1, MainWidth, buttonViewHeight)];
        [self.view addSubview:_buttonView];
    }
    return _buttonView;
}


/**
 *  登陆
 *
 */
-(UIView *)coverView
{
    if (!_coverView)
    {
        _coverView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, MainWidth, MainHeight)];
        _coverView.backgroundColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:0.85];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCover)];
        [_coverView addGestureRecognizer:tap];
        
        [self.view.window addSubview:_coverView];
        
        if (![QQApiInterface isQQInstalled]) {
            UIImageView *backView = [[UIImageView alloc] init];
            backView.center = CGPointMake(MainWidth/4, MainHeight/4);
            [backView setImage:[UIImage imageNamed:@"img_login_bg"]];
            [quickMethod setSize:CGSizeMake(183, 234) with:backView];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth/2, MainHeight/2)];
            lbl.text = @"使用账号登陆";
            lbl.font = [UIFont systemFontOfSize:20];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor whiteColor];
            lbl.textAlignment = NSTextAlignmentCenter;
//            [quickMethod setSize:CGSizeMake(183, 234) with:lbl];
            [backView addSubview:lbl];
            
            [_coverView addSubview:backView];
            backView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountLoginSel)];
            [backView addGestureRecognizer:tap];
            return _coverView;
        }
        
        if (![[LoginTool returnjudgeKey]  isEqual:@"1"])
        {
            UIImageView *backView = [[UIImageView alloc] init];
            backView.center = CGPointMake(MainWidth/4, MainHeight/4);
            [backView setImage:[UIImage imageNamed:@"qq登陆.png"]];
            [quickMethod setSize:CGSizeMake(183, 234) with:backView];
            [_coverView addSubview:backView];
            backView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqloginSel)];
            [backView addGestureRecognizer:tap];
            
        }else
        {
            UIImageView *backView = [[UIImageView alloc] init];
            backView.center = CGPointMake(MainWidth/4, MainHeight/4);
            [backView setImage:[UIImage imageNamed:@"登陆背景.png"]];
            [quickMethod setSize:CGSizeMake(183, 234) with:backView];
            [_coverView addSubview:backView];
            backView.userInteractionEnabled = YES;
            
            UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(40, 70, backView.width-80, (backView.width-80)/245*84)];
            [btn1 addTarget:self action:@selector(qqloginSel) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setImage:[UIImage imageNamed:@"登陆-QQ"] forState:UIControlStateNormal];
            [backView addSubview:btn1];
            
            UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(40,160, backView.width-80, (backView.width-80)/245*84)];
            [btn2 addTarget:self action:@selector(wechatloginSel) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setImage:[UIImage imageNamed:@"登陆-微信"] forState:UIControlStateNormal];
            [backView addSubview:btn2];
            
        }
        
        
        
    }
    
    return _coverView;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.selectAgeLabel != nil) {
        self.selectAgeLabel.text = @"年龄段";

    }
    [self getImageAndName];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNav];
    
    self.sexNumber =@0;
    self.navigationItem.backBarButtonItem =  [UIBarButtonItem setUIBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageAndName) name:@"geiNameAndImage" object:nil];
    
    
    [[LoginTool sharedInstance] initSdk];
    
    
    [self.mainCollectionView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
              forCellWithReuseIdentifier:CellIdentifier];
    
    
    UICollectionViewFlowLayout *layout = (id) self.mainCollectionView.collectionViewLayout;
    [quickMethod setSize:CGSizeMake(MainWidth, MainWidth-mainSearchBarHeight-buttonViewHeight-MainNavHeight) with:self.mainCollectionView];
    
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
//    NSLog(@"%f = %f = %f = %f",self.mainCollectionView.x,self.mainCollectionView.y,self.mainCollectionView.width,self.mainCollectionView.height);
    layout.itemSize = CGSizeMake(MainWidth, MainHeight-mainSearchBarHeight-buttonViewHeight-MainNavHeight);
    
    
    [self btnIsSelected:YES with:NO];
    
    self.fromArray = [NSMutableArray array];
    
    self.mainSearchBarSet = [[MainSearchBar alloc] init];
    self.mainSearchBarSet.view.backgroundColor = [UIColor whiteColor];
//    self.myPicker.delegate = self;
//    self.myPicker.dataSource =self;
//    [self getPickerData];
//    [self initView];
    
    self.mainSearchBtn;
    self.buttonView;
    
    
    /**
     *  pickView
     */
    [self setZoneButton];
    [self setSexButton];
    [self setAgeButton];
    
}


//****************************************************************************




#pragma mark 选择地区

-(void)setZoneButton
{
    self.zoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainWidth/3-0.01, 0, MainWidth/3,buttonViewHeight)];
    [self.buttonView addSubview:self.zoneBtn];
    [self.zoneBtn setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
    
    self.selectZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, MainWidth/3, 15)];
    self.selectZoneLabel.text = @"地区";
    self.selectZoneLabel.textColor = [UIColor lightGrayColor];
    self.selectZoneLabel.font = [UIFont systemFontOfSize:13];
    self.selectZoneLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.zoneBtn addSubview:self.selectZoneLabel];
    
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, MainWidth/3, 25)];
    titleImage.image = [UIImage imageNamed:@"地区.png"];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.zoneBtn addSubview:titleImage];
    
    [self.zoneBtn addTarget:self action:@selector(selectZoneSel) forControlEvents:UIControlEventTouchUpInside];
}


-(void)selectZoneSel
{
    MTCityViewController *city = [[MTCityViewController alloc] init];
    city.ReturnTextBlock =^(NSString *cityName)
    {
        MainSearchVC *mainSearchVC = [[MainSearchVC alloc] init];
        mainSearchVC.cityName = cityName;
        mainSearchVC.sexNumber = self.sexNumber;
        mainSearchVC.isSearch = YES;
        [self.navigationController pushViewController:mainSearchVC animated:YES];
    };
    [self presentViewController:city animated:YES completion:nil];
    
}

#pragma mark----选择性别搜索

-(void)setSexButton
{
    self.sexBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainWidth/3,buttonViewHeight)];
    [self.buttonView addSubview:self.sexBtn];
    [self.sexBtn setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
    
    self.selectSexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, MainWidth/3, 15)];
    self.selectSexLabel.text = @"性别";
    self.selectSexLabel.textColor = [UIColor lightGrayColor];
    self.selectSexLabel.font = [UIFont systemFontOfSize:13];
    self.selectSexLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.sexBtn addSubview:self.selectSexLabel];
    
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, MainWidth/3, 25)];
    titleImage.image = [UIImage imageNamed:@"性别.png"];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.sexBtn addSubview:titleImage];
    
    [self.sexBtn addTarget:self action:@selector(selectSexSel) forControlEvents:UIControlEventTouchUpInside];
}


-(void)selectSexSel
{
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"男",@"女",@"不限", nil];
    
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    MainSearchVC * mainSearchVC = [[MainSearchVC alloc] init];
    mainSearchVC.cityName = self.selectZoneLabel.text;
    mainSearchVC.isSearch = YES;
    switch (buttonIndex)
    {
            // 男
        case 0:
            mainSearchVC.sexNumber = @1;
            self.sexNumber = @1;
            [self.navigationController pushViewController:mainSearchVC animated:YES];
            break;
            // 女
        case 1:
            mainSearchVC.sexNumber = @-1;
            self.sexNumber = @-1;
            [self.navigationController pushViewController:mainSearchVC animated:YES];
            break;
            
        case 2:
            mainSearchVC.sexNumber  = @0;
            self.sexNumber = @0;
            [self.navigationController pushViewController:mainSearchVC animated:YES];
            break;
    }
    
    
    
}


#pragma mark----年龄段
-(void)setAgeButton
{
    self.ageBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainWidth/3*2, 0, MainWidth/3,buttonViewHeight)];
    [self.buttonView addSubview:self.ageBtn];
    [self.ageBtn setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
    
    self.selectAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, MainWidth/3, 15)];
    self.selectAgeLabel.text = @"年龄段";
    self.selectAgeLabel.textColor = [UIColor lightGrayColor];
    self.selectAgeLabel.font = [UIFont systemFontOfSize:13];
    self.selectAgeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.ageBtn addSubview:self.selectAgeLabel];
    
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, MainWidth/3, 25)];
    titleImage.image = [UIImage imageNamed:@"age.png"];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.ageBtn addSubview:titleImage];
    
    [self.ageBtn addTarget:self action:@selector(selectAgeSel) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectAgeSel
{
    [self.mainSearchBarSet openPickVCWith:self.view];
    self.mainSearchBarSet.delegate = self;

}
-(void)sureBtn:(NSString *)sureStr
{
    MainSearchVC * mainSearchVC = [[MainSearchVC alloc] init];
    mainSearchVC.ageGroup = sureStr;
    mainSearchVC.sexNumber = self.sexNumber;
    mainSearchVC.cityName = self.selectZoneLabel.text;
    [self.navigationController pushViewController:mainSearchVC animated:YES];
    NSString * fromAge = [sureStr substringToIndex:4];
    NSString * toAge = [sureStr substringFromIndex:4];
    if ([toAge isEqualToString:@"0000"]) {
        toAge = @"至今";
    }
    self.selectAgeLabel.text = [NSString stringWithFormat:@"%@-%@",fromAge,toAge];
    mainSearchVC.isSearch = YES;
}
-(void)cancelBtn:(NSString *)cancelStr
{
    self.selectAgeLabel.text =cancelStr;
}
//-(void)selectAgeSel
//{
//    [self.view addSubview:self.maskView];
//    [self.view addSubview:self.pickerBgView];
//    self.maskView.alpha = 0;
//    self.pickerBgView.top = self.view.height;
//    
//    [UIView animateWithDuration:0.3 animations:^
//     {
//         self.maskView.alpha = 0.3;
//         self.pickerBgView.bottom = self.view.height;
//     }];
//    //年龄段默认出现在1980-1989
//    [self.myPicker selectRow:7 inComponent:0 animated:NO];
//    [self pickerView:self.myPicker didSelectRow:7 inComponent:0];
//}
//
//
//
//
//#pragma mark -- 确定跳转搜索界面，进行搜索
//- (IBAction)sureBtn:(id)sender
//{
//    
//    [self hideMyPicker];
//    
//    MainSearchVC * mainSearchVC = [[MainSearchVC alloc] init];
//    
//    mainSearchVC.ageGroup=
//    [NSString stringWithFormat:@"%@%@",
//     [self.fromArray objectAtIndex:[self.myPicker selectedRowInComponent:0]]
//     ,[self.toArray objectAtIndex:[self.myPicker selectedRowInComponent:1]]];
//    mainSearchVC.isSearch = YES;
//    
//    [self.navigationController pushViewController:mainSearchVC animated:YES];
//    
//}
//
//- (IBAction)cancelBtn:(id)sender
//{
//    self.selectAgeLabel.text =@"年龄段";
//    [self hideMyPicker];
//}
//
//#pragma mark - init view
//- (void)initView
//{
//    
//    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
//    self.maskView.backgroundColor = [UIColor blackColor];
//    self.maskView.alpha = 0;
//    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
//    
//    self.pickerBgView.width = MainWidth;
//}
//#pragma mark - get data
//- (void)getPickerData
//{
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Age.plist" ofType:nil];
//    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
//    NSArray * arr = [NSArray arrayWithArray:[self.pickerDic allKeys]];
//    
////    NSLog(@"-----%ld------%@----",arr.count,arr.lastObject);
////    self.fromArray[0] = arr.lastObject;
//    
//    for (int count =0; count<arr.count; count++)
//    {
//        [self.fromArray addObject:arr[count]];
//    }
//    
////    for (int count = 0; count < arr.count; count++)
////    {
////        NSLog(@"--------%@-------%@",self.fromArray[count],arr[count]);
////    }
//    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
//    
//    
//    if (self.selectedArray.count > 0)
//    {
////        self.toArray[0] = self.selectedArray.lastObject;
////        NSLog(@"-------self.arr------%@",self.toArray[0]);
//        for (int count =0; count<arr.count; count++)
//        {
//            [self.toArray addObject:self.selectedArray[count]];
//        }
//    }
//    
//    
//}
//
//#pragma mark - UIPicker Delegate.0
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 2;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    
//    self.selectedArray = [self.pickerDic objectForKey:[self.fromArray objectAtIndex:0]];
//    if (component == 0)
//    {
//        return self.fromArray.count;
//    } else
//    {
//        if (!self.toArray)
//        {
//            self.toArray = self.selectedArray;
//        }
//        
//        return self.toArray.count;
//    }
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0)
//    {
//        return [self.fromArray objectAtIndex:row];
//    } else
//    {
//        return [self.toArray objectAtIndex:row];
//    }
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    if (component == 0)
//    {
//        return 110;
//    } else if (component == 1)
//    {
//        return 100;
//    } else
//    {
//        return 110;
//    }
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    if (component == 0)
//    {
//        self.selectedArray = [self.pickerDic objectForKey:[self.fromArray objectAtIndex:row]];
//        
//        if (self.selectedArray.count > 0)
//        {
//            self.toArray = self.selectedArray ;
//            
//            for (NSString *age in self.toArray)
//            {
//                NSLog(@"age----%@",age);
//            }
//        } else
//        {
//            self.toArray = nil;
//        }
//        
//    }
//    [pickerView selectedRowInComponent:1];
//    [pickerView reloadComponent:1];
//    
//    
//    
//}
//
//
//- (void)hideMyPicker
//{
//    [UIView animateWithDuration:0.3 animations:^
//     {
//         self.maskView.alpha = 0;
//         self.pickerBgView.top = self.view.height;
//     } completion:^(BOOL finished)
//     {
//         [self.maskView removeFromSuperview];
//         [self.pickerBgView removeFromSuperview];
//     }];
//}


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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
#pragma mark 每个区内的元素个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 2;
}
#pragma mark 设置元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublicPage *cell;
    
    NSString *randId;
    if ([LoginTool returnRandId])
    {
        randId = [LoginTool returnRandId];
    }else
    {
        randId = @"";
    }
#pragma mark ---- 推荐页面
    if (indexPath.row==0)
    {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.modelArray = self.modelProArray;
        
        cell.ReturnTextBlock= ^(int pages){
            
            [customActivityIndicator startAnimating];
            
            NSDictionary * para = @{@"randId"   :randId,
                                    @"page" : [NSString stringWithFormat:@"%d",pages],
                                    @"pageSize"  : @"10" };
            LoadData *getProData = [LoadData LoadDatakWithUrl:@"/usercomment/pro" WithDic:para withCount:8];
            getProData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *array){
                
                if (pages==1) {
                    self.modelProArray = array;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                }else{
                    [self.modelProArray addObjectsFromArray:array];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
                }
                
                [self.mainCollectionView reloadData];
                
                [customActivityIndicator stopAnimating];
                
            };
            getProData.ReturnErrorBlock =^(NSString *callBack)
            {
                [[AppDelegate sharedInstance] ShowAlert:STR(@"网络不给力！！")];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
            };
            
        };
        
        [cell loadFirstAd];
        
    }else
    {
#pragma mark ---- 最新页面
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//        NSLog(@"model = %@",self.modelNewArray);
        cell.modelArray = self.modelNewArray;
        cell.ReturnTextBlock= ^(int pages)
        {
            [customActivityIndicator startAnimating];
            
            NSDictionary * para = @{@"randId"   :randId,
                                    @"page" : [NSString stringWithFormat:@"%d",pages],
                                    @"pageSize"  : @"10" };
            LoadData *getNewData = [LoadData LoadDatakWithUrl:@"/usercomment/get" WithDic:para withCount:7];
            getNewData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *array)
            {
                if (pages==1)
                {
                    self.modelNewArray = array;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                }else
                {
                    [self.modelNewArray addObjectsFromArray:array];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
                }
                
                [self.mainCollectionView reloadData];
                
                [customActivityIndicator stopAnimating];
                
                
            };
            getNewData.ReturnErrorBlock =^(NSString *callBack)
            {
                [[AppDelegate sharedInstance] ShowAlert:STR(@"网络不给力！！")];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"headerEndRefreshing" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
            };
        };
        
        [cell loadSecondAd];
    }
    
    /**
     *  跳转到详情
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
    
    /**
     *  跳转个人中心
     *
     */
    cell.PushToPersonVC = ^(MainNavModel *model,PerSonelVC* personVC)
    {
        personVC.randId = model.randId;
        personVC.headImageUrl = [NSURL URLWithString:model.userImg];
        personVC.name = model.username;
        personVC.model = model;
        [self.navigationController pushViewController:personVC animated:YES];
    };
    
    
    /**
     *  跳转广告界面
     *
     */
    cell.ReturnStrBlock = ^(NSString *urlStr)
    {
        AdWebViewVC * adVC = [[AdWebViewVC alloc] init];
        adVC.adWebViewUrl =urlStr;
        
//        NSLog(@"---------adurl = %@-------------urlStr------%@",adVC.adWebViewUrl,urlStr);
        [self.navigationController pushViewController:adVC animated:YES];
    };
    
    
    /**
     *  点击复制
     */
    cell.ReturnCopyWeChatBlock = ^(NSString *weChat)
    {
        [quickMethod copyWechat:weChat];
    };
    
    
    cell.isOpenUserInteraction = YES;
    cell.isCanBeHit = YES;
//    NSLog(cell.isOpenUserInteraction ? @"MainTableVIewCell.h isOpenUserInteraction Yes" : @"MainTableVIewCell.h isOpenUserInteraction No");
    
    
    
    
    [cell reloadTableView];
    return cell;
}



-(void)touchCover
{
    self.coverView.hidden = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}




-(void)getImageAndName
{
    NSURL *imageURL;
    
    if ([LoginTool returnHeadImage])
    {
        imageURL = [LoginTool returnHeadImage];
    }
    
    [self.personBtn sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];
}
#pragma mark 设置按钮
-(void)initNav
{
    
    [self initTitleView];
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSURL *imageURL;
    if ([user objectForKey:@"user"])
    {
        NSDictionary *dict = [user objectForKey:@"user"];
        
        imageURL= [NSURL URLWithString:dict[@"headImageUrl"]];
    }
    self.personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.personBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.personBtn addTarget:self action:@selector(turnToPersonel) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.personBtn sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];
    
    [quickMethod setSize:CGSizeMake(30, 30) with:self.personBtn];
    [self.personBtn.layer setCornerRadius:14];
    [self.personBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [self.personBtn.layer setBorderWidth:1.0];
    [self.personBtn.layer setMasksToBounds:YES];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.personBtn];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.buildFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickMethod setSize:CGSizeMake(20, 20) with:self.buildFileBtn];
    [self.buildFileBtn addTarget:self action:@selector(turnToBuildFile) forControlEvents:UIControlEventTouchUpInside];
    [self.buildFileBtn setImage:[UIImage imageNamed:@"编辑.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.buildFileBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

#pragma mark accountLoginSel
- (void)accountLoginSel{
    self.coverView.hidden = YES;
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark qq登陆
-(void)qqloginSel
{
    self.coverView.hidden = YES;
    [[LoginTool sharedInstance] qQLogin];
}
#pragma mark wechat登陆
-(void)wechatloginSel
{
    [[LoginTool sharedInstance] weChatLogin];
    self.coverView.hidden = YES;
}
-(void)weibologinSel
{
    self.coverView.hidden = YES;
    [[LoginTool sharedInstance] weiBoLogin];
}

-(void)initTitleView
{
    
    UIView *titleView = [[UIView alloc] init];
    [quickMethod setSize:CGSizeMake(190, 44) with:titleView];
    
    UIButton * recommendBtn = [[UIButton alloc] initWithFrame:CGRectMake(44, 10, 51, 24)];
    [recommendBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [recommendBtn setTitle:@"推荐" forState:UIControlStateNormal];
    [recommendBtn setTitleColor:mainBackColor forState:UIControlStateSelected];
    [recommendBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [recommendBtn setBackgroundImage:[UIImage imageNamed:@"NavTitleLeft0"] forState:UIControlStateNormal];
    [recommendBtn setBackgroundImage:[UIImage imageNamed:@"NavTitleLeft1"] forState:UIControlStateSelected];
    [recommendBtn addTarget:self action:@selector(recomendSel) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:recommendBtn];
    self.recomendBtn = recommendBtn;
    
    UIButton * newestBtn = [[UIButton alloc] initWithFrame:CGRectMake(95, 10, 51, 24)];
    [newestBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [newestBtn setTitle:@"最新" forState:UIControlStateNormal];
    [newestBtn setTitleColor:mainBackColor forState:UIControlStateSelected];
    [newestBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [newestBtn setBackgroundImage:[UIImage imageNamed:@"NavTitleRight0"] forState:UIControlStateNormal];
    [newestBtn setBackgroundImage:[UIImage imageNamed:@"NavTitleRight1"] forState:UIControlStateSelected];
    [newestBtn addTarget:self action:@selector(newestSel) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:newestBtn];
    self.lastestBtn = newestBtn;
    
    [titleView addSubview:[customActivityIndicator returnActivityIndicator]];
    self.navigationItem.titleView = titleView;
}
-(void)recomendSel
{
    //8
    [self btnIsSelected:YES with:NO];
    [self judgeStatusWith:0];
    
    
    
}
-(void)newestSel
{
    [self btnIsSelected:NO with:YES];
    [self judgeStatusWith:1];
}

-(void)turnToPersonel
{
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSLog(@"user== %@", [user objectForKey:@"user"]);
    if ([LoginTool returnToken]) {
        
        PerSonelVC * person = [[PerSonelVC alloc] init];
        person.randId = [LoginTool returnRandId];
        
        person.name   = [LoginTool returnName];
        person.userGenderText = [LoginTool returnGender];
        person.headImageUrl = [LoginTool returnHeadImage];
        person.isOpenUserInteraction = YES;
//        NSLog(person.isOpenUserInteraction ? @"MainTableVIewCell.h isOpenUserInteraction Yes" : @"MainTableVIewCell.h isOpenUserInteraction No");
        [self.navigationController pushViewController:person animated:YES];
        
        return;
    }
    
    self.coverView.hidden = NO;
    
    
}
-(void)turnToBuildFile
{
    if ([LoginTool returnToken])
    {
        
        BuildFileVC *personVC = [[BuildFileVC alloc] init];
        
        [self.navigationController pushViewController:personVC animated:YES];
        
        return;
    }
    
    self.coverView.hidden = NO;
}



#pragma mark ---MainTableVIewCellDelegate
-(void)beOnClick:(MainTableVIewCell *)cell
{
    PerSonelVC *personVC = [[PerSonelVC alloc] init];
    [self.navigationController pushViewController:personVC animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)judgeStatusWith:(NSInteger)index
{
    if(index == lastIndex)
    {
        return;
    }
    
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:index inSection:0];
    
    //滚动到选择的item
    [self.mainCollectionView selectItemAtIndexPath:indexpath
                                          animated:YES
                                    scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [UIView animateWithDuration:0.5 animations:^{
        if (index<=0) {
            
            [self btnIsSelected:YES with:NO];
        }else if(index ==1){
            [self btnIsSelected:NO with:YES];
            
        }
        
    }completion:^(BOOL finished){
    }];
    lastIndex = index;
    [self.mainCollectionView reloadData];
}


-(void)btnIsSelected:(BOOL)isRecomend with:(BOOL)isLastest{
    
    [self.recomendBtn setSelected:isRecomend];
    [self.lastestBtn  setSelected:isLastest];
    
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
static BOOL canMove=NO;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    canMove=YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    canMove=NO;
}



@end
