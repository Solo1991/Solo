
//
//  AppDelegate.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#define  kNavTitleFontSize 19


#import "AppDelegate.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"

#import "LoginTool.h"
#import "newSpecialVC.h"
#import "MainNavVC.h"
#import "MainViewVC.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "settingManager.h"
#import "PositionManager.h"
#import "LoadVC.h"
#import "LoadData.h"

#import "ShareView.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkReachabilityManager.h"
#import "DMRNotificationView.h"
//#import "AFNetworkReachabilityManager.h
@interface AppDelegate ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    ShareView *as;
    shareModel*shareDataModel;
    UIViewController* ParentViewController;
}
@property(nonatomic,strong)NSString *imageUrl;
@end

@implementation AppDelegate
+(AppDelegate*) sharedInstance
{
    return ((AppDelegate*) [[UIApplication sharedApplication] delegate]);
}
//禁用屏幕旋转
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    

    
    
    application.statusBarStyle =UIStatusBarStyleLightContent;
    self.window.rootViewController = [[MainNavVC alloc] initWithRootViewController:[[MainViewVC alloc] init]];
    
    [[PositionManager shardMobilePosition] startAddress];
    
//    NSLog(@"----%@----",[LoginTool returnCity]);
    LoadVC *loadVc = [[LoadVC alloc] init];
    self.window.rootViewController = loadVc;
    NSDictionary *para = @{
                           @"type":  @-2
                           };
    LoadData *getAdLoadData = [LoadData LoadDatakWithUrl:@"/ads/get" WithDic:para withCount:19];
    getAdLoadData.ReturnLoadDataWithArrBlock = ^(NSMutableArray *arr)
    {
        
        NSDictionary *dict = arr[0];
        self.imageUrl = dict[@"img"];
//        NSLog(@"----%@",self.imageUrl);
        if(self.imageUrl)
        {
            [loadVc.loadImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               /**
                                *  判断登陆
                                */
                               LoadData *getJudegKeyData = [LoadData LoadDatakWithUrl:@"/usercollect/getswitchparam" WithDic:nil withCount:32];
                               getJudegKeyData.ReturnCodeBlock = ^(NSNumber *code)
                               {
                                   if ([code intValue]==0)
                                   {
                                       NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                       
                                       [user setObject:[NSString stringWithFormat:@"%@",code] forKey:@"judgeKey"];
                                       
                                       [user synchronize];
                                       return ;
                                   }else
                                   {
                                       NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                       
                                       [user setObject:[NSString stringWithFormat:@"%@",code] forKey:@"judgeKey"];
                                       
                                       [user synchronize];
                                   }
                               };
                               if (![LoginTool returnLoginKey])
                               {
                                   NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                   
                                   [user setObject:@"login" forKey:@"loginKey"];
                                   
                                   [user synchronize];
                                   newSpecialVC *newSpecVC = [[newSpecialVC alloc] init];
                                                      
                                   self.window.rootViewController = newSpecVC;

                               }else
                               {

                                   self.window.rootViewController = [[MainNavVC alloc] initWithRootViewController:[[MainViewVC alloc] init]];
                               }
                           });
        }
    };
    
    
    
    

//    /**
//     *  判断登陆
//     */
//    LoadData *getJudegKeyData = [LoadData LoadDatakWithUrl:@"/usercollect/getswitchparam" WithDic:nil withCount:32];
//    getJudegKeyData.ReturnCodeBlock = ^(NSNumber *code)
//    {
//        if ([code intValue]==0)
//        {
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            
//            [user setObject:[NSString stringWithFormat:@"%@",code] forKey:@"judgeKey"];
//            
//            [user synchronize];
//            return ;
//        }else
//        {
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            
//            [user setObject:[NSString stringWithFormat:@"%@",code] forKey:@"judgeKey"];
//            
//            [user synchronize];
//        }
//    };
//    
//    
//    
//    if (![LoginTool returnLoginKey])
//    {
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        
//        [user setObject:@"login" forKey:@"loginKey"];
//        
//        [user synchronize];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//                       {
//                           
//                           newSpecialVC *newSpecVC = [[newSpecialVC alloc] init];
//                           
//                           self.window.rootViewController = newSpecVC;
//                           
//                       });
//    }else
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//                       {
//                           self.window.rootViewController = [[MainNavVC alloc] initWithRootViewController:[[MainViewVC alloc] init]];
//                       });
//    }


    

    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"new"])
