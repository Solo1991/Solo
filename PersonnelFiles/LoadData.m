
//  LoadData.m
//  StoreDemo
//
//  Created by Solo on 15/5/7.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "LoadData.h"
#import "AFNetworking.h"
#import "MainNavModel.h"
#import "UserDetailModel.h"
#import "CommentModel.h"
#import "AppDelegate.h"

static NSString *urlStr;
@interface LoadData()

@property (nonatomic,strong)AFHTTPRequestOperationManager *mgr ;
@end
@implementation LoadData
/**
 *  初始化afn
 *
 *
 */
-(AFHTTPRequestOperationManager *)mgr
{
    
    if (!_mgr)
    {
        _mgr = [AFHTTPRequestOperationManager manager];
        _mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        _mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    }
    return _mgr;
}


/**
 *  返回一个请求工具
 *
 *  @param url     请求url
 *  @param para    请求参数
 *  @param myClass 请求返回model类
 *
 *  @return 返回一个LoadData实例
 */

+(LoadData*)LoadDatakWithUrl:(NSString*)url WithDic:(NSDictionary*)para withCount:(int)count
{
    
    urlStr = @"http://api.rm520.cn/api";
    
    LoadData *mloadData = [[LoadData alloc] init];
    switch (count)
    {
            case 1:
                [mloadData getDataLoginWithUrl:url WithDic:para];
            break;
            
            case 2:
            [mloadData getDataExamineWithUrl:url WithDic:para];
            break;
            
            case 3:
            [mloadData getUserPublicDataWithUrl:url WithDic:para];
            break;
            
            case 4:
            [mloadData getDataUserMessageBacWithUrl:url WithDic:para];
            break;
            
            case 5:
            [mloadData getUserIofoDataWithUrl:url WithDic:para];
            break;
            
            case 6:
            [mloadData getDataModifyUserInfoBacWithUrl:url WithDic:para];
            break;
            
            case 7:
                [mloadData getNewWithUrl:url WithDic:para];
            break;
            
            case 8:
            [mloadData getRecoWithUrl:url WithDic:para];
            break;
            
            case 9:
            [mloadData getBuildFileWithUrl:url WithDic:para];
            break;
            
            case 10:
            [mloadData getCommentWithUrl:url WithDic:para];
            break;
            
            case 11:
            [mloadData getNewCommentWithUrl:url WithDic:para];
            break;
            
            case 12:
            [mloadData getDataZanBacWithUrl:url WithDic:para];
            break;

            case 14:
            [mloadData getSelfPubDataWithUrl:url WithDic:para];
            break;

            case 15:
            [mloadData getdelePubDataWithUrl:url WithDic:para];
            break;
  
            case 16:
            [mloadData getDataReportWithUrl:url WithDic:para];
            break;
            
            case 17:
                [mloadData getDataFeedBacWithUrl:url WithDic:para];
            break;
            
            case 19:
            [mloadData getAdDataWithUrl:url WithDic:para];
            break;
            
            case 20:
            break;
            
            case 22:
            [mloadData getLauchImageWithUrl:url WithDic:para];
            break;
            
            case 25:
            [mloadData getSearchDataWithUrl:url WithDic:para];
            break;
            
            case 26:
            [mloadData getLocationWithUrl:url WithDic:para];
            break;
            
            case 30:
            [mloadData getDataPostImageWithUrl:url WithDic:para];
            
            case 31:
            [mloadData getDataRefreshtotopWithUrl:url WithDic:para];
            break;
 
            case 32:
            [mloadData getJudegKeyDataWithUrl:url WithDic:para];
            break;
            
            case 33:
            [mloadData getHotWordsDataWithUrl:url WithDic:para];
            break;
        default:
            break;
    }
    
    return mloadData;
}



-(void)callBack:(NSNumber*)callBackCode withStr:(NSString*)callBackStr
{
    if ([callBackCode  isEqual: @1])
    {
        if (self.ReturnStrBlock)
        {
            self.ReturnStrBlock([NSString stringWithFormat:@"%@成功",callBackStr]);
        }
    }
    else
    {
        if (self.ReturnStrBlock)
        {
            self.ReturnStrBlock([NSString stringWithFormat:@"%@失败",callBackStr]);
        }
    }
}
/**
 *  一、接口名称：QQ/微信 注册
 *
 */
