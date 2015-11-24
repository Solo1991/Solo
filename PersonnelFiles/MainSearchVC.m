//
//  MainSearchVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/27.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "MainSearchVC.h"

#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"


@interface MainSearchVC ()<UISearchBarDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    shareModel *shareModelData;
}
@property(strong,nonatomic)UISearchBar  *mainSearchBar;
@property(nonatomic,strong)UIButton     *cover  ;
@property(strong,nonatomic)UIView       *buttonView;
@property(strong,nonatomic)UIButton     *sexBtn;
@property(strong,nonatomic)UIButton     *zoneBtn;
@property(nonatomic,strong)UILabel      *selectZoneLabel;
@property(nonatomic,strong)UILabel      *selectSexLabel;
@property(nonatomic,strong)UIButton     *selectSex;
@property(nonatomic,strong)UIButton     *selectZone;
@property(nonatomic,strong)UITableView  *searchTableView;
@property(strong,nonatomic)HotWordsView *hotWordView;
@end

@implementation MainSearchVC

/**
 *  搜索结果tableview
 */
-(UITableView *)searchTableView
{
    if (!_searchTableView)
    {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                         mainSearchBarHeight,
                                                                         MainWidth,
                                                                         MainHeight-MainNavHeight-mainSearchBarHeight-buttonViewHeight) style:UITableViewStylePlain];
        [self.view addSubview:_searchTableView];
        _searchTableView.separatorStyle = NO;
        _searchTableView.delegate = self;
        _searchTableView.dataSource =self;
    }
    return _searchTableView;
}


/**
 *  搜索框
 */
-(UISearchBar *)mainSearchBar
{
    
    if (!_mainSearchBar)
    {
        _mainSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, MainWidth, mainSearchBarHeight)];
        _mainSearchBar.placeholder = @"输入关键字或者职业进行搜索";
        [self.view addSubview:_mainSearchBar];
        _mainSearchBar.tintColor =ThemeColor;
        _mainSearchBar.delegate = self;
        //添加默认搜索内容
//        _mainSearchBar.placeholder = @"大家都在搜：";
    }
    return _mainSearchBar;
}
//搜索热词view
-(HotWordsView *)hotWordView
{
    if (_hotWordView == nil)
    {
        _hotWordView =[[HotWordsView alloc] initWithFrame:CGRectMake(0,mainSearchBarHeight,MainWidth,MainHeight-MainNavHeight-mainSearchBarHeight -buttonViewHeight)];
        _hotWordView.delegate = self;
        [self.view addSubview:_hotWordView];
        
    }
    return _hotWordView;
}
-(UIView *)buttonView
{
    
    if (!_buttonView)
    {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               MainHeight-MainNavHeight-buttonViewHeight,
                                                               MainWidth,
                                                               buttonViewHeight)];
        _buttonView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_buttonView];
        
        
    }
    return _buttonView;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(UIButton *)cover
{
    if (!_cover)
    {
        CGRect frame = [self.mainSearchBar convertRect:self.mainSearchBar.frame toView:self.view];
        _cover =[[UIButton alloc] initWithFrame:CGRectMake(0,
                                                           CGRectGetMaxY(frame),
                                                           MainWidth,
                                                           MainHeight-CGRectGetMaxY(frame))];
        _cover.backgroundColor =[UIColor blackColor];
        _cover.alpha =0.0;
        [_cover addTarget:self action:@selector(hideCover) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cover];
    }
    
    return _cover;
}

-(void)hideCover
{
    [self.mainSearchBar resignFirstResponder];
    if ([self.mainSearchBar.text isEqualToString:@""] && !self.isSearch) {
        self.hotWordView.hidden = NO;

    }
    
}


