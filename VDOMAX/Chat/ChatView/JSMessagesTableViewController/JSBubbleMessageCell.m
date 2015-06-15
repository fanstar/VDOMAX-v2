//
//  JSBubbleMessageCell.m
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

#import "JSBubbleMessageCell.h"
#import "UIColor+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"

#define TIMESTAMP_LABEL_HEIGHT 14.5f

@interface JSBubbleMessageCell()

@property (strong, nonatomic) JSBubbleView *bubbleView;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (assign, nonatomic) JSAvatarStyle avatarImageStyle;

//- (void)setup;
- (void)setupWithType:(JSBubbleTypeData)bubbleTypeData;
- (void)configureTimestampLabel;

- (void)configureWithType:(JSBubbleMessageType)type
              bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
           bubbleTypeData:(JSBubbleTypeData)bubbleTypeData
              avatarStyle:(JSAvatarStyle)avatarStyle
                timestamp:(BOOL)hasTimestamp;

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress;
- (void)handleMenuWillHideNotification:(NSNotification *)notification;
- (void)handleMenuWillShowNotification:(NSNotification *)notification;

@end



@implementation JSBubbleMessageCell
@synthesize delegate;
@synthesize datadictcell;
@synthesize bTypeData;
@synthesize currentIndexPath;
@synthesize reloadCellFlag;
@synthesize imvPresent;
@synthesize lbCaption;
@synthesize audioview;

#pragma mark - Setup
//- (void)setup
- (void)setupWithType:(JSBubbleTypeData)bubbleTypeData
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
//    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                             action:@selector(handleLongPress:)];
//    [recognizer setMinimumPressDuration:0.4];
//    [self addGestureRecognizer:recognizer];
    
    
    
    //add
    
    if (bubbleTypeData == JSBubbleTyeMessage
        ) {
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:0.4];
        [self addGestureRecognizer:recognizer];
  
    }
    
    self.bTypeData = bubbleTypeData;
    
//    if (bubbleTypeData == JSBubbleTypeContact
//        ||bubbleTypeData == JSBubbleTypePhoto
//        ||bubbleTypeData == JSBubbleTypeVDO
//        ||bubbleTypeData == JSBubbleTypeSound
//        ||bubbleTypeData == JSBubbleTypeLocation
//        ||bubbleTypeData == JSBubbleTypeLink
//        ) {
//        UITapGestureRecognizer * recogTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                    action:@selector(handleTapPress:)];
//        [self.bubbleView addGestureRecognizer:recogTap];
//    }
    //end add
    
}

- (void)configureTimestampLabel
{
    self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                    4.0f,
                                                                    self.bounds.size.width,
                                                                    TIMESTAMP_LABEL_HEIGHT)];
    self.timestampLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
    self.timestampLabel.textColor = [UIColor messagesTimestampColor];
    self.timestampLabel.shadowColor = [UIColor whiteColor];
    self.timestampLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.timestampLabel.font = [UIFont boldSystemFontOfSize:11.5f];
    
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView bringSubviewToFront:self.timestampLabel];
}