//    {
//
//
//    }else
//    {
//        LoadVC *loadVc = [[LoadVC alloc] init];
//        self.window.rootViewController = loadVc;
//        
//        
//        LoadData *getAdLoadData = [LoadData LoadDatakWithUrl:@"/startup" WithDic:nil withCount:22];
//        getAdLoadData.ReturnLoadDataWithDictBlock = ^(NSDictionary *dict){
//            self.imageUrl = dict[@"img"];
//            [loadVc.loadImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
//        };
//    }
    
    
    
    
//    NSLog(@"url        %@",self.imageUrl);
    
   

    
    [self customizeInterface];
    [self initNetWorkReachable];
    
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    // ios8之后可以自定义category
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        // ios8之前 categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
    }
#else
    // categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    
    // Required
    [APService setupWithOption:launchOptions];
    


    return YES;
}



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)customizeInterface {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    
    
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
        [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0xfc6c40"]];//设置UITextField的光标颜色
        [[UITextView appearance]  setTintColor:[UIColor colorWithHexString:@"0xfc6c40"]];//设置UITextView的光标颜色
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xededed"]] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xfc6c40"]]];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
        
        
        
#endif
    }//0x28303b
    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xfc6c40"]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
//    NSLog(@"-----------deviceToken   = %@",deviceToken);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    application.applicationIconBadgeNumber =0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    // ios8 com.tencent.xin ios7
//    NSLog(@"2=%@   =1 =%@",url,sourceApplication);
    if([sourceApplication isEqualToString:@"com.sina.weibo"])
    {
        return [[LoginTool sharedInstance] weiBoHandleWith:url];
    }else if ([sourceApplication isEqualToString:@"com.tencent.mqq"])
    {
        return [[LoginTool sharedInstance] qQHandleWith:url];
        
    }else if([sourceApplication isEqualToString:@"com.tencent.xin"]||[sourceApplication isEqualToString:@"com.tencent.xin.dk30"])
    {
        return [[LoginTool sharedInstance] weChatHandleWith:url];
    }
    
    return YES;
}


- (void)shareActionWithShareModel:(shareModel*)model With:(UIViewController*)parentVC
{
    
    shareDataModel =model;
    ParentViewController =parentVC;
    //判断是否打开全部登陆设置
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] isEqualToString:@"0"]) {
//        if([userModel shareInstance]){
//            
//            [[shareSingle sharedInstance] SinaShareWithTitle:shareDataModel.shareTitle
//                                                   WithIntro:shareDataModel.shareInstro
//                                                     WithURL:shareDataModel.shareURL
//                                               WithImageData:shareDataModel.shareImgData];
//        }else{
//            
//            
//            LoginVC* loginVC = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
//            loginVC.showState = LoginShowStatePush;
//            [ParentViewController.navigationController pushViewController:loginVC animated:YES];
//            
//            [[AppDelegate sharedInstance] ShowAlert:STR(@"请先登陆")];
//            return;
//        }
//        return;
//    }
    
    if(!as){
//        shareData *action1 = [[shareData alloc] initWithName:@"新浪微博" iconName:@"新浪微博_" handler:^{
//            
//            if([userModel shareInstance]){
//                
//                [[shareSingle sharedInstance] SinaShareWithTitle:shareDataModel.shareTitle
//                                                       WithIntro:shareDataModel.shareInstro
//                                                         WithURL:shareDataModel.shareURL
//                                                   WithImageData:shareDataModel.shareImgData];
//            }else{
//                
//                //dispatch_async(dispatch_get_main_queue(), ^{    });
//                
//                LoginVC* loginVC = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
//                loginVC.showState = LoginShowStatePush;
//                [ParentViewController.navigationController pushViewController:loginVC animated:YES];
//                
//                [[AppDelegate sharedInstance] ShowAlert:STR(@"请先登陆")];
//                return;
//            }
//        }];

        shareData *action1 = [[shareData alloc] initWithName:@"QQ" iconName:@"qq_" handler:^{
            [[LoginTool sharedInstance] QQShareWithTitle:shareDataModel.shareTitle
                                                 WithIntro:shareDataModel.shareInstro
                                                   WithURL:shareDataModel.shareURL
                                              WithImageURL:shareDataModel.shareImgURL];
            
 
            
        }];
        
        shareData *action2 = [[shareData alloc] initWithName:@"QQ空间" iconName:@"qqZone" handler:^{
            
            
            [[LoginTool sharedInstance] QQZoneShareWithTitle:shareDataModel.shareTitle
                                                   WithIntro:shareDataModel.shareInstro
                                                     WithURL:shareDataModel.shareURL
                                                WithImageURL:shareDataModel.shareImgURL
                                                 WithComment:@""];
            
            
        }];
        shareData *action3 = [[shareData alloc] initWithName:@"微信好友" iconName:@"微信_" handler:^{
            [[LoginTool sharedInstance] WeChatFriendsShareWithTitle:shareDataModel.shareTitle
                                                            WithIntro:shareDataModel.shareInstro
                                                              WithURL:shareDataModel.shareURL
                                                        WithImageData:shareDataModel.shareImgData
                                                            WithImage:shareDataModel.shareImg];
        }];
        shareData *action4 = [[shareData alloc] initWithName:@"朋友圈" iconName:@"朋友圈_" handler:^{
            [[LoginTool sharedInstance] WeChatFriendsCircleShareWithTitle:shareDataModel.shareTitle
                                                                  WithIntro:shareDataModel.shareInstro
                                                                    WithURL:shareDataModel.shareURL
                                                              WithImageData:shareDataModel.shareImgData
                                                                  WithImage:shareDataModel.shareImg];
        }];
        NSArray *actions = @[@"分享",@[action1, action2, action3, action4]];
        as = [[ShareView alloc] initWithActionArray:actions];
    }
    [as show];
}