#pragma mark - 搜索框代理方法
/**
 *  键盘弹出:搜索框开始编辑文字
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    for (id aa in [searchBar subviews])
    {
        if ([aa isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)aa;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    if ([searchBar.text isEqualToString:@""] && !self.isSearch) {
        self.hotWordView.hidden = NO;
    }
//    if (_isSearch) {
//        self.hotWordView.hidden = YES;
//    }
    
    [UIView animateWithDuration:0.5 animations:^
    {
        self.cover.alpha = 0.5;
    }];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""] && !self.isSearch) {
        
        self.hotWordView.hidden = NO;
        
    }
    if ([searchText isEqualToString:@""] && self.isSearch) {
        [self postSearch:searchText];
        self.pages = 1;
    }
    
}
/**
 *  键盘退下:搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    if (!_isSearch && [self.mainSearchBar.text isEqualToString:@""]) {
        self.hotWordView.hidden = NO;
    }
    [UIView animateWithDuration:0.5 animations:^
    {
        self.cover.alpha = 0.0;
    }];
    
//    searchBar.text = nil;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self postSearch:searchBar.text];
    self.pages = 1;
   
    self.hotWordView.hidden = YES;
   
    
    [searchBar resignFirstResponder];
    
}
#pragma mark-----获取选择的搜索热词代理实现
-(void)searchWithHotWord:(NSString *)hotWord
{
    self.mainSearchBar.text = hotWord;
    self.pages = 1;
    [self postSearch:hotWord];
    self.hotWordView.hidden = YES;
    
    
    
}

#pragma mark-----发送搜索请求
-(void)postSearch:(NSString*)Str
{
    [customActivityIndicator startAnimating];
    
    self.searchStr = Str;
    
    NSString * randId;
    if ([LoginTool returnRandId])
    {
        randId = [LoginTool returnRandId];
    }else
    {
        randId =@"";
    }
    
    if ([self.cityName isEqualToString:@"地区"]||[self.cityName isEqualToString:@"不限"]||!self.cityName) {
        self.cityName = @"";
    }
    if (!self.sexNumber)
    {
        self.sexNumber = @0;
    }
    if(!self.ageGroup)
    {
        self.ageGroup = @"";
    }
//    NSLog(@"%@",self.ageGroup);
   
    NSDictionary *para = @{@"randId"    : randId,
                           @"page"      :[NSString stringWithFormat:@"%d",self.pages],
                           @"pageSize"  :@"10",
                           @"gender"    :self.sexNumber,
                           @"keyword"   :self.searchStr,
                           @"city"      :self.cityName,
                           @"agepart"   :self.ageGroup
                           };
    
    LoadData * getSearchData = [LoadData LoadDatakWithUrl:@"/usercomment/search" WithDic:para withCount:25];
    
    getSearchData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *arr)
    {
        if (arr.count != 0) {
            self.modelArray = arr;
            
        }else
        {
            
            [[AppDelegate sharedInstance]alert:@"无相关结果" andData:@"为您推荐！" andDelegate:self];
            
        }
        if (_isSearch) {
            self.hotWordView.hidden = YES;
            
        }
        [self.searchTableView reloadData];
        
        [customActivityIndicator stopAnimating];
        
    };
    getSearchData.ReturnErrorBlock =^(NSString *callBack)
    {
        [[AppDelegate sharedInstance] setHUDHide];
        
        [[AppDelegate sharedInstance] ShowAlert:STR(@"网络不给力！！")];
        
    };
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            {
                NSString * randId;
                if ([LoginTool returnRandId])
                {
                    randId = [LoginTool returnRandId];
                }else
                {
                    randId =@"";
                }
                //搜索没有结果，请求推荐数据
                NSDictionary * para = @{@"randId"   :randId,
                                        @"page" : [NSString stringWithFormat:@"%d",1],
                                        @"pageSize"  : @"10" };
                LoadData *getProData = [LoadData LoadDatakWithUrl:@"/usercomment/pro" WithDic:para withCount:8];
                getProData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *array){
                    
                    self.modelArray = array;
                    
                    [self.searchTableView reloadData];
                    
                };
                self.pages = 1;
                _isSearch = NO;
            }
            break;
            case 1:
            break;
        default:
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //等待动画  ActivityIndicator
    UIView *titleView = [[UIView alloc] init];
    [quickMethod setSize:CGSizeMake(188, 44) with:titleView];
    self.navigationItem.titleView = titleView;
    [titleView addSubview:[customActivityIndicator returnActivityIndicator]];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 100, 44)];
    label.text = @"搜索结果";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [titleView addSubview:label];
    
    //前面已经选择搜索内容，则page =1 如果点击searchBar进入搜索界面  page = 0
    if (self.isSearch) {
        self.pages = 1;
    }else
    {
        self.pages = 0;
    }
//    NSLog(@"sex === %@ ,zone === %@",self.sexNumber,self.cityName);
    self.mainSearchBar;
    self.buttonView;
    
    self.mainSearchBarSet = [[MainSearchBar alloc] init];
    self.mainSearchBarSet.view.backgroundColor = [UIColor whiteColor];

    self.searchTableView.rowHeight = 95;
    if (!_isSearch) {
        self.hotWordView;

    }

    self.fromArray = [NSMutableArray array];
//    self.myPicker.delegate = self;
//    self.myPicker.dataSource =self;
//    [self getPickerData];
//    [self initView];
    
    
    [self setZoneButton];
    [self setSexButton];
    [self setAgeButton];

    
    if (self.isSearch)
    {
        [self postSearch:self.mainSearchBar.text];
    }
    [self initRefreshControl];
    
    
}


#pragma mark - init view
//- (void)initView
//{
//    
//    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
//    self.maskView.backgroundColor = [UIColor blackColor];
//    self.maskView.alpha = 0;
//    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
//    
//
//    self.pickerBgView.width = MainWidth;
//}
#pragma mark - get data
//- (void)getPickerData
//{
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Age.plist" ofType:nil];
//    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
//    NSArray * arr = [NSArray arrayWithArray:[self.pickerDic allKeys]];
//    
//
//    self.fromArray[0] = arr.lastObject;
//    
//    for (int count =1; count<arr.count; count++)
//    {
//        [self.fromArray addObject:arr[count-1]];
//    }
//    
//    for (int count = 0; count < arr.count; count++)
//    {
//        NSLog(@"--------%@-------%@",self.fromArray[count],arr[count]);
//    }
//    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
//    
//    
//    if (self.selectedArray.count > 0)
//    {
//        self.toArray[0] = self.selectedArray.lastObject;
//        NSLog(@"-------self.arr------%@",self.toArray[0]);
//        for (int count =1; count<arr.count; count++)
//        {
//            [self.toArray addObject:self.selectedArray[count-1]];
//        }
//    }
//    
//    
//}


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
-(void)initRefreshControl
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(footerEndRefreshing) name:@"footerEndRefreshing" object:nil];
    [self.searchTableView addFooterWithTarget:self action:@selector(addMoreDataSel)];
}


-(void)addMoreDataSel
{
    ++self.pages;
    
    [customActivityIndicator startAnimating];
    NSString * randId;
    if ([LoginTool returnRandId])
    {
        randId = [LoginTool returnRandId];
    }else{
        randId =@"";
    }
    if ([self.cityName isEqualToString:@"地区"]||[self.cityName isEqualToString:@"不限"])
    {
        self.cityName = @"";
    }
//    NSLog(@"---------%@----------%@----------%d",self.cityName,self.sexNumber,self.pages);
    NSDictionary *para = @{@"randId"    : randId,
                           @"page"      :[NSString stringWithFormat:@"%d",self.pages],
                           @"pageSize"  :@"10",
                           @"gender"    :self.sexNumber,
                           @"keyword"   :self.searchStr,
                           @"city"      :self.cityName,
                           @"agepart"   :self.ageGroup
                           };
    

    
    LoadData * getSearchData = [LoadData LoadDatakWithUrl:@"/usercomment/search" WithDic:para withCount:25];
    
    getSearchData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *arr)
    
    {
        
        if (arr.count == 0) {
            [[AppDelegate sharedInstance] ShowAlert:@"已无更多数据"];

        }
        
        [self.modelArray addObjectsFromArray:arr];
        
        [self.searchTableView reloadData];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
        
        
        
        [customActivityIndicator stopAnimating];
        
    };
    getSearchData.ReturnErrorBlock =^(NSString *callBack)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"footerEndRefreshing" object:nil];
        
        
        
        [[AppDelegate sharedInstance] ShowAlert:STR(@"网络不给力！！")];
        
         [customActivityIndicator stopAnimating];
    };
}

-(void)footerEndRefreshing
{
    [self.searchTableView footerEndRefreshing];
}

/**
 *  设置选择地区按钮
 */
