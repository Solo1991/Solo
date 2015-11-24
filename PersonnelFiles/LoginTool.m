 //
//  LoginTool.m
//  ShareDemo
//
//  Created by Solo on 15/5/27.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "LoginTool.h"
#import "WeiboSDK.h"
#import "AFNetworking.h"
#import "WXApi.h"
#import "LoadData.h"
#import "AppDelegate.h"
@interface LoginTool()<TencentSessionDelegate,WeiboSDKDelegate,WXApiDelegate>{
    
    //qq
    TencentOAuth * _tencentOAuth;
    NSArray* permissions;
    
    
    //WeChat
    NSString      * wechatAuthBackCode;
}

/**
 *  微博
 */

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@end

@implementation LoginTool


+ (instancetype)sharedInstance {
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

-(void)initSdk{
    
    //weibo 暂时不需要 sina 登陆
    //[WeiboSDK enableDebugMode:YES];
    
   // [WeiboSDK registerApp:kSinaAppKey];
    
    //qq
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:KQQAPPID andDelegate:self];
    _tencentOAuth.redirectURI = @"www.qq.com";
    permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    
    //wechat
     [WXApi registerApp:KWeChatAPPkey withDescription:@"inche"];
}


-(void)weiBoLogin{
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaRedirectURI;
    request.scope    = @"all";
    request.userInfo = @{@"SSO_From": @"LoginController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
    
}

-(void)qQLogin{
    [_tencentOAuth authorize:permissions inSafari:YES];
}

-(void)weChatLogin{
   
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
        
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope  = @"snsapi_userinfo";
        req.state  = @"123";
        req.openID = @"0c806938e2413ce73eef92cc3";
        [WXApi sendReq:req];    //第三方向微信终端发送一个SendAuthReq消息结构
    }
    else
    {
        NSLog(@"未安装微信");
    }
}

#pragma mark qq登录成功后的回调
- (void)tencentDidLogin
{
    NSLog(@"qq 登陆成功");
    if(![_tencentOAuth getUserInfo])//开始获取用户基本信息
    {
        [[[UIAlertView alloc]initWithTitle:@"登录提示" message:@"由于无法获取您的QQ信息，登录失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
}

#pragma mark qq登录失败后的回调
- (void)tencentDidNotLogin:(BOOL)cancelled{
     NSLog(@"qq 登陆失败");
}

#pragma mark qq 获取用户个人信息回调
- (void)getUserInfoResponse:(APIResponse*) response {
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSDictionary * data = response.jsonResponse;
        NSLog(@"JSON: -QQ- %@",data);
        

        

        
        self.para = @{          @"username"   : data[@"nickname"],
                                @"img"        : data[@"figureurl_qq_2"],
                                @"token"      : _tencentOAuth.accessToken};
        NSDictionary *tokenPara = @{
                                    @"token" :_tencentOAuth.accessToken
                                    };
        
        [self postRequestWith:tokenPara];
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
                              
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
    }
}


#pragma mark 微博登录失败后的回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    
    
    self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
    self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
    [[NSUserDefaults standardUserDefaults] setObject:self.wbtoken forKey:@"weibo_token"];
    [[NSUserDefaults standardUserDefaults] setObject:self.wbCurrentUserID forKey:@"weibo_userid"];
    
    if (self.wbCurrentUserID == nil || self.wbtoken == nil) {
        NSLog(@"login fail");
        return;
    }
    
    NSLog(@"sina login seccess");
    [self getSinaUserInfo];
}


#pragma mark 微博获取用户信息
-(void)getSinaUserInfo
{
    NSDictionary * para = @{@"uid"          : [[NSUserDefaults standardUserDefaults] objectForKey:@"weibo_userid"],
                            @"access_token" : [[NSUserDefaults standardUserDefaults] objectForKey:@"weibo_token"]};
    
    [[AFHTTPRequestOperationManager manager]GET:@"https://api.weibo.com/2/users/show.json"
                                     parameters:para
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSDictionary * data = responseObject;
                                            NSLog(@"JSON: -weibo- %@",responseObject);
                                            NSDictionary * attributes = @{@"name"           : data[@"screen_name"],
                                                                          @"headImageUrl"   : data[@"avatar_large"],
                                                                          @"sinaLoginID"    : data[@"idstr"],
                                                                          @"sinaToken"      : [[NSUserDefaults standardUserDefaults] objectForKey:@"weibo_token"]
                                                                          };
                                            NSLog(@"JSON: -weibo-attributes %@",attributes);
                                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                            
                                            [user setObject:attributes forKey:@"user"];
                                            
                                            [user synchronize];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"geiNameAndImage" object:nil];
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            [[[UIAlertView alloc]initWithTitle:@"登录提示" message:@"由于无法获取您的微博信息，登录失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                                            
                                            NSLog(@"ERROE: -weibo- %@",error);
                                        }];
}

#pragma mark wechat获取用户信息
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if(!resp.errCode){
            NSLog(@"微信登陆成功");
        }else{
            NSLog(@"微信登陆失败");
        }

    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        if(!temp.errCode){
            wechatAuthBackCode = temp.code;
            NSLog(@"微信登陆成功");
            [self getWeChatUserInfoPre];
        }else{
            NSLog(@"微信登陆失败");
        }
        

    }
 
}