-(void)getDataLoginWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@",url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       NSLog(@"JSON 1--------%@",responseObject);
        NSDictionary *dataDict;
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1) {
            dataDict = [responseObject valueForKey:@"data"];
      
            userModel * model = [[userModel alloc] init];
            model.gender    = dataDict[@"gender"];
            model.username  = [self judgeIsNull:dataDict[@"userName"]];
            model.phone     = [self judgeIsNull:dataDict[@"phone"]] ;
            model.desc      = [self judgeIsNull:dataDict[@"desc"]];
            model.img       = [self judgeIsNull:dataDict[@"img"]];
            model.randId    = [self judgeIsNull:dataDict[@"randId"]];
            model.age       = [self judgeIsNull:dataDict[@"age"]];
            
        }
        if (self.ReturnCodeBlock)
        {
            self.ReturnCodeBlock(status);
        }
        if (self.ReturnLoadDataWithDictBlock)
        {
            self.ReturnLoadDataWithDictBlock(dataDict);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error 1---------- = %@",error);
    }];
    
}

/**
 *  二、接口名称：QQ/微信 检查用户
 *
 */
-(void)getDataExamineWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
//        NSLog(@"JSON 2--------%@",responseObject);

        NSDictionary *dataDict;
        userModel * model = [[userModel alloc] init];
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1)
        {
            dataDict = [responseObject valueForKey:@"data"];
            
            
            model.username  = [self judgeIsNull:dataDict[@"username"]];
            model.phone     = [self judgeIsNull:dataDict[@"phone"]] ;
            model.desc      = [self judgeIsNull:dataDict[@"desc"]];
            model.gender    = dataDict[@"gender"];
            model.img       = [self judgeIsNull:dataDict[@"img"]];
            model.randId    = [self judgeIsNull:dataDict[@"randId"]];
            model.age       = [self judgeIsNull:dataDict[@"age"]];
            
        }
        if (self.ReturnCodeBlock)
        {
            self.ReturnCodeBlock(status);
        }

        if (self.ReturnLoadDataWithUserModelBlock)
        {
            self.ReturnLoadDataWithUserModelBlock(model);
//            NSLog(@"接口2 info = %@",[responseObject valueForKeyPath:@"info"]);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"error = %@",error);
    }];
    
}
/**
 *  三、接口名称：获取用户动态
 *
 */
-(void)getUserPublicDataWithUrl:(NSString*)url WithDic:(NSDictionary*)para{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"block = %@",responseObject);
        NSMutableArray * modelArray = [NSMutableArray array];
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1) {
            NSDictionary * dict = [responseObject valueForKeyPath:@"data"];
            
            NSMutableArray *array = dict[@"result"];
            for (NSDictionary * mdict in array) {
                MainNavModel * model = [[MainNavModel alloc] init];
                model.username = [self judgeIsNull:mdict[@"userName"]];
                model.userImg  = [self judgeIsNull:mdict[@"userImg"]] ;
                model.bddo     = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                
                model.parised  =    mdict[@"shared"];
                model.collect  =    mdict[@"parised"];
                model.replys   =    mdict[@"replys"];
                
                model.createdAt= [self judgeIsNull: mdict[@"createdAt"]];
                model.mainNewID    = mdict[@"id"];
                model.userGender   = mdict[@"userGender"];
                model.randId     = [self judgeIsNull:mdict[@"randId"]];
                
                model.isCollect      = mdict[@"isCollect"];
                model.isParised      = mdict[@"isParised"];
                model.isReply        = mdict[@"isReply"];
                
                model.visited        = mdict[@"visited"];
//                NSLog(@"randid == %@",model.randId);
                model.weChat     = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                
//                NSLog(@"we chat is %@  and %@",model.weChat,mdict[@"body"][@"bdwx"]);
                model.detailModel = [[UserDetailModel alloc] init];
                model.detailModel.bdname = [self judgeIsNull:mdict[@"body"][@"bdname"]];
                model.detailModel.bdage  = mdict[@"body"][@"bdage"];
                model.detailModel.bdcity = [self judgeIsNull:mdict[@"body"][@"bdcity"]];
                model.detailModel.bddo   = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                model.detailModel.bdwx   = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                model.detailModel.bdjob  = [self judgeIsNull:mdict[@"body"][@"bdjob"]];
                model.detailModel.bdhobby= [self judgeIsNull:mdict[@"body"][@"bdhobby"]];
                model.detailModel.bdgender =[NSString stringWithFormat:@"%@",[self judgeIsNull:mdict[@"body"][@"bdgender"]]];
                model.detailModel.bdprovince = [self judgeIsNull:mdict[@"body"][@"bdprovince"]];
                model.detailModel.bdarea     = [self judgeIsNull:mdict[@"body"][@"bdarea"]];
                model.detailModel.randId     = mdict[@"randId"];
                model.detailModel.replyCount     = mdict[@"replys"];
                model.detailModel.zanCount       = mdict[@"collect"];
                model.detailModel.shareCount     = mdict[@"parised"];
                model.detailModel.bdID           =  mdict[@"id"];
                model.detailModel.visited        =  mdict[@"visited"];
                model.detailModel.isCollect      = mdict[@"isCollect"];
                model.detailModel.isParised      = mdict[@"isParised"];
                model.detailModel.isReply        = mdict[@"isReply"];
                
                model.detailModel.time           =  mdict[@"createdAt"];
                model.detailModel.imageArr       =  mdict[@"img"];
                [modelArray addObject:model];
            }
//            NSLog(@"block = %@",modelArray);
        }
        
        if (modelArray.count ==0)
        {
            [[AppDelegate sharedInstance] ShowAlert:@"已无更多数据"];
        }
        
        if (self.ReturnLoadDataWithArrBlock) {
            
            self.ReturnLoadDataWithArrBlock(modelArray);
//            NSLog(@"block = %@",modelArray);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [[AppDelegate sharedInstance] ShowAlert:@"网络不给力啊！！"];
    }];
    
}
/**
 *  四、接口名称： 获取用户的评论
 *
 */
