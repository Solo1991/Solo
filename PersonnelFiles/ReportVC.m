//
//  ReportVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/7/2.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "ReportVC.h"
#import "quickMethod.h"
@interface ReportVC ()
{
    NSIndexPath *index;
}
@property(nonatomic,strong)NSMutableArray *rensonArr;

@property(nonatomic,strong)NSString * feedBackStr;
@end

@implementation ReportVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"举报";
    
    self.rensonArr = [NSMutableArray arrayWithObjects:@"色情低俗", @"广告骚扰",@"政治敏感",@"谣言",@"诈骗骗钱",@"违法（暴力恐怖，违禁品）",@"侵权举报（诽谤，抄袭，冒用...）",@"售假投诉", nil];
    
    UIView * footView = [[UIView alloc] init];
    [quickMethod setSize:CGSizeMake(MainWidth, 200) with:footView];
    self.tableView.tableFooterView = footView;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, MainWidth-40, 100)];
    [footView addSubview:textView];
    
    
    
    UIButton* buildFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickMethod setSize:CGSizeMake(40, 20) with:buildFileBtn];
    [buildFileBtn addTarget:self action:@selector(feedBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [buildFileBtn setTitle:@"发送" forState:UIControlStateNormal];
    [buildFileBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    buildFileBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    buildFileBtn.layer.borderWidth = 1;
    buildFileBtn.layer.cornerRadius = 5;
    [buildFileBtn.layer setMasksToBounds:YES];
    buildFileBtn.titleLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buildFileBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}


-(void)feedBackBtn
{

    
    if (!self.feedBackStr)
    {
        [[AppDelegate sharedInstance] ShowAlert:@"请选择举报原因"];
        return;
    }
    
    NSString *str;
    if (!self.textView.text)
    {
        str = @"";
    }else
    {
        str = self.textView.text;
    }
    
    NSDictionary *para = @{
                           @"retype"    :self.feedBackStr,
                           @"body"      :str,
                           @"code"      :@"",
                           @"con"       :@"",
                           @"randId"    :[LoginTool returnRandId],
                           @"berandId"  :self.berandId,
                           @"beid"      :self.beid
                           };
    
    LoadData *reportData = [LoadData LoadDatakWithUrl:@"/usercomment/report" WithDic:para withCount:16];
    reportData.ReturnCodeBlock = ^(NSNumber *callBack)
    {
        if([callBack intValue]==1)
        {
            [[AppDelegate sharedInstance] ShowAlert:@"举报成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [[AppDelegate sharedInstance] ShowAlert:@"每份档案只能举报一次哦~~"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"请选择举报原因";
            break;
        case 1:
            return @"请举证（选填)";
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 8;
            break;
        default:
            break;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    reportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
    if (!cell)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"reportCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    cell.textLabel.text = self.rensonArr[indexPath.row];
        return cell;
}


#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.feedBackStr = self.rensonArr[indexPath.row];
    if (index)
    {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
        cell.accessoryType =  UITableViewCellAccessoryNone ;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType =  UITableViewCellAccessoryCheckmark ;
    
    
    index = indexPath;
}


@end