-(void)getWeChatUserInfoPre
{
    if(wechatAuthBackCode)
    {
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",KWeChatAPPkey,KWeChatSecret,wechatAuthBackCode];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL    *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData   *data    = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(data){
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSString * accessToken = [dic objectForKey:@"access_token"];
                    NSString * openid      = [dic objectForKey:@"openid"];
                    [self getWeChatUserInfoWith:accessToken With:openid];
                }
            });
        });
    }
}

-(void) getWeChatUserInfoWith:(NSString*)accessToken With:(NSString*)openid
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL    *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData   *data    = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"JSON: -weiChat- :%@",userInfo);
                
                NSLog(@"JSON: -weiChat-attributes :%@",self.para);
                
                self.para = @{          @"username"   : [userInfo objectForKey:@"nickname"],
                                        @"img"        : [userInfo objectForKey:@"headimgurl"],
                                        @"token"      : accessToken};
                NSDictionary *tokenPara = @{
                                            @"token" :accessToken
                                            };
                NSLog(@"para.reg111111 = %@",self.para[@"token"]);
                [self postRequestWith:tokenPara];

                
            }
        });
        
    });
    
}
-(void)postRequestWith:(NSDictionary*)dict{
    
    __weak LoadData *getLoginData = [LoadData LoadDatakWithUrl:@"/wxlog" WithDic:dict withCount:2];
    NSLog(@"dict == %@",dict);
    getLoginData.ReturnCodeBlock = ^(NSNumber *code)
    {
        //检查失败
        if([code intValue] == 0)
        {
            //登陆失败-->注册
            LoadData *getexamineData = [LoadData LoadDatakWithUrl:@"/wxreg" WithDic:self.para withCount:1];
            getexamineData.ReturnCodeBlock = ^(NSNumber *twocode)
            {
                 //注册失败--->提示用户-->放弃挣扎
                if ([twocode intValue] == 0)
                {
                   [[AppDelegate sharedInstance] ShowAlert:@"登陆失败"];
 
                }   //注册成功--->跳转登陆
                else if ([twocode intValue] ==1)
                        {
                          
                            __weak  LoadData *getLoginOrData = [LoadData LoadDatakWithUrl:@"/wxlog" WithDic:dict withCount:2];
                            
                            getLoginOrData.ReturnCodeBlock =^(NSNumber *threecode)
                            {
                                if ([threecode intValue]==0)
                                {
                                    //登陆失败-->--->提示用户-->放弃挣扎
                                  [[AppDelegate sharedInstance] ShowAlert:@"登陆失败"];
                                    
                                }else if ([threecode intValue] ==1)
                                {
                                    //登陆成功-->--->提示用户-->保存数据
                                    getLoginOrData.ReturnLoadDataWithUserModelBlock = ^(userModel *model)
                                    {
                                        [self setNameAndImage:model];
                                    };
                                    NSLog(@"---rrrr------------");
                                }
                            };
                        }
                else
                {
                    
                }

        };
            //登陆成功-->--->提示用户-->保存数据
        }else if ([code intValue] ==1)
        {

            getLoginData.ReturnLoadDataWithUserModelBlock = ^(userModel *model)
            {
                [self setNameAndImage:model];
            };
        }
    };
   
}

- (NSString *)getString:(id)object{
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",object];
}