-(void)getDataUserMessageBacWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"JSON---4----- = %@",responseObject);
        
        NSMutableArray * modelArray = [NSMutableArray array];
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1) {
            NSDictionary * dict = [responseObject valueForKeyPath:@"data"];
            
            NSMutableArray *array = dict[@"result"];
            for (NSDictionary * mdict in array) {
                CommentModel * model = [[CommentModel alloc] init];
                
                model.parentId      =  mdict[@"parentId"];
                model.createdAt     =  mdict[@"createdAt"];
                model.userFromName  =  [self judgeIsNull:mdict[@"userFromName"]];
                model.userFromImg   =  [self judgeIsNull: mdict[@"userFromImg"]];
                model.body          =  [self judgeIsNull:mdict[@"body"]];
                
                [modelArray addObject:model];
                
            }
            
        }
        if (modelArray.count ==0)
        {
            [[AppDelegate sharedInstance] ShowAlert:@"已无更多数据"];
        }
        if (self.ReturnLoadDataWithArrBlock)
        {
            self.ReturnLoadDataWithArrBlock(modelArray);
//            NSLog(@"block = %@",modelArray);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.ReturnErrorBlock) {
            self.ReturnErrorBlock(@"网络不稳定,请稍后再试");
        }
        NSLog(@"error = %@",error);
    }];
    
}
/**
 *  五、接口名称：获取用户信息
 *
 */
-(void)getUserIofoDataWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//        NSLog(@"JSON---5---%@",responseObject);
        userModel * model = [[userModel alloc] init];
        
       
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1) {
            NSDictionary *dataDict = [responseObject valueForKey:@"data"];
            
            model.username  = [self judgeIsNull:dataDict[@"username"]];
            model.phone     = [self judgeIsNull:dataDict[@"phone"]] ;
            model.desc      = [self judgeIsNull:dataDict[@"desc"]];
            model.gender    = dataDict[@"gender"];
            model.img       = [self judgeIsNull:dataDict[@"img"]];
            model.randId    = dataDict[@"randId"];
            model.age       = dataDict[@"age"];
            
        }

        if (self.ReturnLoadDataWithUserModelBlock) {
            self.ReturnLoadDataWithUserModelBlock(model);
//            NSLog(@"block = %@",[responseObject valueForKeyPath:@"info"]);
            
        }
        [self callBack:responseObject[@"code"] withStr:@"获取"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
    
}

/**
 *  六、接口名称：修改用户信息
 *
 */
-(void)getDataModifyUserInfoBacWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dataDict;
        userModel * model = [[userModel alloc] init];
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1) {
            dataDict = [responseObject valueForKey:@"data"];
            
            
            model.username  = [self judgeIsNull:dataDict[@"username"]];
            model.phone     = [self judgeIsNull:dataDict[@"phone"]] ;
            model.desc      = [self judgeIsNull:dataDict[@"desc"]];
            model.gender    = dataDict[@"gender"];
            model.img       = [self judgeIsNull:dataDict[@"img"]];
            model.randId    = [self judgeIsNull:dataDict[@"randId"]];
            model.age       = [self judgeIsNull:dataDict[@"age"]];
            
        }
        if (self.ReturnCodeBlock)
        {
            self.ReturnCodeBlock(status);
        }
        
        if (self.ReturnLoadDataWithUserModelBlock)
        {
            self.ReturnLoadDataWithUserModelBlock(model);
//            NSLog(@"接口2 info = %@",[responseObject valueForKeyPath:@"info"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error = %@",error);
        if (self.ReturnStrBlock) {
            self.ReturnStrBlock(@"修改失败");
        }

    }];
    
}
/**
 *  七、接口名称：获取最新列表
 *
 */
