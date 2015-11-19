//
//  DetailViewController.h
//  TEST
//
//  Created by System Administrator on 15/11/19.
//  Copyright © 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