- (void)configureWithType:(JSBubbleMessageType)type
              bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
              bubbleTypeData:(JSBubbleTypeData)bubbleTypeData
              avatarStyle:(JSAvatarStyle)avatarStyle
                timestamp:(BOOL)hasTimestamp
{
    CGFloat bubbleY = 0.0f;
    CGFloat bubbleX = 0.0f;
    
    if(hasTimestamp) {
        [self configureTimestampLabel];
        bubbleY = 14.0f;
    }
    
    CGFloat offsetX = 0.0f;
    
    if(avatarStyle != JSAvatarStyleNone) {
        offsetX = 4.0f;
        bubbleX = kJSAvatarSize;
        CGFloat avatarX = 0.5f;
        
        if(type == JSBubbleMessageTypeOutgoing) {
            avatarX = (self.contentView.frame.size.width - kJSAvatarSize);
            offsetX = kJSAvatarSize - 4.0f;
        }
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(avatarX,
                                                                             self.contentView.frame.size.height - kJSAvatarSize,
                                                                             kJSAvatarSize,
                                                                             kJSAvatarSize)];
        
        self.avatarImageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                                 | UIViewAutoresizingFlexibleLeftMargin
                                                 | UIViewAutoresizingFlexibleRightMargin);
        [self.contentView addSubview:self.avatarImageView];
    }
    
    CGRect frame = CGRectMake(bubbleX - offsetX,
                              bubbleY,
                              self.contentView.frame.size.width - bubbleX,
                              self.contentView.frame.size.height - self.timestampLabel.frame.size.height);
    
    self.bubbleView = [[JSBubbleView alloc] initWithFrame:frame
                                               bubbleType:type
                                              bubbleStyle:bubbleStyle
                                           bubbleTypeData:bubbleTypeData];
    self.bubbleView.backgroundColor = [UIColor clearColor];
    
    //add
    self.bubbleView.delegate = self;
    
   
    
    
    if (bubbleTypeData == JSBubbleTypeContact
        ||bubbleTypeData == JSBubbleTypePhoto
        ||bubbleTypeData == JSBubbleTypeVDO
        //||bubbleTypeData == JSBubbleTypeSound
        ||bubbleTypeData == JSBubbleTypeLocation
        ||bubbleTypeData == JSBubbleTypeLink
        ) {
        
        [self.bubbleView setSelectedToShowCopyMenu:NO];
        
        //        UITapGestureRecognizer * recogTap = [[UITapGestureRecognizer alloc] initWithTarget:self
        //                                                                                    action:@selector(handleTapPress:)];
        //
        ////        CGRect frametouch = CGRectMake(bubbleX - offsetX,
        ////                                  bubbleY,
        ////                                  self.contentView.frame.size.width - bubbleX,
        ////                                  self.contentView.frame.size.height - self.timestampLabel.frame.size.height);
        //
        //
        //        NSLog(@"Frame Image: %@",NSStringFromCGRect([self.bubbleView bubbleFrame]));
        //        UIImageView * tmpimv = [[UIImageView alloc] initWithFrame:frame];
        //        [tmpimv setImage:[UIImage imageNamed:@"tattoo_default.png"]];
        //
        //        [tmpimv addGestureRecognizer:recogTap];
        //        [self addSubview:tmpimv];
        
        self.imvPresent = [[UIImageView alloc] initWithFrame:[self.bubbleView bubbleFrame]];
        self.imvPresent.contentMode = UIViewContentModeScaleAspectFit;
        self.imvPresent.backgroundColor = [UIColor clearColor];
        
        self.lbCaption = [[UILabel alloc] initWithFrame:CGRectMake(self.imvPresent.frame.origin.x
                                                                  , (self.imvPresent.frame.origin.y+self.imvPresent.frame.size.height - 20.0f)
                                                                  , self.imvPresent.frame.size.width
                                                                   , 20.0f)];
        self.lbCaption.backgroundColor = [UIColor clearColor];
        
        //lbCaption.text = @" test ";
        //[lbCaption setFont:[UIFont systemFontOfSize:6.0f]];
        [lbCaption setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        //[lbCaption setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

        [self.bubbleView addSubview:self.imvPresent];
        [self.bubbleView addSubview:lbCaption];
        
    }else if(bubbleTypeData == JSBubbleTypeSound){
        
        
        self.audioview =  [[AudioPlayViewController alloc] initWithNibName:@"AudioPlayViewController_iPhone" bundle:nil];
        self.audioview.view.frame = [self.bubbleView bubbleFrame];
        self.audioview.view.backgroundColor = [UIColor clearColor];
        
        [self.bubbleView addSubview:self.audioview.view];
        
        
        self.lbCaption = [[UILabel alloc] initWithFrame:CGRectMake(self.audioview.view.frame.origin.x
                                                                   , (self.audioview.view.frame.origin.y+self.audioview.view.frame.size.height - 20.0f)
                                                                   , self.audioview.view.frame.size.width
                                                                   , 20.0f)];
        self.lbCaption.backgroundColor =[UIColor clearColor];
        
        [self.bubbleView addSubview:lbCaption];
        
    }
    //end add
    
    
    [self.contentView addSubview:self.bubbleView];
    [self.contentView sendSubviewToBack:self.bubbleView];
    
    //add
    
   
    
    
    
    
    

    
    //end add
}