-(void)getNewWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         NSLog(@"block = %@",responseObject);
         NSMutableArray * modelArray = [NSMutableArray array];
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1) {
            NSDictionary * dict = [responseObject valueForKeyPath:@"data"];
           
            NSMutableArray *array = dict[@"result"];
            for (NSDictionary * mdict in array) {
                MainNavModel * model = [[MainNavModel alloc] init];
                model.username = [self judgeIsNull:mdict[@"userName"]];
                model.userImg  = [self judgeIsNull:mdict[@"userImg"]] ;
                model.bddo     = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                
                model.parised  =    mdict[@"shared"];
                model.collect  =    mdict[@"parised"];
                model.replys   =    mdict[@"replys"];
                
                model.createdAt= [self judgeIsNull: mdict[@"createdAt"]];
                model.mainNewID    = mdict[@"id"];
                model.userGender = mdict[@"userGender"];
                model.randId     = [self judgeIsNull:mdict[@"randId"]];
                
                model.isCollect      = mdict[@"isCollect"];
                model.isParised      = mdict[@"isParised"];
                model.isReply        = mdict[@"isReply"];
                model.visited        = mdict[@"visited"];
                
//                NSLog(@"randid == %@",model.randId);
                model.weChat     = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                
//                NSLog(@"we chat is %@  and %@",model.weChat,mdict[@"body"][@"bdwx"]);
                model.detailModel = [[UserDetailModel alloc] init];
                model.detailModel.bdname = [self judgeIsNull:mdict[@"body"][@"bdname"]];
                model.detailModel.bdage  = mdict[@"body"][@"bdage"];
                model.detailModel.bdcity = [self judgeIsNull:mdict[@"body"][@"bdcity"]];
                model.detailModel.bddo   = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                model.detailModel.bdwx   = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                model.detailModel.bdjob  = [self judgeIsNull:mdict[@"body"][@"bdjob"]];
                model.detailModel.bdhobby= [self judgeIsNull:mdict[@"body"][@"bdhobby"]];
                model.detailModel.bdgender =[NSString stringWithFormat:@"%@",[self judgeIsNull:mdict[@"body"][@"bdgender"]]];
                model.detailModel.bdprovince = [self judgeIsNull:mdict[@"body"][@"bdprovince"]];
                model.detailModel.bdarea     = [self judgeIsNull:mdict[@"body"][@"bdarea"]];
                model.detailModel.randId     = mdict[@"randId"];
                model.detailModel.replyCount     = mdict[@"replys"];
                model.detailModel.zanCount       = mdict[@"collect"];
                model.detailModel.shareCount     = mdict[@"parised"];
                model.detailModel.bdID           =  mdict[@"id"];
                model.detailModel.visited        =  mdict[@"visited"];
                model.detailModel.isCollect      = mdict[@"isCollect"];
                model.detailModel.isParised      = mdict[@"isParised"];
                model.detailModel.isReply        = mdict[@"isReply"];
                
                model.detailModel.time           =  mdict[@"createdAt"];
                model.detailModel.imageArr       =  mdict[@"img"];
                [modelArray addObject:model];
            }
//            NSLog(@"block = %@",modelArray);
        }
        if (modelArray.count ==0)
        {
           
            [[AppDelegate sharedInstance] ShowAlert:@"已无更多数据"];
        }
        
        if (self.ReturnLoadDataWithArrBlock) {
            
            self.ReturnLoadDataWithArrBlock(modelArray);
//            NSLog(@"block = %@",modelArray);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.ReturnErrorBlock) {
            self.ReturnErrorBlock(@"网络不稳定,请稍后再试");
        }
    }];
    
}

/**
 *  八、接口名称：获取推荐列表
 *
 */
