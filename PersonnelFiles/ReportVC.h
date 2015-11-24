//
//  ReportVC.h
//  PersonnelFiles
//
//  Created by Solo on 15/7/2.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reportCell.h"
#import "LoadData.h"
#import "AppDelegate.h"
#import "LoginTool.h"
@interface ReportVC : UITableViewController
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)NSNumber *berandId;
@property(nonatomic,strong)NSNumber *beid;
@end