-(void)setZoneButton
{
    self.zoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainWidth/3, 0, MainWidth/3,buttonViewHeight)];
    [self.buttonView addSubview:self.zoneBtn];
    [self.zoneBtn setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
    
    self.selectZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, MainWidth/3, 15)];
    
    if ([self.cityName isEqualToString:@""])
    {
       self.selectZoneLabel.text = @"地区";
       
    }else
    {
       self.selectZoneLabel.text = self.cityName; 
    }
    
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
-(void)setSexButton
{
    self.sexBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainWidth/3,buttonViewHeight)];
    [self.buttonView addSubview:self.sexBtn];
    [self.sexBtn setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
    
    self.selectSexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, MainWidth/3, 15)];
    
    
    
        if ([self.sexNumber  isEqual: @0])
        {
            self.selectSexLabel.text = @"性别";
        }
        if ([self.sexNumber  isEqual: @-1])
        {
            self.selectSexLabel.text = @"女";
        }
        if ([self.sexNumber  isEqual: @1])
        {
            self.selectSexLabel.text = @"男";
        }
    
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

-(void)selectZoneSel
{

    MTCityViewController * mtCity = [[MTCityViewController alloc] init];
    mtCity.ReturnTextBlock =^(NSString *cityName)
    {
//        NSLog(@"city  = %@",cityName);
        if ([cityName isEqualToString:@"不限"])
        {
            self.cityName = @"";
        }else{
            self.cityName = cityName;
        }
        
        self.selectZoneLabel.text = cityName;
        self.isSearch = YES;
        [self postSearch:self.mainSearchBar.text];
        self.pages = 1;
    };
    [self presentViewController:mtCity animated:YES completion:nil];
}
-(void)selectSexSel
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"不限", nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            // 注销账号
        case 0:
            self.selectSexLabel.text = @"男";
            self.sexNumber = @1;
            self.isSearch = YES;
            break;
            // 更换账号
        case 1:
            self.selectSexLabel.text = @"女";
            self.sexNumber = @-1;
            self.isSearch = YES;
            break;
        case 2:
            self.selectSexLabel.text = @"不限";
            self.sexNumber = @0;
            self.isSearch = YES;
            break;
    }
    
    [self postSearch:self.mainSearchBar.text];
}