-(void)getRecoWithUrl:(NSString*)url WithDic:(NSDictionary*)para{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
//        NSLog(@"-JSON --8 = %@",responseObject);

        NSMutableArray * modelArray = [NSMutableArray array];
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1)
        {
            NSDictionary * dict = [responseObject valueForKeyPath:@"data"];
            
            NSMutableArray *array = dict[@"result"];
            for (NSDictionary * mdict in array) {
                MainNavModel * model = [[MainNavModel alloc] init];
                model.username = [self judgeIsNull:mdict[@"userName"]];
                model.userImg  = [self judgeIsNull:mdict[@"userImg"]] ;
                model.bddo     = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                model.parised  =    mdict[@"shared"];
                model.collect  =    mdict[@"parised"];
                model.replys   =    mdict[@"replys"];
                model.createdAt= [self judgeIsNull: mdict[@"createdAt"]];
                model.userGender = mdict[@"userGender"];
                model.randId     = [self judgeIsNull:mdict[@"randId"]];
                model.weChat     = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                
                
                model.isCollect      = mdict[@"isCollect"];
                model.isParised      = mdict[@"isParised"];
                model.isReply        = mdict[@"isReply"];
                model.visited        = mdict[@"visited"];

                model.mainNewID    = mdict[@"id"];
                model.detailModel = [[UserDetailModel alloc] init];
                model.detailModel.bdname = [self judgeIsNull:mdict[@"body"][@"bdname"]];
                model.detailModel.bdage  = mdict[@"body"][@"bdage"];
                model.detailModel.bdcity = [self judgeIsNull:mdict[@"body"][@"bdcity"]];
                model.detailModel.bddo   = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                model.detailModel.bdwx   = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                model.detailModel.bdjob  = [self judgeIsNull:mdict[@"body"][@"bdjob"]];
                model.detailModel.bdhobby= [self judgeIsNull:mdict[@"body"][@"bdhobby"]];
                model.detailModel.bdgender =[self judgeIsNull:mdict[@"body"][@"bdgender"]];
                model.detailModel.bdprovince = [self judgeIsNull:mdict[@"body"][@"bdprovince"]];
                model.detailModel.bdarea     = [self judgeIsNull:mdict[@"body"][@"bdarea"]];
                model.detailModel.randId     = mdict[@"randId"];
                model.detailModel.replyCount     = mdict[@"replys"];
                model.detailModel.zanCount       = mdict[@"collect"];
                model.detailModel.shareCount     = mdict[@"parised"];
                model.detailModel.bdID           =  mdict[@"id"];
                model.detailModel.visited        =  mdict[@"visited"];
                model.detailModel.isCollect      = mdict[@"isCollect"];
                model.detailModel.isParised      = mdict[@"isParised"];
                model.detailModel.isReply        = mdict[@"isReply"];
                
                model.detailModel.time           =  mdict[@"createdAt"];
                model.detailModel.imageArr       =  mdict[@"img"];
                [modelArray addObject:model];
            }
        }
        if (modelArray.count ==0)
        {
            [[AppDelegate sharedInstance] ShowAlert:@"已无更多数据"];
        }
        
        if (self.ReturnLoadDataWithArrBlock)
        {
            self.ReturnLoadDataWithArrBlock(modelArray);
            
        }
        
        
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"error = %@",error);
        if (self.ReturnErrorBlock)
        {
            self.ReturnErrorBlock(@"网络不稳定,请稍后再试");
        }
    }];
    
}

/**
 *  九、接口名称：发布档案
 *
 */
-(void)getBuildFileWithUrl:(NSString*)url WithDic:(NSDictionary*)para{
    

    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];

    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"block = %@",responseObject);
//        NSLog(@"%@",responseObject);
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1)
        {
            
            
        }
        
        if (self.ReturnStrBlock)
        {
            self.ReturnStrBlock([responseObject valueForKeyPath:@"info"]);
//            NSLog(@"block = %@",[responseObject valueForKeyPath:@"info"]);
            
        }
        [[AppDelegate sharedInstance] ShowAlert:[responseObject valueForKeyPath:@"info"]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[AppDelegate sharedInstance] ShowAlert:@"网络不给力啊！！"];
    }];
    

    
}

/**
 *  十、接口名称：获取动态详情的评论
 *
 */
-(void)getCommentWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
//        NSLog(@"JSON --10--- %@",responseObject);
        
        NSMutableArray * modelArray = [NSMutableArray array];
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1) {
            NSDictionary * dict = [responseObject valueForKeyPath:@"data"];
            
            NSMutableArray *array = dict[@"result"];
            for (NSDictionary * mdict in array) {
                CommentModel * model = [[CommentModel alloc] init];
                model.userFromId    =  mdict[@"userFromId"];
                model.userToId      =  mdict[@"userToId"] ;
                model.userFromName  =  [self judgeIsNull:mdict[@"userFrom"]];
                model.userToName    =  [self judgeIsNull: mdict[@"userTo"]];
                model.userFromImg   =  [self judgeIsNull: mdict[@"userFromImg"]];
                model.userToImg     =  [self judgeIsNull: mdict[@"userToImg"]];
                model.createdAt     =  [self judgeIsNull: mdict[@"createdAt"]];
                model.userToGender  =  [self judgeIsNull:mdict[@"userToGender"]];
                model.userFromGender     = mdict[@"userFromGender"];
                model.body          =  [self judgeIsNull:mdict[@"body"]];

                
                [modelArray addObject:model];

        }
        
        }
        if (self.ReturnCodeBlock)
        {
            self.ReturnCodeBlock(status);
        }
