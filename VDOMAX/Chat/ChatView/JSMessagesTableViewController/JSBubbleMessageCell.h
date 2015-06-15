//
//  JSBubbleMessageCell.h
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

#import <UIKit/UIKit.h>
#import "JSBubbleView.h"

//add
#import "UIImageView+WebCache.h"
#import "ProfileViewController.h"
#import "Global.h"
#import "AudioPlayViewController.h"

typedef enum {
    JSAvatarStyleCircle = 0,
    JSAvatarStyleSquare,
    JSAvatarStyleNone
} JSAvatarStyle;

@class JSBubbleMessageCell;

@protocol BubbleCellDelegate <NSObject>

-(void)DidSelectBubbleCell:(JSBubbleMessageCell * ) bubblecell Action:(int) action;

@end

@interface JSBubbleMessageCell : UITableViewCell<JSBubbleViewDelegate>
@property(assign, nonatomic) id<BubbleCellDelegate>delegate;
@property(retain, nonatomic) NSDictionary * datadictcell;
@property(assign, nonatomic) JSBubbleTypeData bTypeData;
@property(retain, nonatomic) NSIndexPath * currentIndexPath;
@property(assign, nonatomic) BOOL reloadCellFlag;
@property(retain, nonatomic) UIImageView * imvPresent;
@property(retain, nonatomic) UILabel * lbCaption;
@property(retain, nonatomic) AudioPlayViewController * audioview;


#pragma mark - Initialization
- (id)initWithBubbleType:(JSBubbleMessageType)type
             bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
          bubbleTypeData:(JSBubbleTypeData)bubbleTypeData
             avatarStyle:(JSAvatarStyle)avatarStyle
            hasTimestamp:(BOOL)hasTimestamp
         reuseIdentifier:(NSString *)reuseIdentifier;

#pragma mark - Message cell
- (void)setImageSend:(UIImage *)image;
- (void)setMessage:(NSString *)msg;
//- (void)setTimestamp:(NSDate *)date;
- (void)setTimestampString:(NSString *)datestring;
- (void)setAvatarImage:(UIImage *)image;
- (void)setAvatarImageWithURL:(NSString *)imageurl;
- (void)setImageSendFromImageURL:(NSString *) urlstring;
- (void)setImageSendByContact:(NSDictionary *) dict;

+ (CGFloat)neededHeightForText:(NSString *)bubbleViewText
                     timestamp:(BOOL)hasTimestamp
                        avatar:(BOOL)hasAvatar;

+ (CGFloat)neededHeightForImageAttimestamp:(BOOL)hasTimestamp avatar:(BOOL)hasAvatar;
+ (CGFloat)neededHeightForContactAttimestamp:(BOOL)hasTimestamp avatar:(BOOL)hasAvatar;

@end