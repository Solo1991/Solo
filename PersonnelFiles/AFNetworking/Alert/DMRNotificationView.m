//
//  DMRNotificationView.m
//  UChAT
//
//  Created by Alan on 14-5-7.
//  Copyright (c) 2014年 LanMix. All rights reserved.
//



#import "DMRNotificationView.h"

// Change these values to match your needs...
static CGFloat kNotificationViewTintColorTransparency = 0.80;           // Default tint color transparency
//static NSTimeInterval kNotificationViewDefaultHideTimeInterval = 10;   // Number of seconds until auto dismiss
static CGFloat kNotificationViewVerticalInset = 25.0;                   // Top and bottom inset
static CGFloat kNotificationViewLabelVerticalPadding = 5.0;             // Distance between title and subtitle
static CGFloat kNotificationViewShadowOffset = 5.0;                     // Shadow offset

@implementation DMRNotificationView

-(void)dealloc
{
    [self setDidTapHandler:nil];
}




#pragma mark -
#pragma mark Default Initializer

-(id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle targetView:(UIView *)view HideTimeInterval:(int)time {
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setContentMode:UIViewContentModeRedraw];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        [self setTitle:title];
        [self setSubTitle:subTitle];
        [self setTargetView:view];
        [self setIsTransparent:YES];
        [self setTintColor:[UIColor colorWithRed:0.133 green:0.267 blue:0.533 alpha:1.000]];
        [self setHideTimeInterval:time];
    }
    return self;
}



#pragma mark -
#pragma mark Convenience Initializers

+(void)showInView:(UIView *)view title:(NSString *)title subTitle:(NSString *)subTitle HideTimeInterVal:(int)time
{
    [self showInView:view title:title subTitle:subTitle tintColor:nil HideTimeInterval:time];
}

+(void)showInView:(UIView *)view title:(NSString *)title subTitle:(NSString *)subTitle tintColor:(UIColor *)tintColor HideTimeInterval:(int)time
{
    DMRNotificationView *notificationView = [[self alloc] initWithTitle:title subTitle:subTitle targetView:view HideTimeInterval:time];
    
    if (tintColor)
        [notificationView setTintColor:tintColor];
    
    [notificationView showAnimated:YES];
}



+(void)showWarningInView:(UIView *)view title:(NSString *)title subTitle:(NSString *)subTitle HideTimeInterVal:(int)time
{
    [self showInView:view title:title subTitle:subTitle tintColor:[self tintColorForType:DMRNotificationViewTypeWarning] HideTimeInterval:time];
}

+(void)showSuccessInView:(UIView *)view title:(NSString *)title subTitle:(NSString *)subTitle HideTimeInterVal:(int)time
{
    [self showInView:view title:title subTitle:subTitle tintColor:[self tintColorForType:DMRNotificationViewTypeSuccess] HideTimeInterval:time];
}




#pragma mark -
#pragma mark Drawing

-(void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ref);
    
    // Tint color
    CGContextSetFillColorWithColor(ref, _tintColor.CGColor);
    CGContextFillRect(ref, CGRectMake(rect.origin.x, rect.origin.y+64, rect.size.width, rect.size.height-kNotificationViewShadowOffset));
    
    CGContextRestoreGState(ref);
    UIColor *textColor = [self textColor];                  // Depends on fillColor
    CGFloat labelVerticalPosition = kNotificationViewVerticalInset;
    
    // Title
    if (_title.length > 0)
    {
        [textColor set];
        CGSize titleSize = [self expectedTitleSize];
        
        /*
        [_title drawInRect:CGRectMake(10.0, labelVerticalPosition+39, _targetView.bounds.size.width-20.0, titleSize.height)
                  withFont:[self titleFont]
             lineBreakMode:NSLineBreakByWordWrapping
                 alignment:NSTextAlignmentCenter];
         */
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment     = NSTextAlignmentCenter;
        
        CGRect  titleFrame  = CGRectMake(10.0, labelVerticalPosition+39, _targetView.bounds.size.width-20.0, titleSize.height);
        
        NSDictionary  *dic  = [NSDictionary dictionaryWithObjectsAndKeys:[self titleFont], NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
        [_title drawInRect:titleFrame withAttributes:dic];
        
        labelVerticalPosition += titleSize.height+kNotificationViewLabelVerticalPadding;
    }
    
    // Subtitle
    if (_subTitle.length > 0)
    {
        [textColor set];
        CGSize subTitleSize = [self expectedSubTitleSize];
        
        //if (textIncludesShadow)
            //CGContextSetShadowWithColor(ref, CGSizeMake(0.0, -1.0), 0.0, [UIColor colorWithWhite:0.0 alpha:0.3].CGColor);
        /*
        [_subTitle drawInRect:CGRectMake((_targetView.bounds.size.width-subTitleSize.width)/2, labelVerticalPosition+32, _targetView.bounds.size.width-20.0, subTitleSize.height)
                     withFont:[self subTitleFont]
                lineBreakMode:NSLineBreakByWordWrapping];
         */
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGRect titleFrame  = CGRectMake((_targetView.bounds.size.width-subTitleSize.width)/2, labelVerticalPosition+32, _targetView.bounds.size.width-20.0, subTitleSize.height);
        NSDictionary  *dic  = [NSDictionary dictionaryWithObjectsAndKeys:[self subTitleFont], NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil];
        [_subTitle drawInRect:titleFrame withAttributes:dic];
    }
    
    // Lines
    CGContextSetAllowsAntialiasing(ref, false);
    CGContextSetLineWidth(ref, 1.0);
}




