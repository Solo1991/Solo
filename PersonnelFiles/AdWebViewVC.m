
//
//  AdWebViewVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/24.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "AdWebViewVC.h"

@interface AdWebViewVC ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation AdWebViewVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight-64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.adWebViewUrl]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