#pragma mark 选择年龄段
-(void)setAgeButton
{
    self.ageBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainWidth/3*2, 0, MainWidth/3,buttonViewHeight)];
    [self.buttonView addSubview:self.ageBtn];
    [self.ageBtn setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
    
    self.selectAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, MainWidth/3, 15)];
    if (self.ageGroup)
    {
        NSString *fromindex=[self.ageGroup substringToIndex:4];
       

        NSString *toindex=[self.ageGroup substringFromIndex:4];
        if ([toindex isEqualToString:@"0000"]) {
            toindex = @"至今";
        }
//        NSLog(@"%@-%@",toindex,fromindex);
        self.selectAgeLabel.text = [NSString stringWithFormat:@"%@-%@",fromindex,toindex];
    }else
    {
        self.selectAgeLabel.text = @"年龄段";
    }
    
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
}
-(void)sureBtn:(NSString *)sureStr
{
    NSString *fromindex=[sureStr substringToIndex:4];
    NSString *toindex=[sureStr substringFromIndex:4];
    if ([toindex isEqualToString:@"0000"]) {
        toindex = @"至今";
    }
    self.ageGroup = sureStr;
    self.selectAgeLabel.text = [NSString stringWithFormat:@"%@-%@",fromindex,toindex];
    self.isSearch = YES;
    [self postSearch:self.mainSearchBar.text];
}
-(void)cancelBtn:(NSString *)cancelStr
{
    self.selectAgeLabel.text =cancelStr;
   
}
#pragma mark - UIPicker Delegate.0
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
//    if (component == 0)
//    {
//        self.selectedArray = [self.pickerDic objectForKey:[self.fromArray objectAtIndex:row]];
//        
//        if (self.selectedArray.count > 0)
//        {
//            self.toArray = self.selectedArray ;
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
//
//- (IBAction)cancelBtn:(id)sender
//{
//    self.selectAgeLabel.text =@"年龄段";
//    [self hideMyPicker];
//}
//
//- (IBAction)sureBtn:(id)sender
//{
//    self.selectAgeLabel.text = [NSString stringWithFormat:@"%@-%@",[self.fromArray objectAtIndex:[self.myPicker selectedRowInComponent:0]]
//                                ,[self.toArray objectAtIndex:[self.myPicker selectedRowInComponent:1]]];
//    [self hideMyPicker];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"MainTableVIewCell";

    MainNavModel *model = self.modelArray[indexPath.row];
    MainTableVIewCell * cell = [self.searchTableView dequeueReusableCellWithIdentifier:cellId];
    
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
        MainNavModel    *model = self.modelArray[indexRow];
        PerSonelVC      *personVC = [[PerSonelVC alloc] init];
        personVC.randId = model.randId;
        personVC.headImageUrl = [NSURL URLWithString:model.userImg];
        personVC.name = model.username;
        personVC.model = model;
 
        
        [self.navigationController pushViewController:personVC animated:YES];
        
    };

    
    /**
     *  复制微信信息
     */
    cell.ReturnCopyWeChatBlock = ^(NSInteger indexRow)
    {
        MainNavModel *model = self.modelArray[indexRow];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.weChat;
            
        [quickMethod copyWechat:model.weChat];
    };
    
    
    if ([model.userGender  isEqual: @0])
    {
        cell.userGender.image = [UIImage imageNamed:@"性别-男.png"];
//        NSLog(@"男生");
    }else
    {
        cell.userGender.image = [UIImage imageNamed:@"性别-女.png"];
    }
    cell.isCanBeHit = YES;
    cell.model = model;
    cell.indexRow = indexPath.row;
    
    cell.isOpenUserInteraction =self.isOpenUserInteraction;
//    NSLog(self.isOpenUserInteraction ? @"MainTableVIewCell.h isOpenUserInteraction Yes" : @"MainTableVIewCell.h isOpenUserInteraction No");
    
    

    
    
    return cell;
}




#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MainNavModel *model = self.modelArray[indexPath.row];
    UserInfoVC *info = [[UserInfoVC alloc] init];
    
    info.model      = model.detailModel;
    info.IuserImg   = model.userImg;
    info.IuserName  = model.username;
    info.IuserSex   = model.userGender;
    
    [self.navigationController pushViewController:info animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
