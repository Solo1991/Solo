//
//  inputView.m
//  inche
//
//  Created by MIX on 15/1/19.
//  Copyright (c) 2015年 com.novonity. All rights reserved.
//



#import "inputView.h"


#define mediaButtonWidth  34.0


@interface inputView()<UITextViewDelegate, UIGestureRecognizerDelegate>
{

    CGRect textViewOriginFrame;
    
    UITapGestureRecognizer *tapGesture;
    UIPanGestureRecognizer *panGesture;
    CGRect keyboardRect;

}

@end

@implementation inputView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    return self;
}


-(void)dealloc
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeGestureRecognizer:tapGesture];
    [self removeGestureRecognizer:panGesture];
    [self.superview removeGestureRecognizer:tapGesture];
    [self.superview removeGestureRecognizer:panGesture];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupInitialData];
        [self setup];
        
        
    }
    return self;
}

- (id)initWith:(BOOL)hasMedia With:(BOOL)hasSend
{
    self = [super init];
    if (self) {

        
        [self initFrame];
        [self setupInitialData];
        [self setup];
    }
    return self;
}

-(void)textViewResign{
    [self.textView resignFirstResponder];
}

-(void)initFrame
{
    textViewOriginFrame = CGRectMake(10, 8, MainWidth-70, 34);
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainWidth-55, 8, 50, 34)];
    [sendBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
     [sendBtn.layer setBorderWidth:1];
    [sendBtn.layer setCornerRadius:3];
    [sendBtn.layer setMasksToBounds:YES];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];

}
-(void)sendMessage{
    self.ReturnSendMessageBtn(self.textView.text);
}
- (void)setupInitialData
{
    self.frame = CGRectMake(0, MainHeight-121+10, MainWidth, 50);
    self.backgroundColor=[UIColor colorWithRed:232/255.0 green:236/255.0 blue:235/255.0 alpha:1];
}



- (void)setup
{
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    panGesture.delegate =self;
    tapGesture.delegate =self;
    
    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:panGesture];
    [self.superview addGestureRecognizer:tapGesture];
    [self.superview addGestureRecognizer:panGesture];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (!self.textView) {
        self.textView = [[UITextView alloc]initWithFrame:textViewOriginFrame];
        [self.textView setFont:[UIFont systemFontOfSize:15]];
        [self.textView setTextColor:[UIColor lightGrayColor]];
        self.textView.backgroundColor = [UIColor whiteColor];
        [self.textView.layer setCornerRadius:3];
        self.textView.returnKeyType=UIReturnKeySend;
        self.textView.delegate=self;
        [self addSubview:self.textView];
        
        
        
   }
    

    

}





- (void)keyboardWillShow:(NSNotification*)notification{
    
    keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame=CGRectMake(0, MainHeight-121- keyboardRect.size.height+10,MainWidth, 120 );
    
    [self.textView.layer setCornerRadius:3];
    self.textView.frame = textViewOriginFrame;
    
    

    [self setNeedsDisplay];
}


- (void)keyboardWillHide:(NSNotification*)notification{
    

    
    self.frame = CGRectMake(0, MainHeight-121+10, MainWidth, 50);
    
    [self.textView.layer setCornerRadius:3];
    self.textView.frame = textViewOriginFrame;
    [self setNeedsDisplay];
}





//TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        [self.delegate  returnKeyAction];
        
    }
    return YES;
}


//手势
#pragma mark - Gestures
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    
}
//setNeedsDisplay
//- (void)drawRect:(CGRect)rect {
// Drawing code
//}

//setNeedsLayout   init 不会触发   addsubview 会
//- (void)layoutSubViews
//{

//}


/*
 一、
 layoutSubviews在以下情况下会被调用：
 1、init初始化不会触发layoutSubviews。
 2、addSubview会触发layoutSubviews。
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化。
 4、滚动一个UIScrollView会触发layoutSubviews。
 5、旋转Screen会触发父UIView上的layoutSubviews事件。
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件。
 7、直接调用setLayoutSubviews。
 8、直接调用setNeedsLayout。
 在苹果的官方文档中强调:You should override this method only if the autoresizing behaviors of the subviews do not offer the behavior you want.
 layoutSubviews, 当我们在某个类的内部调整子视图位置时，需要调用。
 反过来的意思就是说：如果你想要在外部设置subviews的位置，就不要重写。
 
 */

@end
