//
//  UIButton+JSMessagesView.m
//  MessagesDemo
//
//  Created by Jesse Squires on 3/24/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//

#import "UIButton+JSMessagesView.h"

@implementation UIButton (JSMessagesView)

+ (UIButton *)defaultSendButton
{
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    //UIImage *sendBack = [[UIImage imageNamed:@"send"] resizableImageWithCapInsets:insets];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    UIImage *sendBack = [UIImage imageNamed:@"send_chat_button1.png"];//[[UIImage imageNamed:@"send_chat_button"] resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [UIImage imageNamed:@"send_chat_button1.png"];//[[UIImage imageNamed:@"send-highlighted"] resizableImageWithCapInsets:insets];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateNormal];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
    [sendButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    NSString *title = NSLocalizedString(@"", nil);
    [sendButton setTitle:title forState:UIControlStateNormal];
    [sendButton setTitle:title forState:UIControlStateHighlighted];
    [sendButton setTitle:title forState:UIControlStateDisabled];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
//    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
//    [sendButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
//    [sendButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
//    sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
//    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    [sendButton setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:184.0f/255.0f blue:234.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    return sendButton;
}


//add
+ (UIButton *)tattooButton
{
    UIButton *tattooButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tattooButton.contentMode = UIViewContentModeScaleAspectFit;
    //tattooButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
   // UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    UIImage *sendBack = [UIImage imageNamed:@"sticker_button1.png"];//[[UIImage imageNamed:@"sticker_button.png"] resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [UIImage imageNamed:@"sticker_button1.png"];//[[UIImage imageNamed:@"send-highlighted"] resizableImageWithCapInsets:insets];
    [tattooButton setBackgroundImage:sendBack forState:UIControlStateNormal];
    [tattooButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
    [tattooButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    NSString *title = NSLocalizedString(@"", nil);
    [tattooButton setTitle:title forState:UIControlStateNormal];
    [tattooButton setTitle:title forState:UIControlStateHighlighted];
    [tattooButton setTitle:title forState:UIControlStateDisabled];
    tattooButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
    [tattooButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
    [tattooButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
    tattooButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [tattooButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tattooButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [tattooButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    return tattooButton;
}


//add option button
+ (UIButton *)optionButton
{
    UIButton *opButton = [UIButton buttonWithType:UIButtonTypeCustom];
    opButton.contentMode = UIViewContentModeScaleAspectFit;
    //opButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    //UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    UIImage *sendBack = [UIImage imageNamed:@"plus_chat_button1.png"];//;[[UIImage imageNamed:@"plus_chat_button.png"] resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [UIImage imageNamed:@"plus_chat_button1.png"];//[[UIImage imageNamed:@"send-highlighted"] resizableImageWithCapInsets:insets];
    [opButton setBackgroundImage:sendBack forState:UIControlStateNormal];
    [opButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
    [opButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    NSString *title = NSLocalizedString(@"", nil);
    [opButton setTitle:title forState:UIControlStateNormal];
    [opButton setTitle:title forState:UIControlStateHighlighted];
    [opButton setTitle:title forState:UIControlStateDisabled];
    opButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
    [opButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
    [opButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
    opButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [opButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [opButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [opButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    return opButton;
}

@end