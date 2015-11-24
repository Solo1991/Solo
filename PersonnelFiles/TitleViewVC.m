//
//  TitleViewVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/21.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "TitleViewVC.h"

@interface TitleViewVC ()
{
    CGSize maxSize;
    CGSize labelSize;
}

@end

@implementation TitleViewVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.headImage.layer setCornerRadius:25];
    [self.headImage.layer setBorderWidth:0.5];
    [self.headImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.headImage.layer setMasksToBounds:YES];
    


   


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
//    self.hopeLabel.height = labelSize.height;
    //调整爱好，工作，希望的宽度
//    self.hopeLabel.width  = self.view.width - 20;
//    self.hobbyLabel.width = self.view.width - 10 - self.genderLabel.x;
//    self.idoLabel.width = self.view.width - 10 - self.genderLabel.x;
//    //爱好，工作，希望 根据内容自适应高度
//    CGFloat hopeLabelHeight = self.hopeLabel.height;
//    CGFloat idoLabelHeight = self.idoLabel.height;
//    CGFloat hobbyLabelHeight = self.hobbyLabel.height;
    self.visitLabel.x = MainWidth-100;
//    //调整标题与内容的偏移 和 高度
//    self.hobbyLabel.y = self.hobbyTitleLabel.y+3;
//    self.idoTitleLabel.y = CGRectGetMaxY(self.hobbyLabel.frame)+5;
//    self.idoLabel.y = self.idoTitleLabel.y +3;
//    self.hopeLabel.y = CGRectGetMaxY(self.idoLabel.frame)+5;
//    self.beFriendLabel.y = CGRectGetMaxY(self.hopeLabel.frame)+5;
//    self.weChatBtn.y = CGRectGetMaxY(self.beFriendLabel.frame)+5;
   

    
}

@end
