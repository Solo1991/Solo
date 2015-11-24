//
//  MTCityViewController.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTCityGroup.h"
#import "MJExtension.h"
#import "MTConst.h"
#import "UIView+AutoLayout.h"
#import "MTCitySearchResultViewController.h"
#import "LoginTool.h"
const int MTCoverTag = 999;

@interface MTCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *cityGroups;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)coverClick;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) MTCitySearchResultViewController *citySearchResult;
@end

@implementation MTCityViewController

- (MTCitySearchResultViewController *)citySearchResult
{
    if (!_citySearchResult) {
        MTCitySearchResultViewController *citySearchResult = [[MTCitySearchResultViewController alloc] init];
        [self addChildViewController:citySearchResult];
        self.citySearchResult = citySearchResult;
        
        [self.view addSubview:self.citySearchResult.view];
        [self.citySearchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.citySearchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:15];
    }
    return _citySearchResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MTNotificationCenter addObserver:self selector:@selector(ChangeCityName:) name:MTCityDidChangeNotification object:nil];
    // 基本设置
    self.title = @"切换城市";

//    self.tableView.sectionIndexBackgroundColor = [UIColor redColor];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    // 加载城市数据
    self.cityGroups = [MTCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    
    self.searchBar.tintColor = ThemeColor;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 50)];
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 30)];
    [titleView addSubview:locationLabel];
    UIImageView *locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    locationImage.image = [UIImage imageNamed:@"定位.png"];
    [titleView addSubview:locationImage];
    

    if (![LoginTool returnCity])
    {
        locationLabel.text = @"   定位中...";
    }else{
        locationLabel.text = [NSString stringWithFormat:@"  当前城市： %@",[LoginTool returnCity]];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationAddress)];
    [titleView addGestureRecognizer:tap];
    
    self.tableView.tableHeaderView = titleView;
}

-(void)ChangeCityName:(NSNotification *)notification{
    
//    NSLog(@"cityName = %@",notification.userInfo[MTSelectCityName]);
    // 发出通知
    if (self.ReturnTextBlock) {
        self.ReturnTextBlock(notification.userInfo[MTSelectCityName]);
        [[NSUserDefaults standardUserDefaults]setObject:notification.userInfo[MTSelectCityName] forKey:@"city"];
    }
}
-(void)locationAddress{
    if (self.ReturnTextBlock) {
        self.ReturnTextBlock([LoginTool returnCity]);
    }
    [self close];
}
- (IBAction)bactBtn:(id)sender {
    [self close];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 搜索框代理方法
/**
 *  键盘弹出:搜索框开始编辑文字
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 1.隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    
    // 3.显示搜索框右边的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 4.显示遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.5;
    }];
}

/**
 *  键盘退下:搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1.显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    
    // 3.隐藏搜索框右边的取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    // 4.隐藏遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.0;
    }];
    
    // 5.移除搜索结果
    self.citySearchResult.view.hidden = YES;
    searchBar.text = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

/**
 *  搜索框里面的文字变化的时候调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.citySearchResult.view.hidden = NO;
        self.citySearchResult.searchText = searchText;
    } else {
        self.citySearchResult.view.hidden = YES;
    }
}

/**
 *  点击遮盖
 */
- (IBAction)coverClick {
    [self.searchBar resignFirstResponder];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MTCityGroup *group = self.cityGroups[section];
    return group.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    MTCityGroup *group = self.cityGroups[indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"    %@",group.cities[indexPath.row]];
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MTCityGroup *group = self.cityGroups[section];
    return group.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityGroups valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTCityGroup *group = self.cityGroups[indexPath.section];
    
    // 发出通知
    if (self.ReturnTextBlock) {
        self.ReturnTextBlock(group.cities[indexPath.row]);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end