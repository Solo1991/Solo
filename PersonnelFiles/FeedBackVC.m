//
//  FeedBackVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/16.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "FeedBackVC.h"
#import "LoadData.h"
#import "MBProgressHUD.h"
#import "LoginTool.h"
#import "AppDelegate.h"
#import "quickMethod.h"
@interface FeedBackVC ()<UITextViewDelegate,MBProgressHUDDelegate>

@end

@implementation FeedBackVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"建议反馈";
    
    self.feedBackText.delegate = self;
    
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
    [self.feedBackText resignFirstResponder];
    
    if ([self VefityWith:self.feedBackText.text])
    {
        NSDictionary * para = @{@"body"   :self.feedBackText.text,
                                @"code" : @"",
                                @"con"  : [LoginTool returnRandId] };
        
        LoadData*feedBackData =  [LoadData LoadDatakWithUrl:@"/feedback/create" WithDic:para withCount:17];
        
        feedBackData.ReturnStrBlock = ^(NSString * callBack)
        {
            
            [[AppDelegate sharedInstance] ShowAlert:callBack];
            
            self.feedBackText.text = @"";
        };
    }
}

-(BOOL)VefityWith:(NSString*)text
{
    
    if (![[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length])
    {
        [[AppDelegate sharedInstance] ShowAlert:@"请完善反馈信息"];
        return NO;
    }
    return YES;
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.feedBackText resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    self.feedBackText.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
