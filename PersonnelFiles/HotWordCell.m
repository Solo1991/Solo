//
//  HotWordCell.m
//  HotWordForSearchView
//
//  Created by Simons on 15/8/13.
//  Copyright (c) 2015年 Simons. All rights reserved.
//

#import "HotWordCell.h"

@implementation HotWordCell

- (void)awakeFromNib {
    // Initialization code
    self.hotWordLab.textColor = [UIColor whiteColor];
//    self.hotWordLab.font = [UIFont systemFontOfSize:12];
    self.hotWordLab.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.hotWordLab.layer.cornerRadius = 3;
    [self.hotWordLab sizeToFit];
}

@end
