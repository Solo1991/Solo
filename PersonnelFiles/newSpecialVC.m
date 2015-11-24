//
//  newSpecialVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "newSpecialVC.h"
#import "MainNavVC.h"
#import "MainViewVC.h"
#define MainWidth       [UIScreen mainScreen].bounds.size.width
#define MainHeight      [UIScreen mainScreen].bounds.size.height
@interface newSpecialVC ()

@end

@implementation newSpecialVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"new"];
    self.SpecScrollView.contentSize = CGSizeMake(MainWidth*4, 0);
    self.SpecScrollView.showsHorizontalScrollIndicator =NO;
    self.SpecScrollView.pagingEnabled = YES;
    self.SpecScrollView.bounces = NO;
    for (int i = 0; i<4; i++)
    {
        UIImageView *SpecImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*MainWidth, 0, MainWidth, MainHeight)];

        SpecImageView.tag = i;
        [self.SpecScrollView addSubview:SpecImageView];
        
   
        switch (SpecImageView.tag)
        {
            case 0:
                [SpecImageView setImage:[UIImage imageNamed:@"newSpecial-1.png"]];
                break;
            case 1:
                [SpecImageView setImage:[UIImage imageNamed:@"newSpecial-2.png"]];
                break;
            case 2:
                [SpecImageView setImage:[UIImage imageNamed:@"newSpecial-3.png"]];
                break;
            case 3:
                [self setFourImageView:SpecImageView];

                break;
            default:
                [SpecImageView setBackgroundColor:[UIColor blueColor]];
            break;
        }
    }

}

-(void)setFourImageView:(UIImageView*)imageView
{
    [imageView setImage:[UIImage imageNamed:@"newSpecial-4.png"]];
    imageView.userInteractionEnabled =YES;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, MainHeight-140, MainWidth-200, 40)];
    [imageView addSubview:btn];
    [btn setBackgroundColor: [UIColor whiteColor]];
    [btn.layer setCornerRadius:5];
    [btn setTitleColor:[UIColor colorWithRed:137.0/255 green:58.0/255 blue:34.0/255 alpha:1] forState:UIControlStateNormal];
    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(turnToMainVC) forControlEvents:UIControlEventTouchUpInside];
}

-(void)turnToMainVC
{
    MTCityViewController *city = [[MTCityViewController alloc] init];
    city.ReturnTextBlock =^(NSString *cityName)
    {
       // self.view.window.rootViewController = [[MainNavVC alloc] initWithRootViewController:[[MainViewVC alloc] init]];
    };
    
    [self presentViewController:city animated:YES completion:nil];
    self.view.window.rootViewController = [[MainNavVC alloc] initWithRootViewController:[[MainViewVC alloc] init]];
    self.view.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
