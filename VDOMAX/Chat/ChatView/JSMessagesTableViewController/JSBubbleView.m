//
//  JSBubbleView.m
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

#import "JSBubbleView.h"
#import "JSMessageInputView.h"
#import "NSString+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"

CGFloat const kJSAvatarSize = 50.0f;

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f

#define kImageHeigth 100
#define kContactHeigth 64
#define kContactWide 200

@interface JSBubbleView()

- (void)setup;

+ (UIImage *)bubbleImageTypeIncomingWithStyle:(JSBubbleMessageStyle)aStyle;
+ (UIImage *)bubbleImageTypeOutgoingWithStyle:(JSBubbleMessageStyle)aStyle;

@end



@implementation JSBubbleView

@synthesize type;
@synthesize style;
@synthesize text;
@synthesize selectedToShowCopyMenu;
@synthesize typedata;
@synthesize imageSend;

#pragma mark - Setup
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)rect
         bubbleType:(JSBubbleMessageType)bubleType
        bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
        bubbleTypeData:(JSBubbleTypeData)bubleTypeData
{
    self = [super initWithFrame:rect];
    if(self) {
        [self setup];
        self.type = bubleType;
        self.style = bubbleStyle;
        self.typedata = bubleTypeData;
    }
    return self;
}

- (void)dealloc
{
    self.text = nil;
    self.imgSend = nil;
}

#pragma mark - Setters
- (void)setImgSend:(UIImage *)image{
    imageSend = image;
    [self setNeedsDisplay];
}

- (void)setType:(JSBubbleMessageType)newType
{
    type = newType;
    [self setNeedsDisplay];
}

- (void)setStyle:(JSBubbleMessageStyle)newStyle
{
    style = newStyle;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)newText
{
    text = newText;
    [self setNeedsDisplay];
}

- (void)setSelectedToShowCopyMenu:(BOOL)isSelected
{
    selectedToShowCopyMenu = isSelected;
    [self setNeedsDisplay];
}

#pragma mark - Drawing
- (CGRect)bubbleFrame
{
    CGSize bubbleSize;
    if (self.typedata == JSBubbleTypeImage) {
        bubbleSize = CGSizeMake(kImageHeigth, kImageHeigth);
    }else if (self.typedata == JSBubbleTypeContact) {
        bubbleSize = CGSizeMake(kContactWide, kContactHeigth);
    }else if (self.typedata == JSBubbleTypePhoto) {
        
        if (imageSend == nil) {
            bubbleSize = CGSizeMake(kImageHeigth, kImageHeigth);
        }else{
            float ratio = 0.0f;
            
            if (imageSend.size.width >= imageSend.size.height) {
                ratio = kImageHeigth/imageSend.size.width;
            }else{
                ratio = kImageHeigth/imageSend.size.height;
            }
            
            bubbleSize = CGSizeMake(imageSend.size.width*ratio, imageSend.size.height*ratio);
        }
        
    }else if (self.typedata == JSBubbleTypeVDO) {
        bubbleSize = CGSizeMake(kImageHeigth, kImageHeigth);
    }else if (self.typedata == JSBubbleTypeSound) {
        bubbleSize = CGSizeMake(kImageHeigth, kImageHeigth);
    }else if (self.typedata == JSBubbleTypeLink) {
        bubbleSize = [JSBubbleView bubbleSizeForText:self.text];
    }else if (self.typedata == JSBubbleTypeLocation) {
        bubbleSize = [JSBubbleView bubbleSizeForText:self.text];
    }
    
    else{
        bubbleSize = [JSBubbleView bubbleSizeForText:self.text];
    }
    //CGSize bubbleSize = [JSBubbleView bubbleSizeForText:self.text];
    
    return CGRectMake((self.type == JSBubbleMessageTypeOutgoing ? self.frame.size.width - bubbleSize.width : 0.0f),
                      kMarginTop,
                      bubbleSize.width,
                      bubbleSize.height);
}

- (UIImage *)bubbleImage
{
    return [JSBubbleView bubbleImageForType:self.type style:self.style];
}

- (UIImage *)bubbleImageHighlighted
{
    switch (self.style) {
        case JSBubbleMessageStyleDefault:
        case JSBubbleMessageStyleDefaultGreen:
            return (self.type == JSBubbleMessageTypeIncoming) ? [UIImage bubbleDefaultIncomingSelected] : [UIImage bubbleDefaultOutgoingSelected];
            
        case JSBubbleMessageStyleSquare:
            return (self.type == JSBubbleMessageTypeIncoming) ? [UIImage bubbleSquareIncomingSelected] : [UIImage bubbleSquareOutgoingSelected];
            
        default:
            return nil;
    }
}