#pragma mark - Initialization
- (id)initWithBubbleType:(JSBubbleMessageType)type
             bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
          bubbleTypeData:(JSBubbleTypeData)bubbleTypeData
             avatarStyle:(JSAvatarStyle)avatarStyle
            hasTimestamp:(BOOL)hasTimestamp
         reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        //[self setup];
        [self setupWithType:bubbleTypeData];
        self.avatarImageStyle = avatarStyle;
        [self configureWithType:type
                    bubbleStyle:bubbleStyle
                 bubbleTypeData:bubbleTypeData
                    avatarStyle:avatarStyle
                      timestamp:hasTimestamp];
    }
    return self;
}

- (void)dealloc
{
    self.bubbleView = nil;
    self.timestampLabel = nil;
    self.avatarImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters
- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    [self.contentView setBackgroundColor:color];
    [self.bubbleView setBackgroundColor:color];
}

#pragma mark - Message Cell
- (void)setImageSend:(UIImage *)image
{
    [self.bubbleView setImageSend:image];
    self.bubbleView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setImageSendFromImageURL:(NSString *) urlstring
{
    
    UIImageView * imgvTemp = [[UIImageView alloc] init];
    
    if(urlstring.length>0)[imgvTemp setImageWithURL:[NSURL URLWithString:urlstring] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        
        [self.bubbleView setImageSend:image];
        self.bubbleView.contentMode = UIViewContentModeScaleAspectFit;
        
    }];
    
//    self.bubbleView.imageSend = image;
//    self.bubbleView.contentMode = UIViewContentModeScaleAspectFit;
}


//add

- (void)setImageSendByContact:(NSDictionary *) dict{
    
//-(UIImage *)CustomeImageContactFromDict:(NSDictionary *) dict{
    
    NSString * urlString = [dict objectForKey:@"SENDERIMAGE"];
    
    NSArray * words = [urlString componentsSeparatedByString:@"graph.facebook.com"];
    
    //        NSLog(@"words = %@",words);
    
    if ([words count] < 2) {
        urlString = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,urlString];
    }
    
    
    //NSString * urlString = [dict objectForKey:@"SENDERIMAGE"];
    
//    NSLog(@"urlString : %@",urlString);
    
//    NSURL * imageURL = [NSURL URLWithString:urlString];
//    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
//    UIImage * image = [UIImage imageWithData:imageData];
//    pro.imageProfile = image;
    
    
    //return image;
    //return [self imageWithView:pro.view];
    
    UIImageView * imgvTemp = [[UIImageView alloc] init];
    
    if(urlString.length>0)[imgvTemp setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        ProfileViewController * pro = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController_iPhone" bundle:nil];
        
        NSString * sendername = [dict objectForKey:@"SENDERUSERNAME"];
        NSString * urlsender = [NSString stringWithFormat:@"https://%@.vdomax.com/channel",sendername];
        
        pro.strNameProfile = sendername;
        pro.strURLProfile = urlsender;
        pro.imageProfile = image;
        
        [self.bubbleView setImageSend:[self imageWithView:pro.view]];
        self.bubbleView.contentMode = UIViewContentModeScaleAspectFit;
        
    }];
    
}


- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


//end add
- (void)setMessage:(NSString *)msg
{
    self.bubbleView.text = msg;
}

/*
- (void)setTimestamp:(NSDate *)date
{
    self.timestampLabel.text = [NSDateFormatter localizedStringFromDate:date
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterShortStyle];
}
 */