//        if (modelArray.count ==0)
//        {
//            NSLog(@"----------%d",modelArray.count);
//            [[AppDelegate sharedInstance] ShowAlert:@"已无更多评论数据"];
//        }
        if (self.ReturnLoadDataWithArrBlock) {
            
            self.ReturnLoadDataWithArrBlock(modelArray);
//            NSLog(@"block = %@",modelArray);
            
        }

        
        [self callBack:responseObject[@"code"] withStr:@"获取评论"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
    
}

/**
 *  十一、接口名称：新增回复
 *
 */
-(void)getNewCommentWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (self.ReturnStrBlock)
        {
            self.ReturnStrBlock(responseObject[@"info"]);
        }
        
//        NSLog(@"---JSON--%@",responseObject);
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate sharedInstance] ShowAlert:@"网络不给力啊~~"];
        
        NSLog(@"error = %@",error);
    }];
    
}

/**
 * 十二、接口名称：动态点赞
 *
 */
-(void)getDataZanBacWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        
        if (self.ReturnCodeBlock)
        {
            self.ReturnCodeBlock(status);
        }


        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"error = %@",error);
    }];
    
}

/**
 *  十四，得到个人数据
 *
 */
-(void)getSelfPubDataWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         NSLog(@"block = %@",responseObject);
         NSMutableArray * modelArray = [NSMutableArray array];
         NSNumber * status       = [responseObject valueForKeyPath:@"code"];
         if ([status intValue]==1) {
             NSDictionary * mdict = [responseObject valueForKeyPath:@"data"];

                 MainNavModel * model = [[MainNavModel alloc] init];
                 model.username = [self judgeIsNull:mdict[@"userName"]];
                 model.userImg  = [self judgeIsNull:mdict[@"userImg"]] ;
                 model.bddo     = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                 
                 model.parised  =    mdict[@"shared"];
                 model.collect  =    mdict[@"parised"];
                 model.replys   =    mdict[@"replys"];
                 
                 model.createdAt= [self judgeIsNull: mdict[@"createdAt"]];
                 model.mainNewID    = mdict[@"id"];
                 model.userGender = mdict[@"userGender"];
                 model.randId     = [self judgeIsNull:mdict[@"randId"]];
                 
                 model.isCollect      = mdict[@"isCollect"];
                 model.isParised      = mdict[@"isParised"];
                 model.isReply        = mdict[@"isReply"];
                 model.visited        = mdict[@"visited"];
                 
//                 NSLog(@"randid == %@",model.randId);
                 model.weChat     = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                 
//                 NSLog(@"we chat is %@  and %@",model.weChat,mdict[@"body"][@"bdwx"]);
                 model.detailModel = [[UserDetailModel alloc] init];
                 model.detailModel.bdname = [self judgeIsNull:mdict[@"body"][@"bdname"]];
                 model.detailModel.bdage  = mdict[@"body"][@"bdage"];
                 model.detailModel.bdcity = [self judgeIsNull:mdict[@"body"][@"bdcity"]];
                 model.detailModel.bddo   = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                 model.detailModel.bdwx   = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                 model.detailModel.bdjob  = [self judgeIsNull:mdict[@"body"][@"bdjob"]];
                 model.detailModel.bdhobby= [self judgeIsNull:mdict[@"body"][@"bdhobby"]];
                 model.detailModel.bdgender =[NSString stringWithFormat:@"%@",[self judgeIsNull:mdict[@"body"][@"bdgender"]]];
                 model.detailModel.bdprovince = [self judgeIsNull:mdict[@"body"][@"bdprovince"]];
                 model.detailModel.bdarea     = [self judgeIsNull:mdict[@"body"][@"bdarea"]];
                 model.detailModel.randId     = mdict[@"randId"];
                 model.detailModel.replyCount     = mdict[@"replys"];
                 model.detailModel.zanCount       = mdict[@"collect"];
                 model.detailModel.shareCount     = mdict[@"parised"];
                 model.detailModel.bdID           =  mdict[@"id"];
                 model.detailModel.visited        =  mdict[@"visited"];
                 model.detailModel.isCollect      = mdict[@"isCollect"];
                 model.detailModel.isParised      = mdict[@"isParised"];
                 model.detailModel.isReply        = mdict[@"isReply"];
                 
                 model.detailModel.time           =  mdict[@"createdAt"];
                 model.detailModel.imageArr       =  mdict[@"img"];
                 [modelArray addObject:model];
             
             if (self.ReturnLoadDataWithArrBlock)
             {
                 self.ReturnLoadDataWithArrBlock(modelArray);
             }
             }



         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate sharedInstance] ShowAlert:@"加载失败"];
         NSLog(@"error = %@",error);
     }];
    
}


