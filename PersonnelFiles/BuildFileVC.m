
//
//  BuildFileVC.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/6.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "BuildFileVC.h"
#import "quickMethod.h"
#import "MTCityViewController.h"
#import "MBProgressHUD.h"
#import "LoadData.h"
#import "LoginTool.h"
#import "postPic.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
@interface BuildFileVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    int btnCount;
    MBProgressHUD *HUD;
    

}

@property(nonatomic,strong)UIButton *picOneBtn;
@property(nonatomic,strong)UIButton *picTwoBtn;
@property(nonatomic,strong)UIButton *picThreeBtn;
@property(nonatomic,strong)UIButton *picFoutBtn;
@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)UITextField * nameTextField;
@property(nonatomic,strong)UIButton    * ageBtn;
@property(nonatomic,strong)UITextField * profTextField;
@property(nonatomic,strong)UITextField * hobbyTextField;
@property(nonatomic,strong)UITextField * weChatTextField;
@property(nonatomic,strong)UITextField * iWantTextField;

@property(nonatomic,strong)UIButton  *selectSex;
@property(nonatomic,strong)UIButton  *selectZone;
@property(nonatomic,strong)UIScrollView *bulidFileScrollView;

@property(nonatomic,strong)NSString *sexStr;
@property(nonatomic,strong)NSString *cityStr;
@property(nonatomic,strong)UILabel *selectZoneTitle;
@property(nonatomic,strong)UILabel *selectAgeTitle;
@property(nonatomic,strong)NSString *ageStr;

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NSMutableArray *imageUrlArr;

@property(nonatomic,strong)NSDictionary *fileDict;

/**
 *  选中的照片
 */
@property (nonatomic , strong) NSMutableArray *assets;
/**
  正在编辑框的高度
*/
@property(nonatomic,assign)int keyboardHeight;
@property(strong,nonatomic)UITextField * totalTf;//全局编辑框

@end

@implementation BuildFileVC


