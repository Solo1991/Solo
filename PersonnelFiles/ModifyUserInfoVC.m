//
//  ModifyUserInfoVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/20.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "ModifyUserInfoVC.h"
#import "LoginTool.h"
#import "LoadData.h"
#import "userModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "quickMethod.h"

@interface ModifyUserInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;

@property (weak, nonatomic) IBOutlet UIImageView *userGender;

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UIScrollView *ModifyUserInfoScrollView;

@property(nonatomic,strong) UIImage *selectImage;
@property(nonatomic,strong) UILabel *sexLabel;
@end

@implementation ModifyUserInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageUrlSel:) name:@"postSeccess" object:nil];
    self.title = @"个人资料";
    
    self.sexNumber = @0;
    
    [self.selectSexBtn addTarget:self action:@selector(selectSexSelMo) forControlEvents:UIControlEventTouchUpInside];
    [quickMethod doCornerRadiusWith:self.selectSexBtn WithRadius:5 WithBorderWidth:0.5 WithColor:[UIColor lightGrayColor]];
    
    self.sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.selectSexBtn.width-10, self.selectSexBtn.bounds.size.height)];
    self.sexLabel.text = @"保密";
    self.sexLabel.font = [UIFont systemFontOfSize:15];
    [self.selectSexBtn addSubview:self.sexLabel];
    self.sexLabel.textAlignment = NSTextAlignmentLeft;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    [self.ModifyUserInfoScrollView addGestureRecognizer:tap];
    
    
    self.ModifyUserInfoScrollView.contentSize = CGSizeMake(MainWidth, MainHeight +50);
    
    
    UITapGestureRecognizer *userHeadImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage)];
    [self.userHeadImage addGestureRecognizer:userHeadImage];
    
    NSDictionary *para = @{@"token":[LoginTool returnToken]};
    LoadData * getUserInfo = [LoadData LoadDatakWithUrl:@"/wxlog" WithDic:para withCount:2];
    getUserInfo.ReturnLoadDataWithUserModelBlock = ^(userModel *model)
    {
        if ([model.gender integerValue] ==1)
        {
            self.sexLabel.text = @"帅哥";
            [self.selectSexBtn setEnabled:NO];
        }else if ([model.gender integerValue] ==0)
        {
            self.sexLabel.text = @"保密";
            [self.selectSexBtn setEnabled:YES];
        }else
        {
            self.sexLabel.text = @"美女";
            [self.selectSexBtn setEnabled:NO];
        }
        
        NSUserDefaults *userGender = [NSUserDefaults standardUserDefaults];
        [userGender setObject:model.gender forKey:@"gender"];
        [userGender synchronize];
        
    };
    
    /**
     *  设置 头像
     */
    [self.userHeadImage sd_setImageWithURL:[LoginTool returnHeadImage] placeholderImage:[UIImage imageNamed:@"个人中心-头像.png"]];
    [self.userHeadImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.userHeadImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.userHeadImage.layer setBorderWidth:1];
    [self.userHeadImage.layer setCornerRadius:30];
    [self.userHeadImage.layer setMasksToBounds:YES];
    /**
     *  设置昵称
     */
    self.userName.text = [LoginTool returnName];
    
    // 自定义评论按钮
    UIButton * commentB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    commentB.frame = CGRectMake(0, 0, MainWidth/7.5, 25);
    [commentB setBackgroundColor:[UIColor clearColor]];
    [commentB.layer setCornerRadius:6];
    [commentB.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [commentB.layer setBorderWidth:1.0];
    [commentB.layer setMasksToBounds:YES];
    [commentB setTitle:@"发送" forState:UIControlStateNormal];
    [commentB addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*sendBtn = [[UIBarButtonItem alloc]initWithCustomView:commentB];
    self.navigationItem.rightBarButtonItems=@[sendBtn];
    
    
    self.userName.width = MainWidth -160;
}

-(void)changeHeadImage
{
    
    [self.view endEditing:YES];
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"是否修改头像"
                                                contentText:@"点击【修改头像】可编辑头像”"
                                            leftButtonTitle:@"暂不修改"
                                           rightButtonTitle:@"修改头像"];
    [alert show];
    alert.leftBlock = ^()
    {
    };
    alert.rightBlock = ^()
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])////判断是否支持相册
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            //[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePicker.navigationBar setBarStyle:UIBarStyleBlack];
            [imagePicker setDelegate:self];
            [imagePicker setAllowsEditing:NO];
            //显示Image Picker
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else
        {
//            NSLog(@"Album is not available.");
            [[AppDelegate sharedInstance] ShowAlert:STR(@"未开启相册权限")];
        };
    };
    alert.dismissBlock = ^()
    {

    };

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


# pragma mark -imagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.userHeadImage.image =self.selectImage;
}


-(void)resignKeyBoard
{
    [self.userName resignFirstResponder];
}
-(void)sendPhoto
{
    
    

    
        if ([self VefityWithName:self.userName.text With:@"姓名"])
        {
                            [[AppDelegate sharedInstance] showTextDialog:@"正在发送"];
                            
                            NSString *bascCode;
                            if (self.selectImage)
                            {
                               bascCode = [postPic imageToNSString:self.selectImage];
                            }else
                            {
                                bascCode = @"";
                            }
                            NSDictionary * para = @{
                                                    @"randId"   : [LoginTool returnRandId],
                                                    @"username" : self.userName.text,
                                                    @"desc"     : @"",
                                                    @"phone"    : @"",
                                                    @"truename" : @"",
                                                    @"idCard"   : @"",
                                                    @"gender"   :self.sexNumber,
                                                    @"code"     : bascCode,
                                                    };
                            __weak LoadData *getNewData;
                            getNewData = [LoadData LoadDatakWithUrl:@"/modify" WithDic:para withCount:6];
                            getNewData.ReturnCodeBlock = ^(NSNumber* code)
                            {
                                if ([code intValue] == 0)
                                {
                                    [[AppDelegate sharedInstance] ShowAlert:@"修改失败"];
                                }else if([code intValue]==1)
                                {
                                    getNewData.ReturnLoadDataWithUserModelBlock = ^(userModel *model)
                                    {
                                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                        NSDictionary * para = @{          @"username"   : model.username,
                                                                          @"img"        : model.img,
                                                                          @"token"      : [LoginTool returnToken]
                                                                          };
                                        [user setObject:para forKey:@"user"];
                                        [user synchronize];
                                        [[AppDelegate sharedInstance] ShowAlert:@"修改成功"];
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                        //[self.navigationController popToViewController:self.perSonVC animated:YES];
                                    };

                                }
                            };

        }

}

-(void)selectSexSelMo
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择你的性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"帅哥",@"美女", nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
            // 注销账号
        case 0:
            self.sexLabel.text = @"帅哥";
            self.sexNumber = @1;
            break;
            // 更换账号
        case 1:
            self.sexLabel.text = @"美女";
            self.sexNumber = @-1;
            
            break;

    }
}

-(BOOL)VefityWithName:(NSString*)name With:(NSString*)text
{
    if (![[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length])
    {
//        NSLog(@"%@不能为空",text);
        
       [[AppDelegate sharedInstance] ShowAlert:@"请完善信息在提交"];
        return NO;
    }else if ([name isEqualToString:@"管理员"]||[name isEqualToString:@"人脉档案"])
    {
        [[AppDelegate sharedInstance] ShowAlert:@"不能使用敏感词哦亲！"];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
