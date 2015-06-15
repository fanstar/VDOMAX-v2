//
//  JSMessagesViewController.h
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
#import "JSBubbleMessageCell.h"
#import "JSMessageInputView.h"
#import "JSMessageSoundEffect.h"
#import "UIButton+JSMessagesView.h"
#import "Global.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "PreViewPhotoViewController.h"

//media
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "YouTubeView.h"
#import "AudioPlayViewController.h"

#import "AppDelegate.h"

typedef enum {
    JSMessagesViewTimestampPolicyAll = 0,
    JSMessagesViewTimestampPolicyAlternating,
    JSMessagesViewTimestampPolicyEveryThree,
    JSMessagesViewTimestampPolicyEveryFive,
    JSMessagesViewTimestampPolicyCustom
} JSMessagesViewTimestampPolicy;


typedef enum {
    JSMessagesViewAvatarPolicyIncomingOnly = 0,
    JSMessagesViewAvatarPolicyBoth,
    JSMessagesViewAvatarPolicyNone
} JSMessagesViewAvatarPolicy;


@protocol JSMessagesViewDelegate <NSObject>
@required
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text;
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath;
- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (JSBubbleTypeData)messageTypeDataForRowAtIndexPath:(NSIndexPath *)indexPath;
- (JSMessagesViewTimestampPolicy)timestampPolicy;
- (JSMessagesViewAvatarPolicy)avatarPolicy;
- (JSAvatarStyle)avatarStyle;

//add
- (void)tattooPressed:(UIButton *)sender;
- (void)optionPressed:(UIButton *)sender;
- (void)didSelectLoadMore;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@protocol JSMessagesViewDataSource <NSObject>
@required
//- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary *)DataDictForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (UIImage *)avatarImageForIncomingMessage;
//- (UIImage *)avatarImageForOutgoingMessage;
- (NSString *)avatarImageURLForIncomingMessageAtIndexPath:(NSIndexPath *) indexPath;
- (NSString *)avatarImageURLForOutgoingMessageAtIndexPath:(NSIndexPath *) indexPath;
@end



@interface JSMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,BubbleCellDelegate>
{
    NSMutableArray * tempCheckDate;
    
    BOOL enableLoadmore;
    
    int keepchangelinehiegh;
    
}
@property (weak, nonatomic) id<JSMessagesViewDelegate> delegate;
@property (weak, nonatomic) id<JSMessagesViewDataSource> dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) JSMessageInputView *inputToolBarView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (assign, nonatomic) JSBubbleTypeData bubbleTypeDataCheck;

//add
@property (assign, nonatomic) int numofrow;
@property (assign, nonatomic) int countwrappingtext;
@property (assign, nonatomic) int countnewline;

#pragma mark - Initialization
- (UIButton *)sendButton;

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender;

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)finishSend;
- (void)setBackgroundColor:(UIColor *)color;
- (void)scrollToBottomAnimated:(BOOL)animated;

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification;
- (void)handleWillHideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;

@end