/**
 *  如果网络不可使用 （状态值为0）进行智能标签提示
 */
-(void)ShowNotification
{
    [DMRNotificationView showWarningInView:self.window.rootViewController.view
                                     title:@"温馨提醒您!"
                                  subTitle:@"当前网络不能使用,请查看网络是否正常"
                          HideTimeInterVal:5];
}


#pragma mark - 网络状态的实时检测；
- (void)initNetWorkReachable{
    
    AFNetworkReachabilityManager * reachablityManager = [AFNetworkReachabilityManager sharedManager];
    [reachablityManager startMonitoring];
    
    [reachablityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                //[[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                [self ShowNotification];
                [[NSNotificationCenter defaultCenter] postNotificationName:INTERNETWORK_STATUS_CHANGE_NOTIFY object:self];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                break;
            }
            default:
                break;
        }
    }];
}
#pragma mark -----------注册警告通知-----------
-(void)alert:(NSString*)data {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:data
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)alert:(NSString *)title andData:(NSString *)data andDelegate:(id)object
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:data
                                                   delegate:object
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消",nil];
    [alert show];
}
-(void)ShowAlert:(NSString*)data {
    
    
     [self removeHUD];
    //MBProgressHUD *hud
    HUD= [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = data;
    HUD.margin  = 10.f;
    HUD.yOffset = 0.f;
    
    //hud.blur    = false;
    HUD.color   = ThemeColor;//RGB(90, 198, 255);
    HUD.alpha   = 0.85;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.0];
}

-(void)ShowAlertWith:(UIView*)view{
    
    //初始化进度框，置于当前的View当中
    HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //设置对话框文字
    HUD.labelText = @"";
    HUD.margin  = 5.f;
    HUD.yOffset = 0.f;
   // HUD.blur    = false;
    HUD.color   = [UIColor clearColor];
    HUD.alpha   = 0.85;
    [HUD show:YES];
}
- (void)showTextDialog:(NSString*) text
{
    //初始化进度框，置于当前的View当中
    HUD = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    //设置对话框文字
    HUD.labelText = text;
    HUD.margin  = 5.f;
    HUD.yOffset = 0.f;
    
    HUD.color   = ThemeColor;
    HUD.alpha   = 0.85;
    [HUD show:YES];
}

-(void)removeHUD
{
//    NSLog(@"加载成功22");
    [HUD removeFromSuperview];
    
    HUD = nil;
}
-(void)setHUDHide
{
    [HUD setHidden:YES];
}

- (void)showResultTextDialog:(NSString*)text withImageName:(NSString*)picture
{
    [self removeHUD];
    HUD = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    HUD.labelText =text ;
    HUD.mode = MBProgressHUDModeCustomView;
    
    
    HUD.margin  = 5.f;
    HUD.yOffset = 0.f;
   // HUD.blur    = false;
    HUD.color   = ThemeColor;
    HUD.alpha   = 0.85;
    
    UIImageView* imageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40,40)];
    imageView.image =[UIImage imageNamed:picture];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.backgroundColor = [UIColor clearColor];
  
    HUD.customView = imageView;
    
    
    [HUD showAnimated:YES whileExecutingBlock:^
    {
        sleep(1.0);
    } completionBlock:^
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}
@end