- (NSMutableArray *)assets
{
    if (!_assets)
    {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"创建档案";
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageUrl:) name:@"postSeccess" object:nil];
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.imageUrlArr    = [NSMutableArray array];
    
    self.bulidFileScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.bulidFileScrollView.contentSize = CGSizeMake(MainWidth, MainHeight+200);
    self.bulidFileScrollView.delegate =self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderAll)];
    
    [self.bulidFileScrollView addGestureRecognizer:tap];
    [self.view addSubview:self.bulidFileScrollView];
    NSArray *headNib = [[NSBundle mainBundle] loadNibNamed:@"BuildFileHeadView" owner:self options:nil];
    self.headView= [headNib objectAtIndex:0];
    
    self.headView.x = 0;
    self.headView.y = 0;
    self.headView.width = MainWidth;
    [self.bulidFileScrollView addSubview:self.headView];

    self.nameTextField      = (UITextField*)[self.headView viewWithTag:100];
    self.nameTextField.delegate =self;
    [quickMethod setSize: CGSizeMake(MainWidth -134, 30) with:self.nameTextField];
    self.ageBtn             = (UIButton *)[self.headView viewWithTag:101];
    self.profTextField       = (UITextField*)[self.headView viewWithTag:102];
    self.profTextField.delegate = self;

    self.selectSex         = (UIButton*)[self.headView viewWithTag:103];
    self.selectZone         = (UIButton*)[self.headView viewWithTag:104];
    
    self.hobbyTextField      = (UITextField*)[self.headView viewWithTag:105];
    self.hobbyTextField.delegate = self;
    self.weChatTextField      = (UITextField*)[self.headView viewWithTag:106];
    self.weChatTextField.delegate = self;
    self.iWantTextField    = (UITextField*)[self.headView viewWithTag:107];
    self.iWantTextField.delegate = self;
    
    UIColor * btnColor = [UIColor colorWithRed:224/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    [quickMethod doCornerRadiusWith:self.ageBtn WithRadius:7 WithBorderWidth:1 WithColor:btnColor];
    self.selectAgeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    self.selectAgeTitle.text = @"请选择您的年龄";
    self.selectAgeTitle.textColor = [UIColor lightGrayColor] ;
    self.selectAgeTitle.font = [UIFont systemFontOfSize:11];
    [self.ageBtn addSubview:self.selectAgeTitle];
    [self.ageBtn addTarget:self action:@selector(selectAgeSel) forControlEvents:UIControlEventTouchUpInside];
    
    
    [quickMethod doCornerRadiusWith:self.selectSex WithRadius:7 WithBorderWidth:1 WithColor:btnColor];
    [self.selectSex addTarget:self action:@selector(selectSexSel) forControlEvents:UIControlEventTouchUpInside];
    
    
    [quickMethod doCornerRadiusWith:self.selectZone WithRadius:7 WithBorderWidth:1 WithColor:btnColor];
    UIImageView *selectZoneImage =[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    
    selectZoneImage.image = [UIImage imageNamed:@"定位.png"];
    [self.selectZone addSubview:selectZoneImage];
    self.selectZoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, 20)];
    self.selectZoneTitle.text = @"切换城市";
    self.selectZoneTitle.textColor = [UIColor lightGrayColor];
    self.selectZoneTitle.font = [UIFont systemFontOfSize:11];
    [self.selectZone addSubview:self.selectZoneTitle];
    [self.selectZone addTarget:self action:@selector(selectZoneSel) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BuildFileFootView" owner:self options:nil];
    self.footView= [nib objectAtIndex:0];
    self.footView.width = MainWidth;
    
    for (int i = 0; i<self.footView.subviews.count; i++) {
       // NSLog(@"%@",self.footView.subviews[i]);
    }
    self.picOneBtn      = self.footView.subviews[0];
    self.picTwoBtn      = self.footView.subviews[1];
    self.picThreeBtn    = self.footView.subviews[2];
    self.picFoutBtn     = self.footView.subviews[3];
    self.sendBtn        = self.footView.subviews[4];
    
    [self.picTwoBtn setHidden:YES];
    [self.picThreeBtn setHidden:YES];
    [self.picFoutBtn setHidden:YES];
    
    [self.sendBtn addTarget:self action:@selector(sendBtnSel) forControlEvents:UIControlEventTouchUpInside];
    [self.picOneBtn addTarget:self action:@selector(picOneBtnSel) forControlEvents:UIControlEventTouchUpInside];
    [self.picTwoBtn addTarget:self action:@selector(picTwoBtnSel) forControlEvents:UIControlEventTouchUpInside];
    [self.picThreeBtn addTarget:self action:@selector(picThreeBtnSel) forControlEvents:UIControlEventTouchUpInside];
    [self.picFoutBtn addTarget:self action:@selector(picFourBtnSel) forControlEvents:UIControlEventTouchUpInside];

    
    self.footView.x = 0;
    self.footView.y = CGRectGetMaxY(self.headView.frame)+10;
    
    [self.bulidFileScrollView addSubview:self.footView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.bulidFileScrollView setContentSize:CGSizeMake(0, MainHeight +100)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_pickview remove];
}
/**
 *  设置时间
 */
-(void)selectAgeSel
{
    [self.view endEditing:YES];
    
    [_pickview remove];
    
//    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //  定义一个NSDateComponents对象，设置一个时间点
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:1];
    [dateComponentsForDate setMonth:1];
    [dateComponentsForDate setYear:1990];
    
    //  根据设置的dateComponentsForDate获取历法中与之对应的时间点
    //  这里的时分秒会使用NSDateComponents中规定的默认数值，一般为0或1。
    NSDate * date = [greCalendar dateFromComponents:dateComponentsForDate];
    
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    
    _pickview.delegate=self;
    
    [_pickview show];
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSNumber * num = (NSNumber*)resultString;
    
//    NSLog(@"age------%d",2015-[num intValue]);
    if (2015-[num intValue] <= 0  || 2015-[num intValue] >= 120) {
        [[AppDelegate sharedInstance] ShowAlert:@"请选择正确年龄"];
    }else{
        self.ageStr = [NSString stringWithFormat:@"%d",2015-[num intValue]];
        self.selectAgeTitle.text = [NSString stringWithFormat:@"%d 周岁",2015-[num intValue]];
    }
   
    
}
-(void)addImageUrl:(NSNotification*)notification
{
    
    NSString *postImage = notification.userInfo[@"imageUrl"];
    
    [self.imageUrlArr addObject:postImage];
    
    if (self.imageUrlArr.count == self.assets.count)
    {
        
        [self postFile];
    }
    
}
-(void)resignFirstResponderAll
{
    [self.view endEditing:YES];
}

