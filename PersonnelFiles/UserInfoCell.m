//
//  UserInfoCell.m
//  PersonnelFiles
//
//  Created by Solo on 15/6/20.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "UserInfoCell.h"
#import "quickMethod.h"
@implementation UserInfoCell

- (void)awakeFromNib
{
    // Initialization code
    [quickMethod doCornerRadiusWith:self.headImageView WithRadius:25 WithBorderWidth:1 WithColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToPerson)];
    [self.headImageView addGestureRecognizer:tap];

}

-(void)turnToPerson
{
  
    if (self.PushToPersonVC)
    {
         self.PushToPersonVC(self.indexRow);
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