/**
 *  十五、接口名称： 删除动态
 *
 */
-(void)getdelePubDataWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{

    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        

        NSNumber * status       = [responseObject valueForKeyPath:@"code"];

        if (self.ReturnCodeBlock)
        {
            self.ReturnCodeBlock(status);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error = %@",error);
    }];
    
}

/**
 *  十六、接口名称：举报
 *
 */
-(void)getDataReportWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (self.ReturnCodeBlock)
         {
             self.ReturnCodeBlock(responseObject[@"code"]);
             
         }
         
//         NSLog(@"--JSON--16--%@",responseObject);
//         if([responseObject[@"code"] intValue]==1)
//         {
//             [[AppDelegate sharedInstance] ShowAlert:@"举报成功"];
//         }else
//         {
//             [[AppDelegate sharedInstance] ShowAlert:@"举报失败"];
//         }

         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error = %@",error);
     }];
    
}

/**
 *十七、接口名称:提交反馈：/feedback/create
 *
 */
-(void)getDataFeedBacWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
//         NSLog(@"--JSON--17--%@",responseObject);
         
         [self callBack:responseObject[@"code"] withStr:@"反馈"];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error = %@",error);
     }];
    
}
/**
 *  十九、接口名称：获取广告
 */
-(void)getAdDataWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];

    [self.mgr GET:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//        NSLog(@"JSON --19--- %@",responseObject);
 
            NSMutableArray *data = responseObject[@"data"];
            if (data.count)
            {
                if (self.ReturnLoadDataWithArrBlock)
                {
                    self.ReturnLoadDataWithArrBlock(data);
                }
                
//                NSLog(@"my data = %@",responseObject[@"data"]);
            }
            
    
        
        [self callBack:responseObject[@"code"] withStr:@"获取广告"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@",error);
    }];
    
    
}

/**
 *  二十二、接口名称：启动图
 */
-(void)getLauchImageWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];

    [self.mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@" %@",responseObject);
        if (self.ReturnLoadDataWithDictBlock) {
            self.ReturnLoadDataWithDictBlock(responseObject);
        }
        
        [self callBack:responseObject[@"code"] withStr:@"发布档案"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"%@",error);
    }];

    
}

/**
 *  二十五、接口名称：搜索结果
 */
-(void)getSearchDataWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"block = %@",responseObject);
        NSMutableArray * modelArray = [NSMutableArray array];
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        if ([status intValue]==1) {
            NSDictionary * dict = [responseObject valueForKeyPath:@"data"];
            
            NSMutableArray *array = dict[@"result"];
            for (NSDictionary * mdict in array) {
                MainNavModel * model = [[MainNavModel alloc] init];
                model.username = [self judgeIsNull:mdict[@"userName"]];
                model.userImg  = [self judgeIsNull:mdict[@"userImg"]] ;
                model.bddo     = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                
                model.parised  =    mdict[@"shared"];
                model.collect  =    mdict[@"parised"];
                model.replys   =    mdict[@"replys"];
                
                model.createdAt= [self judgeIsNull: mdict[@"createdAt"]];
                model.mainNewID    = mdict[@"id"];
                model.userGender = mdict[@"userGender"];
                model.randId     = [self judgeIsNull:mdict[@"randId"]];
                
                model.isCollect      = mdict[@"isCollect"];
                model.isParised      = mdict[@"isParised"];
                model.isReply        = mdict[@"isReply"];
                model.visited        = mdict[@"visited"];
                
//                NSLog(@"randid == %@",model.randId);
                model.weChat     = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                
//                NSLog(@"we chat is %@  and %@",model.weChat,mdict[@"body"][@"bdwx"]);
                model.detailModel = [[UserDetailModel alloc] init];
                model.detailModel.bdname = [self judgeIsNull:mdict[@"body"][@"bdname"]];
                model.detailModel.bdage  = mdict[@"body"][@"bdage"];
                model.detailModel.bdcity = [self judgeIsNull:mdict[@"body"][@"bdcity"]];
                model.detailModel.bddo   = [self judgeIsNull:mdict[@"body"][@"bddo"]];
                model.detailModel.bdwx   = [self judgeIsNull:mdict[@"body"][@"bdwx"]];
                model.detailModel.bdjob  = [self judgeIsNull:mdict[@"body"][@"bdjob"]];
                model.detailModel.bdhobby= [self judgeIsNull:mdict[@"body"][@"bdhobby"]];
                model.detailModel.bdgender =[NSString stringWithFormat:@"%@",[self judgeIsNull:mdict[@"body"][@"bdgender"]]];
                model.detailModel.bdprovince = [self judgeIsNull:mdict[@"body"][@"bdprovince"]];
                model.detailModel.bdarea     = [self judgeIsNull:mdict[@"body"][@"bdarea"]];
                model.detailModel.randId     = mdict[@"randId"];
                model.detailModel.replyCount     = mdict[@"replys"];
                model.detailModel.zanCount       = mdict[@"collect"];
                model.detailModel.shareCount     = mdict[@"parised"];
                model.detailModel.bdID           =  mdict[@"id"];
                
                model.detailModel.isCollect      = mdict[@"isCollect"];
                model.detailModel.isParised      = mdict[@"isParised"];
                model.detailModel.isReply        = mdict[@"isReply"];
                
                model.detailModel.time           =  mdict[@"createdAt"];
                model.detailModel.imageArr       =  mdict[@"img"];
                model.detailModel.visited        =  mdict[@"visited"];
                [modelArray addObject:model];
            }
//            NSLog(@"block = %@",modelArray);
        }