- (void)drawRect:(CGRect)frame
{
//    NSLog(@"draw frame:%@", NSStringFromCGRect(frame));
    [super drawRect:frame];
    
	if (self.typedata == JSBubbleTyeMessage || self.typedata == JSBubbleTypeLink || self.typedata == JSBubbleTypeLocation) {
        UIImage *image = (self.selectedToShowCopyMenu) ? [self bubbleImageHighlighted] : [self bubbleImage];
        
        CGRect bubbleFrame = [self bubbleFrame];
        [image drawInRect:bubbleFrame];
        
        CGSize textSize = [JSBubbleView textSizeForText:self.text];
        
        CGFloat textX = image.leftCapWidth - 3.0f + (self.type == JSBubbleMessageTypeOutgoing ? bubbleFrame.origin.x : 0.0f);
        
        CGRect textFrame = CGRectMake(textX,
                                      kPaddingTop + kMarginTop,
                                      textSize.width,
                                      textSize.height);
        
        UIFont * fStype;
        
        if (self.typedata == JSBubbleTypeLink || self.typedata == JSBubbleTypeSound) {
            fStype = [UIFont italicSystemFontOfSize:16.0f];
        }else{
            fStype = [JSBubbleView font];
        }
        
        [self.text drawInRect:textFrame
                     withFont:fStype
                lineBreakMode:NSLineBreakByWordWrapping
                    alignment:NSTextAlignmentLeft];
        
//    }else if(self.typedata == JSBubbleTypeImage){
        }else {
        CGRect bubbleFrame = [self bubbleFrame];
        [imageSend drawInRect:bubbleFrame];
    }
}

#pragma mark - Bubble view
+ (UIImage *)bubbleImageForType:(JSBubbleMessageType)aType style:(JSBubbleMessageStyle)aStyle
{
    switch (aType) {
        case JSBubbleMessageTypeIncoming:
            return [self bubbleImageTypeIncomingWithStyle:aStyle];
            
        case JSBubbleMessageTypeOutgoing:
            return [self bubbleImageTypeOutgoingWithStyle:aStyle];
            
        default:
            return nil;
    }
}

+ (UIImage *)bubbleImageTypeIncomingWithStyle:(JSBubbleMessageStyle)aStyle
{
    switch (aStyle) {
        case JSBubbleMessageStyleDefault:
            return [UIImage bubbleDefaultIncoming];
            
        case JSBubbleMessageStyleSquare:
            return [UIImage bubbleSquareIncoming];
            
        case JSBubbleMessageStyleDefaultGreen:
            return [UIImage bubbleDefaultIncomingGreen];
            
        default:
            return nil;
    }
}

+ (UIImage *)bubbleImageTypeOutgoingWithStyle:(JSBubbleMessageStyle)aStyle
{
    switch (aStyle) {
        case JSBubbleMessageStyleDefault:
            return [UIImage bubbleDefaultOutgoing];
            
        case JSBubbleMessageStyleSquare:
            return [UIImage bubbleSquareOutgoing];
            
        case JSBubbleMessageStyleDefaultGreen:
            return [UIImage bubbleDefaultOutgoingGreen];
            
        default:
            return nil;
    }
}

+ (UIFont *)font
{

    return [UIFont systemFontOfSize:16.0f];

}

+ (UIFont *)fontLink
{
    
    return [UIFont italicSystemFontOfSize:16.0f];
    
}

+ (CGSize)textSizeForText:(NSString *)txt
{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width * 0.75f;
    CGFloat height = MAX([JSBubbleView numberOfLinesForMessage:txt],
                         [txt numberOfLines]) * [JSMessageInputView textViewLineHeight];
    
    return [txt sizeWithFont:[JSBubbleView font]
           constrainedToSize:CGSizeMake(width - kJSAvatarSize, height + kJSAvatarSize)
               lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)bubbleSizeForText:(NSString *)txt
{
	CGSize textSize = [JSBubbleView textSizeForText:txt];
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGFloat)cellHeightForText:(NSString *)txt
{
    return [JSBubbleView bubbleSizeForText:txt].height + kMarginTop + kMarginBottom;
}

//add
+ (CGFloat)cellHeightForImage{
    return kImageHeigth;
}

+ (CGFloat)cellHeightForContact{
    return kContactHeigth;
}
//end

+ (int)maxCharactersPerLine
{
   // return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 18 : 80;
}

+ (int)numberOfLinesForMessage:(NSString *)txt
{
    //NSLog(@"txt: %@",txt);
    return (int)(txt.length / [JSBubbleView maxCharactersPerLine]) + 1;
    
//    return (txt.length / [JSBubbleView maxCharactersPerLine]) + 1 +[[txt componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.typedata == JSBubbleTypeContact
        ||self.typedata == JSBubbleTypePhoto
        ||self.typedata == JSBubbleTypeVDO
        ||self.typedata == JSBubbleTypeSound
        ||self.typedata == JSBubbleTypeLocation
        ||self.typedata == JSBubbleTypeLink
        )
    {
        UITouch * touch = [touches anyObject];
        
        CGPoint touchpoint = [touch locationInView:self];
        
        if (CGRectContainsPoint([self bubbleFrame], touchpoint)) {
            if (self.delegate) {
                [self.delegate DidTouchBubleView];
            }
        }
        
    }
    
    
}


@end