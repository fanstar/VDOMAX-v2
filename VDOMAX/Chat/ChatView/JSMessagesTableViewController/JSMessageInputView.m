//
//  JSMessageInputView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessageInputView.h"
#import "JSBubbleView.h"
#import "NSString+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"
#import "AppDelegate.h"

#define SEND_BUTTON_WIDTH 70.0f

@interface JSMessageInputView ()

- (void)setup;
- (void)setupTextView;

@end



@implementation JSMessageInputView

@synthesize sendButton;
@synthesize tattooButton;
@synthesize optionButton;
@synthesize widthforlefticonarea;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
delegate:(id<UITextViewDelegate>)delegate withMenuLeftAreaWidth:(float) leftmenuareawidth
{
    self = [super initWithFrame:frame];
    if(self) {
        
        self.widthforlefticonarea = leftmenuareawidth;
        
        [self setup];
        self.textView.delegate = delegate;
    }
    return self;
}


- (void)dealloc
{
    self.textView = nil;
    self.sendButton = nil;
    self.tattooButton = nil;
    self.optionButton = nil;
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}
#pragma mark - Setup
- (void)setup
{
    //self.image = [UIImage inputBar];
    self.backgroundColor = BLUE_COLOR;//[UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    [self setupTextView];
}

- (void)setupTextView
{
    
   
    
    float iconarea = self.widthforlefticonarea;
    
    CGFloat width = self.frame.size.width-iconarea - SEND_BUTTON_WIDTH;
    CGFloat height = [JSMessageInputView textViewLineHeight];
    
    self.textView = [[JSDismissiveTextView  alloc] initWithFrame:CGRectMake(6.0f+iconarea, 6.0f, width, height)];
//    NSLog(@"inputFieldBack:%@" , NSStringFromCGRect(self.textView.frame));
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.textView.scrollEnabled = YES;
    self.textView.scrollsToTop = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.font = [JSBubbleView font];
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDefault;
    
    //add
//    self.textView.delegate = self;
    
    self.textView.contentSize = CGSizeMake(width, height);
    [self addSubview:self.textView];
//    NSLog(@"inputFieldBack:%@" , NSStringFromCGSize(self.textView.contentSize));
	
    UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x - 1.0f,
                                                                                0.0f,
                                                                                self.textView.frame.size.width + 2.0f,
                                                                                self.frame.size.height)];
    //inputFieldBack.image = [UIImage inputField];
    //inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    inputFieldBack.backgroundColor = [UIColor clearColor];
    
//    NSLog(@"inputFieldBackFrame:%@" , NSStringFromCGRect(self.textView.frame));
//    NSLog(@"inputFieldBack:%@" , NSStringFromCGSize(self.textView.contentSize));
    [self addSubview:inputFieldBack];
    
    
}

#pragma mark - Setters
- (void)setSendButton:(UIButton *)btn
{
    if(sendButton)
        [sendButton removeFromSuperview];
    
    sendButton = btn;
    [self addSubview:self.sendButton];
}

//add tatto button
- (void)setTattooButton:(UIButton *)btn
{
    if(tattooButton)
        [tattooButton removeFromSuperview];
    
    tattooButton = btn;
    [self addSubview:self.tattooButton];
}

- (void)setOptionButton:(UIButton *)btn
{
    if(optionButton)
        [optionButton removeFromSuperview];
    
    optionButton = btn;
    [self addSubview:self.optionButton];
}

#pragma mark - Message input view
- (void)adjustTextViewHeightDefault
{
    CGRect prevFrame = self.textView.frame;
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     [self TextHightDefault]);
//    self.textView.contentInset = UIEdgeInsetsMake( 0.0f,
//                                                  0.0f,
//                                                  0.0f,
//                                                  0.0f);
    
    
//    CGPoint bottomOffset = CGPointMake(0.0f, 0.0f);
//    [self.textView setContentOffset:bottomOffset animated:YES];
    
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.textView.frame;
    
    //    NSLog(@"numberOfLinesForMessage:%d",[JSBubbleView numberOfLinesForMessage:self.textView.text]);
    //    NSLog(@"numberOfLines:%d",[self.textView.text numberOfLines]);
    
    int numLines = MAX([JSBubbleView numberOfLinesForMessage:self.textView.text],
                       [self.textView.text numberOfLines]);
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    
    self.textView.scrollEnabled = (numLines >= 4);
    //if(numLines <= 4)self.textView.contentSize = self.textView.frame.size;
    
    if(numLines <= 4){
        CGPoint bottomOffset = CGPointMake(0.0f, 0.0f);
        [self.textView setContentOffset:bottomOffset animated:YES];
    }
    
    
    if(numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
    }
    
    //    NSLog(@"Text Conten Size: %@",NSStringFromCGSize(self.textView.contentSize));
    //    NSLog(@"Text Frame: %@",NSStringFromCGRect(self.textView.frame));
}

+ (CGFloat)textViewLineHeight
{
    return 30.0f; // for fontSize 15.0f
}

-(float )TextHightDefault{
    return 30.0f;
}

+ (CGFloat)maxLines
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 4.0f : 8.0f;
}

+ (CGFloat)maxHeight
{
    return ([JSMessageInputView maxLines] + 1.0f) * [JSMessageInputView textViewLineHeight];
}

@end