//        NSLog(@"----------%d",modelArray.count);
//        if (modelArray.count ==0)
//        {
//            NSLog(@"----------%d",modelArray.count);
//            [[AppDelegate sharedInstance] ShowAlert:@"已无更多数据"];
//            
//        }
        if (self.ReturnLoadDataWithArrBlock) {
            

            self.ReturnLoadDataWithArrBlock(modelArray);
//            NSLog(@"block = %@",modelArray);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.ReturnErrorBlock) {
            self.ReturnErrorBlock(@"网络不稳定,请稍后再试");
        }
    }];
}
/**
 *  三十 提交图片
 *
 */
-(void)getDataPostImageWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    //@"http://api.rm520.cn/api/"
    [self.mgr POST:@"http://api.rm520.cn/api/uploadbase64" parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
//         NSLog(@"%@",responseObject);
//         NSLog(@"--------%@",responseObject[@"info"]);
         
         NSNumber * status       = [responseObject valueForKeyPath:@"code"];
         
        if ([status intValue]==1)
        {
            if (self.ReturnStrBlock)
            {
                self.ReturnStrBlock([responseObject valueForKeyPath:@"data"][@"img"]);
                
            }
            
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",error);
    }];
    
}

/**
 *  二十六、接口名称:
 *
 */
-(void)getLocationWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
//        NSLog(@"block = %@",responseObject);
        
        NSNumber * status       = [responseObject valueForKeyPath:@"code"];
        
        if ([status intValue]==1)
        {
            
            
        }
        
        [self callBack:responseObject[@"code"] withStr:@"发布档案"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"error = %@",error);
    }];

}


/**
 *  三十一、接口名称：举报
 *
 */
-(void)getDataRefreshtotopWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
   url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
//         NSLog(@"--JSON--31--%@",responseObject);
//         NSLog(@"info------%@",responseObject[@"info"]);
         if (self.ReturnStrBlock)
         {
             self.ReturnStrBlock(responseObject[@"info"]);
         }
        
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error = %@",error);
     }];
    
}

/**
 *  三十二、接口名称：上线判断
 *
 */
-(void)getJudegKeyDataWithUrl:(NSString*)url WithDic:(NSDictionary*)para
{
    
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
//         NSLog(@"--JSON--32--%@",responseObject);
//         NSLog(@"info------%@",responseObject[@"code"]);
         if (self.ReturnCodeBlock)
         {
             self.ReturnCodeBlock(responseObject[@"code"]);
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error = %@",error);
     }];
    
}
/**
 *  三十三、接口名称：获取热搜词汇
 *
 */
-(void)getHotWordsDataWithUrl:(NSString *)url WithDic:(NSDictionary *)para
{
    url = [NSString stringWithFormat:@"%@%@",urlStr,url];
    [self.mgr POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
//         NSLog(@"--JSON--32--%@",responseObject);
//         NSLog(@"info------%@",responseObject[@"info"]);
         if (self.ReturnLoadDataWithArrBlock)
         {
             self.ReturnLoadDataWithArrBlock(responseObject[@"data"]);
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error = %@",error);
     }];
}
-(NSString*)judgeIsNull:(id)Str
{
    if (![Str isKindOfClass:[NSNull class]])
    {
        return Str;
    }
    return @"";
    
}

@end