-(void)setNameAndImage:(userModel*)model{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    model.img = [self getString:model.img];
    model.desc = [self getString:model.desc];
    model.phone = [self getString:model.phone];
    
    NSDictionary * para = @{          @"username"   : model.username,
                                      @"img"        : model.img,
                                      @"token"      : self.para[@"token"]
                                      };
    [user setObject:para forKey:@"user"];
    [user synchronize];
    
    NSLog(@"img---%@--name---%@---gender---%@",model.img,model.username,model.gender);
    
    

    NSUserDefaults *randIdUser = [NSUserDefaults standardUserDefaults];
    [randIdUser setObject:model.randId forKey:@"randId"];
    NSLog(@"randid  = %@",model.randId);
    [randIdUser synchronize];
        
    NSUserDefaults *userGender = [NSUserDefaults standardUserDefaults];
    [userGender setObject:model.gender forKey:@"gender"];
    [userGender synchronize];
        

    [[NSNotificationCenter defaultCenter] postNotificationName:@"geiNameAndImage" object:nil];
}

#pragma mark ------------tencent QQ--------------------------------
-(void)QQShareWithTitle:(NSString*)title
              WithIntro:(NSString*)intro
                WithURL:(NSString*)url
           WithImageURL:(NSString*)imgUrl
{
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                        title:title
                                                  description:intro
                                              previewImageURL:[NSURL URLWithString:imgUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    NSLog(@"Code :%d",sent);
}



#pragma mark ------------tencent Zone-------------------------------

-(void)QQZoneShareWithTitle:(NSString*)title
                  WithIntro:(NSString*)intro
                    WithURL:(NSString*)url
               WithImageURL:(NSString*)imgUrl
                WithComment:(NSString*)comment
{
//    TCAddShareDic *params = [TCAddShareDic dictionary];
//    params.paramComment = comment;
//    params.paramTitle   = title;
//    params.paramSummary = intro;
//    params.paramImages  = imgUrl;
//    params.paramUrl     = url;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title:title
                                description:intro
                                previewImageURL:[NSURL URLWithString:imgUrl]];
    
    //将内容分享到qzone
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    NSLog(@"Code :%d",sent);
    
//    if(![_tencentOAuth addShareWithParams:params])
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

//Delegate 腾讯qqzone分享回调
- (void)addShareResponse:(APIResponse*) response {
    
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        //[self shareSuccess];
        
        NSMutableString *str=[NSMutableString stringWithFormat:@""];
        for (id key in response.jsonResponse) {
            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
                              
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles:nil];
        [alert show];
        
    }
    else {
        [[AppDelegate sharedInstance] ShowAlert:@"分享失败"];
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
         
         delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
         [alert show];
         */
    }
}




#pragma mark ------------WeChat--------------------------------

-(void)WeChatFriendsShareWithTitle:(NSString*)title
                         WithIntro:(NSString*)intro
                           WithURL:(NSString*)url
                     WithImageData:(NSData*)imgData
                         WithImage:(UIImage*)image
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        WXMediaMessage *message = [WXMediaMessage message];
        
        message.title=title;
        message.description=intro;
        [message setThumbData:imgData];
        //分享网址
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        message.mediaObject = ext;
        
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }
    else{
        [[AppDelegate sharedInstance] ShowAlert:@"未安装微信"];
    }
    
}

-(void)WeChatFriendsCircleShareWithTitle:(NSString*)title
                               WithIntro:(NSString*)intro
                                 WithURL:(NSString*)url
                           WithImageData:(NSData*)imgData
                               WithImage:(UIImage*)image
{
    NSLog(@"$$11:%d",imgData.length);
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
        
        WXMediaMessage *message = [WXMediaMessage message];
        
        message.title = title;
        message.description = intro;
        [message setThumbData:imgData];
        
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
        
    } else{
        [[AppDelegate sharedInstance] ShowAlert:@"未安装微信"];
    }
}


-(BOOL)weiBoHandleWith:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}
-(BOOL)qQHandleWith:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url];
}
-(BOOL)weChatHandleWith:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

+(NSString*)returnRandId
{
    NSLog(@"return  = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"randId"]);
     return  [[NSUserDefaults standardUserDefaults] objectForKey:@"randId"];
}
+(NSNumber*)returnGender{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
}
+(NSString*)returnName{

    NSString *userName;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"])
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        
        userName = dict[@"username"];
    }
    return userName;
}
+(NSURL*)returnHeadImage{
    NSURL *imageURL;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        
        imageURL = [NSURL URLWithString:dict[@"img"]];
    }
    return imageURL;
}

+(NSString*)returnToken{
    NSString *token;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        token = dict[@"token"];
    }
    return token;
}

+(NSString*)returnstreet{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"street"] ;
}

+(NSString*)returnCity{
    
    NSLog(@"----------%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] );
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"city"] ;
}

+(userModel*)returnUserModel
{
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
}


+(userModel*)returnLoginKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginKey"];
}

+(userModel*)returnjudgeKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"judgeKey"];
}
@end
