//
//  MainTableVIewCell.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "MainTableVIewCell.h"
#import "LoginTool.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "quickMethod.h"
@implementation MainTableVIewCell
{
    UILabel     *animationLab;
    UIImageView *zanImage;
    UIImageView *messageImage;
    UIImageView *shareImage;
    float imgWidth;
}

- (void)awakeFromNib
{
    
    [self.userImage.layer setCornerRadius:23];
    [self.userImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.userImage.layer setBorderColor:(__bridge CGColorRef)([UIColor whiteColor])];
    [self.userImage.layer setBorderWidth:1.0];
    [self.userImage.layer setMasksToBounds:YES];

    if (![[LoginTool returnjudgeKey]  isEqual:@"1"])
    {
        self.weChatCopyBtn.hidden = YES;
    }
    
    imgWidth = (MainWidth-10)/6-8;
    float labWidth = imgWidth +16;
    zanImage = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth, 5, 15, 15)];
    
    zanImage.contentMode =UIViewContentModeScaleAspectFit;
    [self.zan addSubview:zanImage];
    
    

    
    messageImage = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth, 5, 15, 15)];
    
    messageImage.contentMode =UIViewContentModeScaleAspectFit;
    [self.comment addSubview:messageImage];
    
    shareImage= [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth, 5, 15, 15)];
    shareImage.image = [UIImage imageNamed:@"分享.png"];
    shareImage.contentMode =UIViewContentModeScaleAspectFit;
    [self.send addSubview:shareImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToPersonal)];
    
    [self.userImage addGestureRecognizer:tap];
    
    self.zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(labWidth,10, imgWidth-20, 10)];
    self.zanLabel.font = [UIFont systemFontOfSize:10];
    self.zanLabel.textColor = [UIColor lightGrayColor];
    [self.zan addSubview:self.zanLabel];
    
    animationLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65, 18)];
    animationLab.textAlignment = NSTextAlignmentRight;
    animationLab.text = @"+1";
    animationLab.font = [UIFont boldSystemFontOfSize:11];
    animationLab.textColor = ThemeColor;
    [self.zan addSubview:animationLab];
    animationLab.alpha =0;
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(labWidth,10, imgWidth-20, 10)];
    self.messageLabel.font = [UIFont systemFontOfSize:10];
    self.messageLabel.textColor = [UIColor lightGrayColor];
    [self.comment addSubview:self.messageLabel];
    
    self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(labWidth,10, imgWidth-20, 10)];
    self.shareLabel.font = [UIFont systemFontOfSize:10];
    self.shareLabel.textColor = [UIColor lightGrayColor];
    [self.send addSubview:self.shareLabel];
    
}


-(void)layoutSubviews
{

    self.time.text = [quickMethod quickGetTimeFormWith:[quickMethod transformTimeToString:self.model.createdAt]];
    
    
    self.userName.text = self.model.username;
    [self.userName sizeToFit];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.model.userImg] placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];
    if ([self.model.detailModel.bdage intValue] == -1) {
        self.iWant.text         = [NSString stringWithFormat:@"我是%@，年龄保密哦，爱好是%@，我想%@",self.model.detailModel.bdjob,self.model.detailModel.bdhobby,self.model.bddo];
    }else{
        self.iWant.text         = [NSString stringWithFormat:@"我是%@，今年%@，爱好是%@，我想%@",self.model.detailModel.bdjob,self.model.detailModel.bdage ,self.model.detailModel.bdhobby,self.model.bddo];
    }
    //个人中心引用   宽度变化
