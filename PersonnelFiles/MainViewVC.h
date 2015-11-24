//
//  MainViewVC.h
//  PersonnelFiles
//
//  Created by Solo on 15/6/3.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlartViewController.h"
#import "MainSearchVC.h"
#import "MainSearchBar.h"
@interface MainViewVC : UIViewController<ExpendableAlartViewDelegate,MainSearchBarDelegate>
@property(nonatomic,strong)NSNumber *sexNumber;




//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSMutableArray *fromArray;
@property (strong, nonatomic) NSMutableArray *toArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;




@property (strong, nonatomic) UIView *maskView;


@property(nonatomic,strong)NSNumber *loginCount;
@property(strong,nonatomic)MainSearchBar * mainSearchBarSet;
@end
