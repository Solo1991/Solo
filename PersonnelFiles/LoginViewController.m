//
//  LoginViewController.m
//  PersonnelFiles
//
//  Created by 麦兜 on 15/7/28.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "LoadData.h"
#import "LoginTool.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;

}

- (IBAction)toLogin:(id)sender{
    NSDictionary *para = @{@"username"   :self.txt_name.text,
                           @"token"  : self.txt_psd.text};
    
    __weak LoadData *getLoginData = [LoadData LoadDatakWithUrl:@"/wxlog" WithDic:para withCount:2];
//    NSLog(@"dict == %@",dict);
    getLoginData.ReturnCodeBlock = ^(NSNumber *code)
    {
        //检查失败
        if([code intValue] == 0)
        {
            [[AppDelegate sharedInstance] alert:@"失败"];
        }else if ([code intValue] ==1)
        {
            getLoginData.ReturnLoadDataWithUserModelBlock = ^(userModel *model)
            {
                [LoginTool sharedInstance].para = para;
                [[LoginTool sharedInstance] setNameAndImage:model];
                [self toCancel:nil];
            };
        }
    };
}

- (IBAction)toCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toReg:(id)sender{
    RegViewController *reg = [[RegViewController alloc] initWithNibName:@"RegViewController" bundle:nil];
    [self.navigationController pushViewController:reg animated:YES];
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