//    self.iWantWidthToSuperView.constant = 65;
    self.iWant.numberOfLines = 2;
    [self.iWant sizeToFit];
    self.zanLabel.text      = [NSString stringWithFormat:@"%@",self.model.collect];
    self.messageLabel.text  = [NSString stringWithFormat:@"%@",self.model.replys];
    self.shareLabel.text    = [NSString stringWithFormat:@"%@",self.model.parised];
    
    /**
     *  是否被点赞过
     */
    if ([self.model.isCollect  isEqual:@1])
    {
        zanImage.image = [UIImage imageNamed:@"赞1.png"];
        [self.zan setEnabled:NO];
    }else{
        zanImage.image = [UIImage imageNamed:@"赞0.png"];
        [self.zan setEnabled:YES];
    }
    /**
     *  是否被评论过
     */
    if ([self.model.isReply  isEqual:@1])
    {
        messageImage.image = [UIImage imageNamed:@"消息1.png"];
    }else
    {
        messageImage.image = [UIImage imageNamed:@"消息0.png"];
    }
    
    /**
     *  是否被分享过
     */
//    if([self.model.isParised isEqual:@1])
//    {
//        shareImage.image = [UIImage imageNamed:@""];
//    }else
//    {
//        shareImage.image = [UIImage imageNamed:@""];
//    }
    
    
    [self.removeBtn setHidden:!self.isOpenUserInteraction||self.isCanBeHit];
    if (!self.isCanBeHit)
    {
        [self.removeBtn addTarget:self action:@selector(removeSel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(self.isOpenUserInteraction||self.isCanBeHit)
    {
        [self.upToBtn setHidden:!self.isShowHideBtn];
        [self.upToBtn addTarget:self action:@selector(upToBtnSel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.userImage setUserInteractionEnabled:self.isCanBeHit];
    
    
    if ([self.model.userGender  isEqual: @1])
    {
        self.userGender.image = [UIImage imageNamed:@"性别-男.png"];
//        NSLog(@"男生");
    }else if([self.model.userGender isEqual:@-1])
    {
        self.userGender.image = [UIImage imageNamed:@"性别-女.png"];
    }else
    {
        self.userGender.image = [UIImage imageNamed:@"boyAndGirl.png"];
    }
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(void)turnToPersonal
{
    self.ReturnHeadBtnBlock(self.indexRow);
}

-(void)upToBtnSel
{
    testPrint
    if (self.ReturnUpDateBtnBlock)
    {
        self.ReturnUpDateBtnBlock(self.indexRow);
    }
}
- (IBAction)zanBtn:(id)sender
{
    if (![LoginTool returnName])
    {
        [[AppDelegate sharedInstance] ShowAlert:@"想点赞请先登录哦~~"];
        return;
    }

    
    
    [UIView animateWithDuration:0.7 animations:^{
        animationLab.alpha =1;
        animationLab.transform = CGAffineTransformTranslate(animationLab.transform, 0, -25);
        animationLab.alpha =0;
    } completion:^(BOOL finished) {
        animationLab.transform = CGAffineTransformIdentity;
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^(void)
    {
        self.zanLabel.text      = [NSString stringWithFormat:@"%d",[self.model.collect intValue]+1];
        zanImage.image          =[UIImage imageNamed:@"赞1.png"];
        zanImage.frame          = CGRectMake(imgWidth-10, 0, 25, 25);
    }completion:^(BOOL finished)
    {
        zanImage.frame = CGRectMake(imgWidth, 5, 15, 15);
        [self.zan setEnabled:NO];
    }];
    self.ReturnZanBtnBlock(self.indexRow);
    
}

/**
 *  复制wechat按钮
 */
- (IBAction)copyWechatBtn:(id)sender
{
    if (self.ReturnCopyWeChatBlock)
    {
        self.ReturnCopyWeChatBlock(self.indexRow);
    }
}

/**
 *  评论按钮
 */
- (IBAction)messageBtn:(id)sender
{
    self.ReturnMessageBtnBlock(self.indexRow);
}


/**
 *  分享
 */
- (IBAction)shareBtn:(id)sender
{
    self.ReturnShareBtnBlock(self.indexRow);
}

/**
 *  取消个人发布或点赞
 */
-(void)removeSel
{
    if (self.ReturnremoveBtnBlock)
    {
        self.ReturnremoveBtnBlock(self.indexRow,self.indexPath);
    }
}
@end
