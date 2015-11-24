//
//  LoadVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/23.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "LoadVC.h"

@interface LoadVC ()

@end

@implementation LoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.loadImage];
    int height = MainHeight;
    switch (height) {
        case 480:self.LoadImgHeight.constant = 68;break;
        case 568:self.LoadImgHeight.constant = 75;break;
        case 667:self.LoadImgHeight.constant = 85;break;
        case 736:self.LoadImgHeight.constant = 95;break;

            
        default:
            break;
    }
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
