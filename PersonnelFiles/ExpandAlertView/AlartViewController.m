//
//  AlartViewController.m
//  MyReader
//
//  Created by broy denty on 14-8-4.
//  Copyright (c) 2014年 denty. All rights reserved.
//

#import "AlartViewController.h"
#import "quickMethod.h"
@interface AlartViewController ()

@end

@implementation AlartViewController
{
    UIView *positiveView;
    UIView *negativeView;
    UIButton *cancelButton;
    UILabel *titleLabel;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor  colorWithRed:0 green:0 blue:0 alpha:0.5]];
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(40, -70, MainWidth-80, 120)];
    [self.titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.titleView];
    
    positiveView = [[UIView alloc] init];
    [positiveView setFrame:CGRectMake(MainWidth/2-40, 90, MainWidth/2-40, 50)];
    [positiveView.layer setAnchorPoint:CGPointMake(0.5, 1)];
    [positiveView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:93.0/255.0 blue:56.0/255.0 alpha:1]];
    [positiveView.layer setZPosition:-1];
    
    UILabel *positiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth/2-40, 50)];
    positiveLabel.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    [positiveLabel setText:self.strArr[1]];
    [positiveLabel setTextAlignment:NSTextAlignmentCenter];
    [positiveLabel setTextColor:[UIColor lightTextColor]];
    [positiveView addSubview:positiveLabel];
    [self.titleView addSubview:positiveView];
    
    negativeView = [[UIView alloc] init];
    [negativeView setFrame:CGRectMake(0, 90, MainWidth/2-40, 50)];
    [negativeView.layer setAnchorPoint:CGPointMake(0.5, 1)];
    [negativeView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:118.0/255.0 blue:70.0/255.0 alpha:1]];
    [negativeView.layer setZPosition:-1];
    
    UILabel *negativeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 50)];
    negativeLabel.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    [negativeLabel setText:self.strArr[2]];
    [negativeLabel setTextAlignment:NSTextAlignmentCenter];
    [negativeLabel setTextColor:[UIColor lightTextColor]];
    [negativeView addSubview:negativeLabel];
    [self.titleView addSubview:negativeView];
    
    //提示主页
    UIView* titleHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.titleView.frame.size.width, self.titleView.frame.size.height)];
    [titleHolder setBackgroundColor:[UIColor colorWithRed:252.0/255.0 green:108.0/255.0 blue:64.0/255.0 alpha:1]];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, titleHolder.width-40, 120)];
    [titleLabel setText:self.strArr[0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor lightTextColor]];
    [titleHolder addSubview:titleLabel];
    titleLabel.numberOfLines =2;
    [self.titleView addSubview:titleHolder];
    [self.titleView.layer setZPosition:1];
    
    
//    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(145, 600, 30, 30)];
//    [cancelButton.layer setBorderColor:[UIColor lightTextColor].CGColor];
//    [cancelButton.layer setBorderWidth:1];
//    [cancelButton.layer setCornerRadius:15];
//    [cancelButton setTitle:@"x" forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelButton];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nagetiveAction:)];
    [self.view addGestureRecognizer:gesture];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:0.25 animations:^{
        [self.titleView setFrame:CGRectMake(self.titleView.frame.origin.x, 160, self.titleView.frame.size.width, self.titleView.frame.size.height)];
    }];
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    [animation setDelegate:self];
    animation.values = @[@(M_PI/64),@(-M_PI/64),@(M_PI/64),@(0)];
    animation.duration = 0.5;
    [animation setKeyPath:@"transform.rotation"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.titleView.layer addAnimation:animation forKey:@"shake"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showView:(UIViewController *)VC
{
    [VC addChildViewController:self];
    self.view.frame = VC.view.bounds;
    [VC.view addSubview:self.view];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag == YES) {
        if ([anim isEqual:[self.titleView.layer animationForKey:@"shake"]])
        {
            CATransform3D trans = CATransform3DPerspect(CATransform3DMakeRotation(-M_PI-0.001, 1, 0, 0), CGPointMake(0, 0), 200) ;
            CABasicAnimation *animation = [[CABasicAnimation alloc] init];
            [animation setDelegate:self];
            animation.keyPath = @"transform";
            animation.toValue = [NSValue valueWithCATransform3D:trans];
            animation.duration = 0.25;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            [positiveView.layer addAnimation:animation forKey:@"rotate"];
        }
        else if([anim isEqual:[positiveView.layer animationForKey:@"rotate"]])
        {
            CATransform3D trans = CATransform3DPerspect(CATransform3DMakeRotation(-M_PI-0.0001, 1, 0, 0), CGPointMake(0, 0), 200) ;
            CABasicAnimation *animation = [[CABasicAnimation alloc] init];
            [animation setDelegate:self];
            animation.keyPath = @"transform";
            animation.toValue = [NSValue valueWithCATransform3D:trans];
            animation.duration = 0.25;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            [negativeView.layer addAnimation:animation forKey:@"rotate"];
        }
      
        else if([anim isEqual:[self.titleView.layer animationForKey:@"rotate"]])
        {
            [UIView animateWithDuration:0.3 animations:^{
                [positiveView setHeight:YES];
                [negativeView setHeight:YES];
                [titleLabel setText:self.strArr[3]];
                [self performSelector:@selector(cancelAction) withObject:self afterDelay:1];
        }];


        }

    }
}

CA_EXTERN CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CA_EXTERN CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

- (void)cancelClick
{
    [self.expendAbleAlartViewDelegate closeButtonAction];
    [self cancelAction];
}

- (void)cancelAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, 790, cancelButton.frame.size.width, cancelButton.frame.size.height)];
        [self.titleView setFrame:CGRectMake(self.titleView.frame.origin.x, 600, self.titleView.frame.size.width, self.titleView.frame.size.height)];
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)nagetiveAction:(UIGestureRecognizer*) gesture
{
    
    CGPoint touchPoint = [gesture locationInView:self.titleView];
    if ([negativeView.layer.presentationLayer hitTest:touchPoint])
    {
        [self.expendAbleAlartViewDelegate negativeButtonAction];
        [self cancelAction];
    }
    else if([positiveView.layer.presentationLayer hitTest:touchPoint])
    {
        [self.expendAbleAlartViewDelegate positiveButtonAction];
        if (self.titleView.layer.animationKeys.count>1)
        {
            CATransform3D transFrom = CATransform3DPerspect(CATransform3DMakeRotation(-M_PI-0.5, 1, 0, 0), CGPointMake(0, 0), 200);
            CATransform3D trans = CATransform3DIdentity ;
            CABasicAnimation *animation = [[CABasicAnimation alloc] init];
            [animation setDelegate:self];
            animation.keyPath = @"transform";
            animation.fromValue = [NSValue valueWithCATransform3D:transFrom];
            animation.toValue = [NSValue valueWithCATransform3D:trans];
            animation.duration = 0.25;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            [positiveView.layer addAnimation:animation forKey:@"close"];
        }else
        {
            CATransform3D trans = CATransform3DPerspect(CATransform3DMakeRotation(-M_PI-0.0001, 0, 1, 0), CGPointMake(0, 0), 200) ;
            CABasicAnimation *animation = [[CABasicAnimation alloc] init];
            [animation setDelegate:self];
            animation.keyPath = @"transform";
            animation.toValue = [NSValue valueWithCATransform3D:trans];
            animation.duration = 0.5;
            animation.removedOnCompletion = NO;
            [self.titleView.layer addAnimation:animation forKey:@"rotate"];
        }
    }
}
@end
