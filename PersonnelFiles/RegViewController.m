//
//  RegViewController.m
//  PersonnelFiles
//
//  Created by 麦兜 on 15/7/29.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "RegViewController.h"
#import "LoginTool.h"
#import "AppDelegate.h"
#import "LoadData.h"

@interface RegViewController ()

@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (IBAction)toDone:(id)sender{
    if ([self.txt_name.text length] <=0) {
        [[AppDelegate sharedInstance] alert:STR(@"请填写账号")];
        return;
    }
    
    if ([self.txt_psd.text length] <=0) {
        [[AppDelegate sharedInstance] alert:STR(@"请填写密码！！")];
        return;
    }
    
    if (![self.txt_psd.text isEqualToString:self.txt_psd_re.text]) {
        [[AppDelegate sharedInstance] alert:STR(@"密码不一致")];
        return;
    }
    
//    NSDictionary * para = @{@"username"   :self.txt_name.text,
//                            @"token"  : self.txt_psd.text};
//    [[LoginTool sharedInstance] postRequestWith:para];
    [self reg];
}

- (void)reg{
    NSDictionary *para = @{@"username"   :self.txt_name.text,
                            @"token"  : self.txt_psd.text};
    __weak LoadData *getLoginData = [LoadData LoadDatakWithUrl:@"/wxlog" WithDic:para withCount:2];
//    NSLog(@"dict == %@",dict);
    getLoginData.ReturnCodeBlock = ^(NSNumber *code)
    {
        //检查失败
        if([code intValue] == 0)
        {
            //登陆失败-->注册
            LoadData *getexamineData = [LoadData LoadDatakWithUrl:@"/wxreg" WithDic:para withCount:1];
            getexamineData.ReturnCodeBlock = ^(NSNumber *twocode)
            {
                //注册失败--->提示用户-->放弃挣扎
                if ([twocode intValue] == 0)
                {
                    [[AppDelegate sharedInstance] alert:@"失败"];
                    
                }   //注册成功--->跳转登陆
                else if ([twocode intValue] ==1)
                {
                    [[AppDelegate sharedInstance] alert:@"注册成功"];
                    [self toCancel:nil];
                }
                else
                {
                    
                }
                
            };
            //登陆成功-->--->提示用户-->保存数据
        }else if ([code intValue] ==1)
        {
            
           [[AppDelegate sharedInstance] alert:@"已注册过"];
        }
    };

}

- (IBAction)toCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
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