-(void)selectZoneSel
{
    testPrint
    MTCityViewController * mtCity = [[MTCityViewController alloc] init];
    mtCity.ReturnTextBlock =^(NSString *cityName)
    {
        self.selectZoneTitle.text = cityName;
        
    };
    [self presentViewController:mtCity animated:YES completion:nil];
}
-(void)selectSexSel
{
    [self.view endEditing:YES];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择您的性别"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"男",@"女",@"不限", nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    
    {
            // 注销账号
        case 0:
            [self.selectSex setTitle:@"男" forState:UIControlStateNormal];
            self.sexNumber =@1;
            break;
            // 更换账号
        case 1:
            [self.selectSex setTitle:@"女" forState:UIControlStateNormal];
            self.sexNumber =@-1;
            break;
        case 2:
            [self.selectSex setTitle:@"不限" forState:UIControlStateNormal];
            self.sexNumber =@0;
            break;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

-(void)sendBtnSel
{
    
    if ([self VefityWithName:self.nameTextField.text With:@"姓名"])
    {
        if ([self VefityWithName:self.ageStr With:@"年龄"])
        {
            if ([self VefityWithName:self.profTextField.text With:@"职业"])
            {
                if ([self VefityWithName:self.hobbyTextField.text With:@"爱好"])
                {
                    if ([self judgeWeChat:self.weChatTextField.text])
                    {
                        if ([self VefityWithName:self.iWantTextField.text With:@"我想"])
                        {
                            if ([self VefityWithName:[NSString stringWithFormat:@"%@",self.sexNumber] With:@"性别"])
                            {
                                if ([self VefityWithName:self.selectZoneTitle.text With:@"姓名"])
                                {
                                    
                                    

                                    self.fileDict  = @{
                                                            @"randId"   : [LoginTool returnRandId],
                                                            @"crname"   : self.nameTextField.text,
                                                            @"crage"    :self.ageStr,
                                                            @"crgender" : self.sexNumber,
                                                            @"crjob"    : self.profTextField.text,
                                                            @"crcity"   : self.selectZoneTitle.text,
                                                            @"crhobby"  : self.hobbyTextField.text,
                                                            @"crwx"     : self.weChatTextField.text,
                                                            @"crdo"     : self.iWantTextField.text,
                                                            };
 

                                    if (self.assets.count <=0) {
                                        [[AppDelegate sharedInstance] ShowAlert:@"请上传图片"];
                                        return;
                                    }

                                    [[AppDelegate sharedInstance] showTextDialog:@"正在发送"];
                                    if (self.assets.count==0)
                                    {
                                        [self postFile];
                                        return;
                                    }
                                    for (int count = 0; count < self.assets.count; count++)
                                    {
                                        
//                                        NSLog(@"%@",self.assets[count]);
                                        UIImage *image =[MLSelectPhotoPickerViewController getImageWithImageObj:self.assets[count]];
                                         [postPic PostImageWith:image with:self.imageUrlArr];
                                        
                                    }
                                    
                                    
//                                    NSLog(@"%@",self.nameTextField.text);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

}

/**
 *  判断微信号
 */
-(BOOL)judgeWeChat:(NSString*)weChat
{
    NSString * regex = @"^[A-Za-z0-9]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:weChat];
    if (!isMatch)
    {
        [[AppDelegate sharedInstance] ShowAlert:@"请输入正确的微信号"];
    }
    return isMatch;
}


/**
 *  发送档案
 */
-(void)postFile
{
    NSDictionary *postFileDict  = @{
                       @"randId"    : self.fileDict[@"randId"],
                       @"crname"    : self.fileDict[@"crname"],
                       @"crage"     : self.fileDict[@"crage"],
                       @"crgender"  : self.fileDict[@"crgender"],
                       @"crjob"     : self.fileDict[@"crjob"],
                       @"crcity"    : self.fileDict[@"crcity"],
                       @"crhobby"   : self.fileDict[@"crhobby"],
                       @"crwx"      : self.fileDict[@"crwx"],
                       @"crdo"      : self.fileDict[@"crdo"],
                       @"img"       : self.imageUrlArr};
    
//    NSLog(@"-------------%@",self.fileDict[@"crgender"]);
    
    LoadData *getNewData = [LoadData LoadDatakWithUrl:@"/usercomment/create" WithDic:postFileDict withCount:9];
    
                                        getNewData.ReturnStrBlock = ^(NSString * callBack)
                                        {
                                            
                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                        };
}



-(BOOL)VefityWithName:(NSString*)name With:(NSString*)text
{
    if (![[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length])
    {
//        NSLog(@"%@不能为空",text);

        [[AppDelegate sharedInstance] ShowAlert: @"请完善信息在提交!"];
        
        return NO;
    }
    return YES;
}



-(void)picOneBtnSel
{
    btnCount = 0;
    [self LocalPhoto];
}
-(void)picTwoBtnSel
{
    btnCount = 1;
    [self LocalPhoto];
}
-(void)picThreeBtnSel
{
    btnCount = 2;
    [self LocalPhoto];
}
-(void)picFourBtnSel
{
    btnCount = 3;
    [self LocalPhoto];
}
//开始拍照
-(void)takePhoto:(UIButton*)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
//        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}


//打开本地相册
-(void)LocalPhoto
{
    
    if (btnCount <self.assets.count)
    {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"删除选中图片？"
                                                    contentText:@"是否删除"
                                                leftButtonTitle:@"取消"
                                               rightButtonTitle:@"确定"];
        [alert show];
        alert.leftBlock = ^() {
        };
        alert.rightBlock = ^() {
            [self.assets removeObjectAtIndex:btnCount];
            [self setBtnBackImage];
        };
        alert.dismissBlock = ^() {
        };
        
        
        return;
    }
    
    // 创建控制器
    
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];

    // 默认最多能选4张图片
    pickerVc.minCount = 4-self.assets.count;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc show];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets)
    {
        [weakSelf.assets addObjectsFromArray:assets];
        self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self.view addSubview:self.imageView];
        for (int i = 0; i <weakSelf.assets.count; i++)
        {
            MLSelectPhotoAssets *asset = self.assets[i];
            UIImage *selectImage = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
//            NSLog(@" %d === %@",i,selectImage);
            [self.footView.subviews[i] setBackgroundImage:selectImage forState:UIControlStateNormal];
            if (i<3)
            {
                [self.footView.subviews[i+1] setHidden:NO];
            }
            
        }
    };
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex)
    {
        case 0:
//            NSLog(@"取消");
            break;
        case 1:
//            NSLog(@"确定");

            break;
        default:
            break;
    }
}

-(void)setBtnBackImage
{
        for (int i = 0; i <self.assets.count; i++)
        {
            MLSelectPhotoAssets *asset = self.assets[i];
            UIImage *selectImage = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            [self.footView.subviews[i] setBackgroundImage:selectImage forState:UIControlStateNormal];
            
        }
        if (self.assets.count <3)
        {
            [self.footView.subviews[self.assets.count +1] setHidden:YES];
        }
        
        if (self.assets.count == 0)
        {
            [self.footView.subviews[0] setBackgroundImage:[UIImage imageNamed:@"有图有真相.png"] forState:UIControlStateNormal];
            return;
        }
        
        [self.footView.subviews[self.assets.count] setBackgroundImage:[UIImage imageNamed:@"添加照片.png"] forState:UIControlStateNormal];
 
}

/**
 *  KeyBoard 弹出View 自动上移
 */
#pragma mark -- textFeild代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _totalTf = textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -- 通知事件
-(void)keyboardShow:(NSNotification *)notifi
{
    //获取键盘的高度
    NSDictionary *userInfo = [notifi userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
//    UIView * totalView = _totalTf.superview.superview;
    if (_keyboardHeight != 0 && self.view.frame.size.height - _keyboardHeight <= _totalTf.frame.origin.y + _totalTf.frame.size.height) {
        CGFloat moveHeight = _totalTf.frame.origin.y - (MainHeight - _keyboardHeight - _totalTf.height - 5);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(0, -moveHeight, MainWidth, MainHeight);
        [UIView commitAnimations];
    }
}
-(void)keyboardWillHide:(NSNotification *)notifi
{
    //此处添加动画，使之变化平滑一点
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, 64, MainWidth, MainHeight);//UITextField位置复原
    [UIView commitAnimations];
}
//移除通知接收者
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}







@end
