//
//  MainSearchBar.h
//  PersonnelFiles
//
//  Created by Solo on 15/7/15.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainSearchBarDelegate

-(void)sureBtn:(NSString*)sureStr;

-(void)cancelBtn:(NSString*)cancelStr;
@end
@interface MainSearchBar : UIViewController

/**
 *  遮罩
 */
@property (strong, nonatomic) UIView *maskView;

@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;

@property (strong, nonatomic) IBOutlet UIView *pickerBgView;

@property(assign,nonatomic)id<MainSearchBarDelegate> delegate;

@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *fromArray;
@property (strong, nonatomic) NSArray *toArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;


-(void)openPickVCWith:(UIView*)superView;
@end