- (void)setTimestampString:(NSString *)datestring
{
    self.timestampLabel.text = datestring;
}

- (void)setAvatarImage:(UIImage *)image
{
    UIImage *styledImg = nil;
    switch (self.avatarImageStyle) {
        case JSAvatarStyleCircle:
            styledImg = [image circleImageWithSize:kJSAvatarSize];
            break;
            
        case JSAvatarStyleSquare:
            styledImg = [image squareImageWithSize:kJSAvatarSize];
            break;
            
        case JSAvatarStyleNone:
        default:
            break;
    }
    
    self.avatarImageView.image = styledImg;
}

- (void)setAvatarImageWithURL:(NSString *)imageurl
{
    UIImageView * imgvTemp = [[UIImageView alloc] init];
    
    if(imageurl.length>0)[imgvTemp setImageWithURL:[NSURL URLWithString:imageurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        UIImage *styledImg = nil;
        switch (self.avatarImageStyle) {
            case JSAvatarStyleCircle:
                styledImg = [image circleImageWithSize:kJSAvatarSize];
                break;
                
            case JSAvatarStyleSquare:
                styledImg = [image squareImageWithSize:kJSAvatarSize];
                break;
                
            case JSAvatarStyleNone:
            default:
                break;
        }
        
        self.avatarImageView.image = styledImg;
        
    }];

}


+ (CGFloat)neededHeightForText:(NSString *)bubbleViewText timestamp:(BOOL)hasTimestamp avatar:(BOOL)hasAvatar
{
    CGFloat timestampHeight = (hasTimestamp) ? TIMESTAMP_LABEL_HEIGHT : 0.0f;
    CGFloat avatarHeight = (hasAvatar) ? kJSAvatarSize : 0.0f;
    return MAX(avatarHeight, [JSBubbleView cellHeightForText:bubbleViewText]) + timestampHeight;
}

//add
+ (CGFloat)neededHeightForImageAttimestamp:(BOOL)hasTimestamp avatar:(BOOL)hasAvatar
{
    CGFloat timestampHeight = (hasTimestamp) ? TIMESTAMP_LABEL_HEIGHT : 0.0f;
    CGFloat avatarHeight = (hasAvatar) ? kJSAvatarSize : 0.0f;
    return MAX(avatarHeight, [JSBubbleView cellHeightForImage]) + timestampHeight;
    //return 200;
}

+ (CGFloat)neededHeightForContactAttimestamp:(BOOL)hasTimestamp avatar:(BOOL)hasAvatar
{
    CGFloat timestampHeight = (hasTimestamp) ? TIMESTAMP_LABEL_HEIGHT : 0.0f;
    CGFloat avatarHeight = (hasAvatar) ? kJSAvatarSize : 0.0f;
    return MAX(avatarHeight, [JSBubbleView cellHeightForContact]) + timestampHeight;
    //return 200;
}

#pragma mark - Copying
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(copy:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.bubbleView.text];
    [self resignFirstResponder];
}

#pragma mark - Touch events
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(![self isFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    [menu update];
    [self resignFirstResponder];
}

#pragma mark - Gestures
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan
       || ![self becomeFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    CGRect targetRect = [self convertRect:[self.bubbleView bubbleFrame]
                                 fromView:self.bubbleView];
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

//add
- (void)handleTapPress:(UITapGestureRecognizer *) tapPress
{
//    if(tapPress.state != UIGestureRecognizerStateBegan
//       || ![self becomeFirstResponder])
//        return;
    
    [self.delegate DidSelectBubbleCell:self Action:1];// 1==select
    
}

-(void)DidTouchBubleView{
    
    [self.delegate DidSelectBubbleCell:self Action:1];
    
}
//end add
#pragma mark - Notification
- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    self.bubbleView.selectedToShowCopyMenu = NO;
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    self.bubbleView.selectedToShowCopyMenu = YES;
}

@end