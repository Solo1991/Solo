//
//  MainSearchBar.m
//  PersonnelFiles
//
//  Created by Solo on 15/7/15.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "MainSearchBar.h"

@interface MainSearchBar ()<UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation MainSearchBar

-(void)viewWillAppear:(BOOL)animated
{
    [self getPickerData];
    //年龄段默认出现在1980-1989
    [self.myPicker selectRow:7 inComponent:0 animated:NO];
    [self pickerView:self.myPicker didSelectRow:7 inComponent:0];
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

     [self initView];
//    self.fromArray = [NSMutableArray array];
//    self.toArray = [NSMutableArray array];
    self.myPicker.delegate = self;
    self.myPicker.dataSource =self;
   
    

}

#pragma mark - init view
- (void)initView
{
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    
    self.pickerBgView.width = MainWidth;
}

-(void)openPickVCWith:(UIView*)superView
{
    [superView addSubview:self.maskView];
    [superView addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.top = superView.height;
    
    [UIView animateWithDuration:0.3 animations:^
     {
         self.maskView.alpha = 0.3;
         self.pickerBgView.bottom = superView.height;
     }];

}
#pragma mark - get data
- (void)getPickerData
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Age.plist" ofType:nil];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray * arr = [NSArray arrayWithArray:[self.pickerDic allKeys]];
    //字典中所有key值从小到大排序
    NSArray *sortedArray = [arr sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 intValue] > [obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    
//    self.fromArray[0] = arr.lastObject;
    
//    for (int count =0; count<arr.count; count++)
//    {
        self.fromArray = sortedArray;
   
//     }
//    for (int count = 0; count < arr.count; count++)
//    {
//        NSLog(@"--------%@-------%@",self.fromArray[count],arr[count]);
//    }
    self.toArray = [self.pickerDic objectForKey:[self.fromArray objectAtIndex:7]];
    
    
//    if (self.selectedArray.count > 0)
//    {
//        self.toArray[0] = self.selectedArray.lastObject;
//        NSLog(@"-------self.arr------%@",self.toArray[0]);
//        for (int count =0; count<arr.count; count++)
//        {
//            [self.toArray addObject:self.selectedArray[count]];
//        }
//    }
    
    
}

#pragma mark - UIPicker Delegate.0
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
//    self.selectedArray = [self.pickerDic objectForKey:[self.fromArray objectAtIndex:0]];
    if (component == 0)
    {
        return self.fromArray.count;
    } else
    {
//        if (!self.toArray)
//        {
//            self.toArray = self.selectedArray;
//        }
        
        return self.toArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.fromArray objectAtIndex:row];
    } else
    {
        return [self.toArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 110;
    } else if (component == 1)
    {
        return 100;
    } else
    {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.toArray = [self.pickerDic objectForKey:[self.fromArray objectAtIndex:row]];
//        
//        if (self.selectedArray.count > 0)
//        {
//            self.toArray = self.selectedArray ;
//        } else
//        {
//            self.toArray = nil;
//        }
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
            

        
    }
    
//    [pickerView selectedRowInComponent:1];
    
    
    
}


- (void)hideMyPicker
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.maskView.alpha = 0;
         self.pickerBgView.top = MainHeight;
     } completion:^(BOOL finished)
     {
         [self.maskView removeFromSuperview];
         [self.pickerBgView removeFromSuperview];
     }];
}




- (IBAction)cancelBtn:(id)sender
{
    [self hideMyPicker];
    if (self.delegate)
    {
        [self.delegate cancelBtn:@"年龄段"];
    }
}

- (IBAction)sureBtn:(id)sender
{
    [self hideMyPicker];
    if (self.delegate)
    {
        NSString * str = [self.toArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
        if ([str isEqualToString:@"至今"]) {
            str = @"0000";
        }
        [self.delegate sureBtn:[NSString stringWithFormat:@"%@%@",[self.fromArray objectAtIndex:[self.myPicker selectedRowInComponent:0]]
                                ,str]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
