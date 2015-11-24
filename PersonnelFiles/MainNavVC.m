//
//  MainNavVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "MainNavVC.h"
#import "MainViewVC.h"
@interface MainNavVC ()

@end

@implementation MainNavVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithRootViewController:[[MainViewVC alloc] init]];
    
   
    
        // Do any additional setup after loading the view from its nib.
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