#pragma mark -
#pragma mark Public

-(void)showAnimated:(BOOL)animated
{
    CGSize expectedSize = [self expectedSize];
    [self setFrame:CGRectMake(0.0, 0.0, expectedSize.width, expectedSize.height)];
    
    CGPoint animateToCenter = self.center;
    [self setCenter:CGPointMake(self.center.x, self.center.y-self.bounds.size.height)];
    [_targetView addSubview:self];
    
    if (animated)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self setCenter:animateToCenter];
        } completion:nil];
    }
    else
    {
        [self setCenter:animateToCenter];
    }
    
    if (_hideTimeInterval > 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, _hideTimeInterval* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissAnimated:YES];
        });
    }
}

-(void)dismissAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setCenter:CGPointMake(self.center.x, -self.bounds.size.height)];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
}





#pragma mark -
#pragma mark Setters

-(void)setTintColor:(UIColor *)tintColor
{
    if (tintColor == _tintColor)
        return;
    
    if ([tintColor isEqual:[UIColor clearColor]] || !tintColor)
        [NSException raise:NSInvalidArgumentException format:@"Tint color cannot be [UIColor clearColor] or nil"];
    
    _tintColor = [self transparentTintColorFromColor:tintColor];
}

-(void)setTargetView:(UIView *)targetView
{
    if (_targetView == targetView)
        return;
    
    if (!targetView)
        [NSException raise:NSInvalidArgumentException format:@"DMRNotificationView must have a targetView"];
    
    _targetView = targetView;
}

-(void)setTitle:(NSString *)title
{
    if (_title == title)
        return;
    
    if (title.length == 0)
        [NSException raise:NSInvalidArgumentException format:@"DMRNotificationView cannot have an empty title"];
    
    _title = title;
}

-(void)setType:(DMRNotificationViewType)type
{
    if (_type == type)
        return;
    
    _type = type;
    
    [self setTintColor:[DMRNotificationView tintColorForType:type]];
}

-(void)setIsTransparent:(BOOL)transparent
{
    _transparent = transparent;
    
    UIColor *tintColor = _tintColor;
    _tintColor = nil;
    [self setTintColor:tintColor];
}



#pragma mark -
#pragma mark Getters

-(UIColor *)transparentTintColorFromColor:(UIColor *)color
{
    CGFloat opacity = (_transparent) ? kNotificationViewTintColorTransparency : 1.0;
    CGColorRef transparentColor = CGColorCreateCopyWithAlpha(color.CGColor, opacity);
    
    UIColor *newColor = [UIColor colorWithCGColor:transparentColor];
    CGColorRelease(transparentColor);
    
    return newColor;
}

-(UIColor *)textColor
{
    CGFloat white = 0;
    [_tintColor getWhite:&white alpha:nil];
    return (white < 0.65) ? [UIColor whiteColor] : [UIColor colorWithRed:0.187 green:0.187 blue:0.187 alpha:1.000];
}



-(CGSize)expectedSize
{
    CGFloat height = kNotificationViewVerticalInset;
    
    height += [self expectedTitleSize].height;
    
    if (_subTitle.length > 0)
        height += [self expectedSubTitleSize].height+(kNotificationViewLabelVerticalPadding*2);
    
    height += kNotificationViewVerticalInset+kNotificationViewShadowOffset;
    
    return CGSizeMake(_targetView.bounds.size.width, height);
}

-(CGSize)expectedTitleSize
{
    if (_title.length == 0)
        return CGSizeZero;
    /*
    return [_title sizeWithFont:[self titleFont]
              constrainedToSize:CGSizeMake(_targetView.bounds.size.width-20.0, 999.0)
                  lineBreakMode:NSLineBreakByWordWrapping];
    */
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment     = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName:[self titleFont], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return  [_title boundingRectWithSize:CGSizeMake(_targetView.bounds.size.width-20.0, 999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

-(CGSize)expectedSubTitleSize
{
    if (_subTitle.length == 0)
        return CGSizeZero;
    /*
    return [_subTitle sizeWithFont:[self subTitleFont]
                 constrainedToSize:CGSizeMake(_targetView.bounds.size.width-20.0, 999.0)
                     lineBreakMode:NSLineBreakByWordWrapping];
     */
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment     = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName:[self subTitleFont], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return  [_subTitle boundingRectWithSize:CGSizeMake(_targetView.bounds.size.width-20.0, 999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

-(UIFont *)titleFont
{
    if (_titleFont)
        return _titleFont;
    
    return [UIFont boldSystemFontOfSize:16.0];
}

-(UIFont *)subTitleFont
{
    if (_subTitleFont)
        return _subTitleFont;
    
    return [UIFont systemFontOfSize:13.0];
}

+(UIColor *)tintColorForType:(DMRNotificationViewType)type
{
    if (type == DMRNotificationViewTypeWarning)//
        return [UIColor colorWithRed:1.0 green:0.200 blue:0.25 alpha:1.000];
    
    if (type == DMRNotificationViewTypeSuccess)
        return [UIColor greenColor];
    
    return [UIColor colorWithRed:0.133 green:0.267 blue:0.533 alpha:1.000];
}




#pragma mark -
#pragma mark UIView

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.frame, touchLocation))
    {
        if (_didTapHandler)
        {
            _didTapHandler();
            [self setDidTapHandler:nil];
        }
        
        [self dismissAnimated:YES];
    }
}
@end
