//
//  BuildFileFootVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/26.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "BuildFileFootVC.h"

@interface BuildFileFootVC ()
@property(nonatomic,strong)UILongPressGestureRecognizer *longpressGesutre;
@end

@implementation BuildFileFootVC

-(UILongPressGestureRecognizer *)longpressGesutre
{
    if (!_longpressGesutre)
    {
        //6、长按手势
        _longpressGesutre=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongpressGesture)];
        
        //长按时间为1秒
        _longpressGesutre.minimumPressDuration=1;
        //允许15秒中运动
        _longpressGesutre.allowableMovement=15;
        //所需触摸1次
        _longpressGesutre.numberOfTouchesRequired=1;
    }
    return _longpressGesutre;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSel)];
    [self.firstImageView addGestureRecognizer:tap];
    [self.secondImageView addGestureRecognizer:tap];
    [self.thirdImageView addGestureRecognizer:tap];
    [self.fourImageView addGestureRecognizer:tap];
    

}

-(void)tapSel{
    testPrint
}

-(void)handleLongpressGesture{
    testPrint
}
- (IBAction)sendBtn:(id)sender {
    testPrint
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
