//
//  JSMessagesViewController.m
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

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"
#import <QuartzCore/QuartzCore.h>

//#import "MainChatViewController.h"

//add
#import "JSBubbleView.h"

#define INPUT_HEIGHT 40.0f

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate>

- (void)setup;

@end



@implementation JSMessagesViewController
@synthesize numofrow;
@synthesize bubbleTypeDataCheck;

#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f, 0.0f, size.width, size.height - INPUT_HEIGHT);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.view addSubview:self.tableView];
	
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
    
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self withMenuLeftAreaWidth:70];
    //self.inputToolBarView.widthforlefticonarea = 70;
    
    // TODO: refactor
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;

    UIButton *sendButton = [self sendButton];
    sendButton.enabled = NO;
    sendButton.frame = CGRectMake(self.inputToolBarView.frame.size.width - 61.0f, 8.0f, 59.0f, 26.0f);
    [sendButton addTarget:self
                   action:@selector(sendPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setSendButton:sendButton];
    //[self.view addSubview:self.inputToolBarView];
    
    //add
    UIButton *tattooButton = (UIButton *)[UIButton tattooButton];
    //tattooButton.enabled = NO;
    tattooButton.frame = CGRectMake(40.0f, 8.0f, 23.0f, 24.0f);
    [tattooButton addTarget:self
                   action:@selector(tattooPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setTattooButton:tattooButton];
    //[self.view addSubview:self.inputToolBarView];
    
    
    //option
    UIButton *optionButton = (UIButton *)[UIButton optionButton];
    //tattooButton.enabled = NO;
    optionButton.frame = CGRectMake(5.0f, 8.0f, 23.0f, 24.0f);
    [optionButton addTarget:self
                     action:@selector(optionPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setOptionButton:optionButton];
    [self.view addSubview:self.inputToolBarView];
    
//    NSLog(@"Text Heigh :%f",self.inputToolBarView.textView.contentSize.height);
    
    
    //add
    //self.previousTextViewContentHeight = self.inputToolBarView.textView.contentSize.height;
//    if(!self.previousTextViewContentHeight)
//		self.previousTextViewContentHeight = self.inputToolBarView.textView.contentSize.height;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}
- (UIButton *)tattooButton
{
    return [UIButton tattooButton];
}
- (UIButton *)optionButton
{
    return [UIButton optionButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
    [self performSelector:@selector(registerkeyboard) withObject:nil afterDelay:0.1];
    
    //add
    //[self performSelector:@selector(registerInputView) withObject:nil afterDelay:0.2];
    
    
    //[self.navigationController setNavigationBarHidden:YES];
    
    self.tableView.tableHeaderView = [self CustomHeaderview];
    self.tableView.tableHeaderView.hidden = YES;
}

- (void)registerInputView
{
    //[self finishSend];
//    if(!self.previousTextViewContentHeight)
//        self.previousTextViewContentHeight = 36;
    
    //[self textViewDidEndEditing:self.inputToolBarView.textView];
    
   // [textView becomeFirstResponder];
	
//    if(!self.previousTextViewContentHeight)
//		self.previousTextViewContentHeight = self.inputToolBarView.textView.contentSize.height;
    
    //[self scrollToBottomAnimated:YES];
    
}

- (void)registerkeyboard
{
    [self scrollToBottomAnimated:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self scrollToBottomAnimated:NO];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleWillShowKeyboard:)
//												 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleWillHideKeyboard:)
//												 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.inputToolBarView = nil;
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

-(UIView *)CustomHeaderview{
    
    
    UIView * headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.0f)];
    
    UIButton *btLoadmore = [UIButton buttonWithType:UIButtonTypeCustom];
    btLoadmore.frame = headerview.frame;
    [btLoadmore setBackgroundImage:[UIImage imageNamed:@"prevChat.png"] forState:UIControlStateNormal];
    [btLoadmore addTarget:self action:@selector(DidSelectLoadMore:) forControlEvents:UIControlEventTouchUpInside];
    
    //[btLoadmore setTitle:@"Load more message" forState:UIControlStateNormal];
    
    btLoadmore.contentMode = UIViewContentModeScaleAspectFit;
    
    [headerview addSubview:btLoadmore];
    
    
    return headerview;
}

-(void)DidSelectLoadMore:(id) sender{
    if (self.delegate) {
        [self.delegate didSelectLoadMore];
    }
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
    [self.delegate sendPressed:sender
                      withText:[self.inputToolBarView.textView.text trimWhitespace]];
    
    
    //[self.inputToolBarView adjustTextViewHeightDefault];
}

//add
- (void)tattooPressed:(UIButton *)sender
{
    [self.delegate tattooPressed:sender];
}

- (void)optionPressed:(UIButton *)sender
{
    
    [self.delegate optionPressed:sender];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numofrow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSBubbleTypeData bubbleTypeData = [self.delegate messageTypeDataForRowAtIndexPath:indexPath];
    //JSBubbleTypeData bubbleTypeData;
    
    if (indexPath.row == 0) {
        if (tempCheckDate == nil) {
            tempCheckDate = [[NSMutableArray alloc] init];
        }else{
            [tempCheckDate removeAllObjects];
        }
    }
    
    //load dict
    NSDictionary * dict = [self.dataSource DataDictForRowAtIndexPath:indexPath];
    
//    NSString * textChat = [self.dataSource textForRowAtIndexPath:indexPath];
//    
//    if ([self isTatooFromString:textChat]) {
//        bubbleTypeData = JSBubbleTypeImage;
//    }else{
//        bubbleTypeData = JSBubbleTyeMessage;
//    }
    
    //self.bubbleTypeDataCheck = bubbleTypeData;
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasAvatar,bubbleTypeData];
    JSBubbleMessageCell *cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];

    //JSBubbleMessageCell *cell;
    
//    JSBubbleMessageCell *cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
//                                               bubbleStyle:bubbleStyle
//                                            bubbleTypeData:bubbleTypeData
//                                               avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone
//                                              hasTimestamp:hasTimestamp
//                                           reuseIdentifier:CellID];
    
    if(!cell)
    {
        cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                bubbleTypeData:bubbleTypeData
                                                   avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone
                                                  hasTimestamp:hasTimestamp
                                               reuseIdentifier:CellID];

    }else{
        //clear image tattoo
        [cell setImageSend:nil];
        [cell setMessage:@""];
         cell.delegate = nil;
        cell.datadictcell = nil;
        if(cell.imvPresent != nil)cell.imvPresent = nil;
        if (cell.lbCaption != nil)cell.lbCaption = nil;
//        if (cell.audioview != nil)cell.audioview = nil;
    }
    
    if (bubbleTypeData == JSBubbleTypeContact
        ||bubbleTypeData == JSBubbleTypePhoto
        ||bubbleTypeData == JSBubbleTypeVDO
        ||bubbleTypeData == JSBubbleTypeSound
        ||bubbleTypeData == JSBubbleTypeLocation
        ||bubbleTypeData == JSBubbleTypeLink
        ) {
        cell.delegate = self;
        cell.datadictcell = [dict copy];
    }
    
    cell.currentIndexPath = [indexPath copy];
    
    
        
   // NSLog(@"tempCheckDate: %@", tempCheckDate);
    
    if(hasTimestamp){

        NSString * dtNewFormate = [self CustomDateStringFromDateString:[dict objectForKey:@"TIMESTAMP"]];
        
        BOOL FoundDateDisplay = NO;
        
        for (NSString * dtStr in tempCheckDate) {
            
            
            
            if ([dtNewFormate isEqualToString:dtStr]) {
                FoundDateDisplay = YES;
                break;
            }
        }
        
        
        
        if (!FoundDateDisplay) {//add to temp check
            [tempCheckDate addObject:dtNewFormate];
            
            //show time full format
            NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
            [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
            NSDate *stmpDate=[Dateformats dateFromString:[dict objectForKey:@"TIMESTAMP"]];
            
            NSDateFormatter * DateformatsString= [[NSDateFormatter alloc] init];
            [DateformatsString setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * fulldate = [DateformatsString stringFromDate:stmpDate];
            
            [cell setTimestampString:fulldate];
        }else{
            //show time short format
            
            NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
            [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
            NSDate *stmpDate=[Dateformats dateFromString:[dict objectForKey:@"TIMESTAMP"]];
            
//            NSDateFormatter * DateformatsString= [[NSDateFormatter alloc] init];
//            [DateformatsString setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            [DateformatsString setDateStyle:NSDateFormatterNoStyle];
//            [DateformatsString setTimeStyle:NSDateFormatterShortStyle];
            //[DateformatsString setDateFormat:@"HH:mm"];
            NSString * dtString = [NSDateFormatter localizedStringFromDate:stmpDate
                                           dateStyle:NSDateFormatterNoStyle
                                           timeStyle:NSDateFormatterShortStyle];
            NSString * shortTime = dtString;//[DateformatsString stringFromDate:stmpDate];
            
            
            
            
            [cell setTimestampString:shortTime];
            
        }
        
        
        //[Dateformats setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        //NSDate *stmpDate=[Dateformats dateFromString:[dict objectForKey:@"TIMESTAMP"]];
        
        /*
        NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
        
        [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
        [Dateformats setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *stmpDate=[Dateformats dateFromString:[dict objectForKey:@"TIMESTAMP"]];
        
        
        
        [cell setTimestamp:stmpDate];
    */
        //[cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
        

    }
    if(hasAvatar) {
        switch (type) {
            case JSBubbleMessageTypeIncoming:
                //[cell setAvatarImage:[self.dataSource avatarImageForIncomingMessage]];
                [cell setAvatarImageWithURL:[self.dataSource avatarImageURLForIncomingMessageAtIndexPath:indexPath]];
                break;
                
            case JSBubbleMessageTypeOutgoing:
                //[cell setAvatarImage:[self.dataSource avatarImageForOutgoingMessage]];
                [cell setAvatarImageWithURL:[self.dataSource avatarImageURLForOutgoingMessageAtIndexPath:indexPath]];
                break;
        }
    }
    
   // NSString * textChat = [self.dataSource textForRowAtIndexPath:indexPath];
    
    NSString * textChat = [dict objectForKey:@"MESSAGECHAT"];
    
    if (textChat.length > 0) {
       
        [cell setMessage:textChat];
        
    }else{
        
         //int msgType = (int)[[dict objectForKey:@"MESSAGETYPE"] integerValue];
        
        
        if (bubbleTypeData == JSBubbleTypeContact){//if (msgType == 7) { // share contact
            
//            NSLog(@"dict:%@", dict);
            
            //[cell setImageSend:[self CustomeImageContactFromDict:dict]];
            [cell setImageSendByContact:dict];
            
        }else if (bubbleTypeData == JSBubbleTypeLocation){//if (msgType == 6) { // share location
            
            
            NSString * LocationDetails = [dict objectForKey:@"LOCATIONDETAIL"];

            [cell setMessage:LocationDetails];
            
        }else if (bubbleTypeData == JSBubbleTypePhoto){//if (msgType == 2) { // share photo
            
            
            NSString * imageurl = [dict objectForKey:@"IMAGEURL"];
            
//            if(imageurl.length >0)[cell setImageSendFromImageURL:imageurl];
            
            if(imageurl.length >0){
                
                [cell.imvPresent  setImageWithURL:[NSURL URLWithString:imageurl] completed:nil];
                
//                UIImageView * tmp = [[UIImageView alloc] init];
//                
//                [tmp setImageWithURL:[NSURL URLWithString:imageurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                    
//                    [cell setImageSend:image];
//                    
//                    if(!cell.reloadCellFlag){
//                        [self reloadRowAtIndexPath:indexPath];
//                        
//                        cell.reloadCellFlag = YES;
//                    }
//                    
//                }];
  
                
            }
            
        }else if (bubbleTypeData == JSBubbleTypeSound){//if (msgType == 2) { // share photo
            
            
            NSString * soundurl = [dict objectForKey:@"IMAGEURL"];
            
            //            if(imageurl.length >0)[cell setImageSendFromImageURL:imageurl];
            
            if(soundurl.length >0){
                
                //[cell setMessage:soundurl];
                //[cell.imvPresent setImage:[UIImage imageNamed:@"soundDisplay.png"]];
                cell.audioview.SoundPath = soundurl;
                cell.lbCaption.text = [self getSoundNameFromPath:soundurl];
                [cell.lbCaption setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
                
            }
            
        }else if (bubbleTypeData == JSBubbleTypeVDO){//if (msgType == 2) { // share photo
            
            
            NSString * imageurl = [dict objectForKey:@"VIDEOIMAGE"];
            
            if(imageurl.length >0){
                
                [cell.imvPresent  setImageWithURL:[NSURL URLWithString:imageurl] completed:nil];
                
            }
            
        }
        
        else {
            //return tattoo code
            NSString * ttoo = [dict objectForKey:@"TATTOOCODE"];
            if (ttoo.length>0) {
                
                if ([self isTatooFromString:ttoo]) {
                    
                    UIImage * tattooimg = [self GetTattooImageFormDict:dict];
                    
                    [cell setImageSend:tattooimg];
                    
                }else{
                    [cell setMessage:textChat];
                }
                
            }else{
                
                [cell setMessage:textChat];
                
            }
        }
    }
    
    
    /*
    if ([self isTatooFromString:textChat]) {
        
        UIImage * tattooimg = [self GetTattooImageFormString:textChat];
        
        [cell setImageSend:tattooimg];
        
    }else{
        [cell setMessage:textChat];
    }
     */
    
    [cell setBackgroundColor:tableView.backgroundColor];
    
    return cell;
}

-(NSString * )getSoundNameFromPath:(NSString *)soundpath{
    
    NSArray * soundArr = [soundpath componentsSeparatedByString:@"/"];
    
    NSString * name = (NSString *) [soundArr lastObject];
    
    if (name != nil) {
        return name;
    }else{
        return @"";
    }
}

- (void)reloadRowAtIndexPath:(NSIndexPath *) indexpath {
    
//    NSLog(@"indexpath :%@",indexpath);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexpath.row inSection:indexpath.section];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    //[indexPaths release];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self.inputToolBarView.textView resignFirstResponder];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40.0f;
//}

-(NSString *)CustomDateStringFromDateString:(NSString *) datestring{
    
    NSDateFormatter * DateformatsCheck= [[NSDateFormatter alloc] init];
    [DateformatsCheck setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
    //[DateformatsCheck setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //NSLog(@"dict : %@", datestring);
    NSDate * dtCheck = [DateformatsCheck dateFromString:datestring];
    //NSLog(@"dtCheck : %@", dtCheck);
    
    
    NSDateFormatter * DateNewformats= [[NSDateFormatter alloc] init];
    [DateNewformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dtNewFormate = [DateformatsCheck stringFromDate:dtCheck];
    //NSLog(@"dtNewFormate : %@", dtNewFormate);
    
    NSArray * dateArr = [dtNewFormate componentsSeparatedByString:@" "];
    if ([dateArr count]>0) {
        return (NSString *)[dateArr objectAtIndex:0];
    }else{
        return @"";
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

-(BOOL)isTatooFromString:(NSString *) messagetext
{
    
    //NSLog(@"messagetext: %@",messagetext);
    
    //if (!([messagetext isKindOfClass:[NSNull class]]) || [messagetext isEqualToString:@""]) {
    if (messagetext.length >0) {
        // NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[messagetext length]];
        NSString *ichar  = [NSString stringWithFormat:@"%c", [messagetext characterAtIndex:0]];
        
        if ([ichar isEqualToString:@":"]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(UIImage *)GetTattooImageFormDict:(NSDictionary *) dictchat{
    
    //NSString * imagename = [textname stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * textChat = [dictchat objectForKey:@"TATTOOCODE"];
    NSArray * textArr = [textChat componentsSeparatedByString:@":"];
    
    if ([textArr count]>1) {
        
        NSDictionary * tattoodict = [self GetTattooDictFormCode:[textArr objectAtIndex:1]];
        
        if (![tattoodict isKindOfClass:[NSNull class]]) {
            NSString * imagename = [tattoodict objectForKey:@"TATTOONAME"];
            UIImage * imagetattoo = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imagename]];
            
            if (imagetattoo != nil) {
                
                //found , will load from plist file
                return imagetattoo;
                
            }else{
                //not found , will load from URL
                
                return [self GetImageFromTATTOOURLAtDict:dictchat];
            }
        }else{
            //not found , will load from URL
            
            return [self GetImageFromTATTOOURLAtDict:dictchat];
        }
        
    }else{
        return [UIImage imageNamed:@"tattoo_default.png"];//set default not found Tattoo
    }
    
}

-(UIImage *)GetImageFromTATTOOURLAtDict:(NSDictionary * ) dict{
    NSString * tattoourl = [NSString stringWithFormat:@"%@/assets/image/tattoo/%@",kIPAPIServiceAddress, [dict objectForKey:@"TATTOOURL"] ];
    
    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tattoourl]]];
    
    if (img != nil) {
        return img;
    }else{
        return [UIImage imageNamed:@"tattoo_default.png"];//set default not found Tattoo
    }

}

-(NSDictionary *)GetTattooDictFormCode:(NSString *) tattoocode{
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"TATTOODEFAULT" ofType:@"plist"];
    NSDictionary *openDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //NSLog(@"openDict%@",openDict);
    NSArray * dataTattooArr = [openDict objectForKey:@"TATTOOLIST"];
    
    BOOL flagfound = NO;
    NSDictionary * dictFound = nil;
    
    for (NSDictionary * dt in dataTattooArr) {
        NSArray * tatooArr = [dt objectForKey:@"ITEMARRAY"];
        
        for (NSDictionary * dict in tatooArr) {
            NSString * tcDict = [dict objectForKey:@"TATTOOCODE"];
            if ([tattoocode isEqualToString:tcDict]) {
                flagfound = YES;
                dictFound = [dict copy];
                break;
            }
        }
        
        if (flagfound) {
            break;
        }
        
    }
    
    return dictFound;
}


-(void)LoadDataTattooDefault{
    
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    JSBubbleTypeData bubbleTypeData;
//    
//    NSString * textChat = [self.dataSource textForRowAtIndexPath:indexPath];
//    
//    if ([self isTatooFromString:textChat]) {
//        bubbleTypeData = JSBubbleTypeImage;
//    }else{
//        bubbleTypeData = JSBubbleTyeMessage;
//    }
    JSBubbleTypeData bubbleTypeData = [self.delegate messageTypeDataForRowAtIndexPath:indexPath];
    
    float shiftCell = 10.0f;
    
    //if (self.bubbleTypeDataCheck == JSBubbleTypeImage) {
    if (bubbleTypeData == JSBubbleTypeImage
        ||bubbleTypeData == JSBubbleTypePhoto
        ||bubbleTypeData == JSBubbleTypeVDO
        ||bubbleTypeData == JSBubbleTypeSound
        ||bubbleTypeData == JSBubbleTypeLocation) {
        return [JSBubbleMessageCell neededHeightForImageAttimestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath] avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]]+shiftCell;
    }else if (bubbleTypeData == JSBubbleTypeContact){
        return [JSBubbleMessageCell neededHeightForContactAttimestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath] avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]]+shiftCell;
    }
    else{
        
        NSDictionary * dict = [self.dataSource DataDictForRowAtIndexPath:indexPath];
        NSString * textChat = [dict objectForKey:@"MESSAGECHAT"];
        
        return [JSBubbleMessageCell neededHeightForText: textChat
                                              timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                 avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
        
//        return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
//                                              timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
//                                                 avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];

    }
    
//    return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
//                                          timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
//                                             avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    
//    return [JSBubbleMessageCell neededHeightForImageAttimestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath] avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy]) {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy]) {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

- (void)finishSend
{
    [self.inputToolBarView.textView setText:nil];
    [self textViewDidChange:self.inputToolBarView.textView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
////    NSString * tmpString;
//    
//    if (range.length > 0) {//delete
//        textView.text = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        //current_text = tmpString;
//    }else{//0 add text
//        textView.text = [textView.text stringByAppendingString:text];
//        //current_text = tmpString;
//    }
//
//    [self CheckInputTextView:textView withText:text];
//    
//    return NO;
//}

- (void)textViewDidChange:(UITextView *)textView
{
    
    [self performSelector:@selector(ScheduleCheckInputTextView:) withObject:textView afterDelay:0.05];
    /*
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        if(!isShrinking)
            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                         }
                         completion:^(BOOL finished) {
                             if(isShrinking)
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
     */
}


#pragma mark - BubbleCellDelegate
-(void)DidSelectBubbleCell:(JSBubbleMessageCell *)bubblecell Action:(int)action{
    
    switch (bubblecell.bTypeData) {
        case JSBubbleTypeImage: //tattoo
        {
            //call load tattoo set if don't have
        }
            break;
        case JSBubbleTypePhoto://share image
        {
            NSString * nib_File = @"PreViewPhotoViewController_iPhone";
            
            if (IS_DEVICE_MODEL_5) {
                nib_File = @"PreViewPhotoViewController_iPhone5";
            }
            
            PreViewPhotoViewController * preview = [[PreViewPhotoViewController alloc] initWithNibName:nib_File bundle:nil];
            
//            NSString * urlimage = [bubblecell.datadictcell objectForKey:@"IMAGEURL"];//@"https://www.vdomax.com/photo/anonymous";
//            NSURL *url = [NSURL URLWithString:urlimage];
//            if(urlimage.length>0)[preview.imgPreview setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tattoo_default.png"]];
            
       
            
      
            
            //self.navigationController.navigationBarHidden = YES;
            
            AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];

            [app.window.rootViewController presentViewController:preview animated:YES completion:^{
                NSString * urlimage = [bubblecell.datadictcell objectForKey:@"IMAGEURL"];//@"https://www.vdomax.com/photo/anonymous";
                NSURL *url = [NSURL URLWithString:urlimage];
                if(urlimage.length>0)[preview.imgPreview setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tattoo_default.png"]];
            }];
            
        }
            break;
        case JSBubbleTypeContact:
        {
            //call profile page from june's code
            
            /* //add Jun's code* สามารถ push profile view เข้ามาได้เลยครับ */
            
            
            
            /****** end June's code*****/
            
            
        }
            break;
        case JSBubbleTypeVDO:
        {
            NSString * urlvdo = [bubblecell.datadictcell objectForKey:@"VIDEOURL"];
            
//            NSURL *url = [NSURL URLWithString:@"http://203.151.162.5/app2/mp4:1f9e5d45ee22f2811b896096a44384f9.mp4/playlist.m3u8"];
            MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlvdo]];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlaybackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:mp];
            
            mp.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
            mp.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
            
            AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
            app.flagOrientationAll = YES;
            [app.window.rootViewController presentMoviePlayerViewControllerAnimated:mp];
            
            
            
            
            /*
            CGRect  cRect;
            
            if (IS_DEVICE_MODEL_5) {
                 cRect = CGRectMake(0,0,320,480);
            }else{
                cRect = CGRectMake(0, 0, 320, 568);
            }
            
            YouTubeView *videoVw = [[YouTubeView alloc] initWithStringAsURL:[NSString
                                                                             stringWithFormat:@"%@",urlvdo] frame:cRect mimeSubType:@"x-shockwave-flash"];
                                    
                                    //[self.view addSubview:videoVw];
            
            AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
            
            
            [app.window.rootViewController presentViewController:videoVw animated:YES completion:nil];
                                    
            */
        }
            break;
        case JSBubbleTypeSound:
        {
//            NSString *url = [NSString stringWithFormat :@"http://www.soundjay.com/button/button-2.mp3"];
//            NSURL *fileURL = [NSURL URLWithString:url];
//            
//            MPMoviePlayerController * moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
//            [moviePlayerController.view setFrame:CGRectMake(0, 70, 320, 270)];
//            [self.view addSubview:moviePlayerController.view];
//            moviePlayerController.fullscreen = YES;
//            moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
//            [moviePlayerController play];
            
            NSString * nib_File = @"AudioPlayViewController_iPhone";
            
            if (IS_DEVICE_MODEL_5) {
                nib_File = @"AudioPlayViewController_iPhone5";
            }
            
            AudioPlayViewController * audiopreview = [[AudioPlayViewController alloc] initWithNibName:nib_File bundle:nil];
            
            
            NSString * urlsound = [bubblecell.datadictcell objectForKey:@"IMAGEURL"];
            audiopreview.SoundPath = urlsound;
            
            AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
            
            
            [app.window.rootViewController presentViewController:audiopreview animated:YES completion:nil];
            //UIViewController * vc = app.window.rootViewController;
            
//            [vc.navigationController pushViewController:audiopreview animated:YES];
            //[vc.view addSubview:audiopreview.view];
            //[self.parentViewController presentViewController:audiopreview animated:YES completion:nil];
            
        }
            break;
        case JSBubbleTypeLocation:
        {
            
            NSDictionary * datadict = (NSDictionary *)bubblecell.datadictcell;
            NSString * placename = [datadict objectForKeyedSubscript:@"LOCATIONDETAIL"];
            double la_t = [[datadict objectForKeyedSubscript:@"LOCATION_LATITUDE"] doubleValue];
            double long_t = [[datadict objectForKeyedSubscript:@"LOCATION_LONGTITUDE"] doubleValue];
            
            CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake(la_t,long_t);

                //Apple Maps, using the MKMapItem class
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:rdOfficeLocation addressDictionary:nil];
                MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
                item.name = placename;
                [item openInMapsWithLaunchOptions:nil];
        }
            break;
        case JSBubbleTypeLink:
        {
            //open link
            NSDictionary * datadict = (NSDictionary *)bubblecell.datadictcell;
            NSString * urlLink = [datadict objectForKeyedSubscript:@"MESSAGECHAT"];
            
            if ([self isYoutubeLink:urlLink]) {
                CGRect  cRect;
                
                if (IS_DEVICE_MODEL_5) {
                    cRect = CGRectMake(0,0,320,480);
                }else{
                    cRect = CGRectMake(0, 0, 320, 568);
                }
                
                YouTubeView *videoVw = [[YouTubeView alloc] initWithStringAsURL:[NSString
                                                                                 stringWithFormat:@"%@",urlLink] frame:cRect mimeSubType:@"x-shockwave-flash"];
                
                //[self.view addSubview:videoVw];
                
                AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
                //app.flagOrientationAll = YES;
                
                UIViewController * vc = [[UIViewController alloc] init];
                vc.view.frame = [[UIScreen mainScreen] bounds];
                [vc.view addSubview:videoVw];
                [app.window.rootViewController presentViewController:vc animated:YES completion:nil];
                
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlLink]];
            }
            
            
            
        }
            break;
        default:
            break;
    }
    
    
}

-(void)moviePlaybackDidFinish:(MPMoviePlayerViewController* ) mv{
    
    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    app.flagOrientationAll = NO;
    
}

-(BOOL)isYoutubeLink:(NSString *) link{
    
    NSURL * url = [NSURL URLWithString:link];
    
    if ([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]) {
        
        NSArray * arr = [link componentsSeparatedByString:@"www.youtube.com"];
        
        if ([arr count] > 1) {
            return YES;
        }else{
            return NO;
        }
        
    }else{
        return NO;
    }
    
}
-(BOOL)isNewLineForLastCharacterInText:(NSString *)text TextView:(UITextView *)textView{
    
    NSMutableArray *charArr = [NSMutableArray array];
    for (int i = 0; i < [text length]; i++) {
        [charArr addObject:[NSString stringWithFormat:@"%C", [text characterAtIndex:i]]];
    }
    
//    NSLog(@"Text Array is:%@",charArr);
    
    if ([text length] >0) {
        int numoftextperline = [JSBubbleView maxCharactersPerLine];
        
        NSArray * textArr = [text componentsSeparatedByString:@"\n"];
        NSString * lastText =[textArr lastObject];
        
        int tmpCountwrapping = [self countWrappingTextView:textView];
        BOOL isWrapping = NO;
        
        if (tmpCountwrapping != self.countwrappingtext) {
            isWrapping = YES;
            self.countwrappingtext = tmpCountwrapping;
        }
        
        //if ([[charArr lastObject] isEqualToString:@"\n"] || ([text length] > numoftextperline && [lastText length] % numoftextperline == 1))
        if ([[charArr lastObject] isEqualToString:@"\n"] || isWrapping) {
            
            return YES;
        }else{
            return NO;
        }
        
    }else{
        return NO;
    }
    
}

-(int )countWrappingTextView:(UITextView *)textView{
    
    NSLayoutManager *layoutManager = [textView layoutManager];
    unsigned numberOfLines, index, numberOfGlyphs =
    [layoutManager numberOfGlyphs];
    NSRange lineRange;
    for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
        (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
                                               effectiveRange:&lineRange];
        index = NSMaxRange(lineRange);
    }
    
    return numberOfLines;
}

-(BOOL )isLastCharNewLine:(NSString *)text{
    
    //NSString *string;
//    unsigned numberOfLines, index, stringLength = [text length];
//    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
//        index = NSMaxRange([text lineRangeForRange:NSMakeRange(index, 0)]);
//    
//    return numberOfLines;
    
    NSMutableArray *charArr = [NSMutableArray array];
    for (int i = 0; i < [text length]; i++) {
        [charArr addObject:[NSString stringWithFormat:@"%C", [text characterAtIndex:i]]];
    }
    
    if ([[charArr lastObject] isEqualToString:@"\n"]){
        return YES;
    }else{
        return NO;
    }
    
//    NSArray * textArr = [text componentsSeparatedByString:@"\n"];
//    
//    if ([textArr count] >0) {
//        return [textArr count] -1;
//    }else{
//        return 0;
//    }
}

-(void)ScheduleCheckInputTextView:(UITextView *)textView{
//-(void)CheckInputTextView:(UITextView *)textView withText:(NSString *) text{

    if ([textView.text trimWhitespace].length >0) {
        
        CGFloat maxHeight = [JSMessageInputView maxHeight];
        CGFloat textViewContentHeight = textView.contentSize.height;
        BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
        CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
        
        int tmpCountWrapping = ([self countWrappingTextView:textView] -1 > 0)?([self countWrappingTextView:textView] -1):0;//decrease 1 line
        if ([self isLastCharNewLine:textView.text]) {
            tmpCountWrapping+=1;
        }
        
        if (tmpCountWrapping != self.countwrappingtext && tmpCountWrapping <= 6) {
            if (tmpCountWrapping < self.countwrappingtext) {
                changeInHeight = -25;
            }else{
                changeInHeight = 25;
            }
            
            self.countwrappingtext = tmpCountWrapping;
            
        }
        else{
            changeInHeight = 0;
        }
        
        //if([textView.text trimWhitespace].length <=0)changeInHeight = changeInHeight * previousenewlinecount;
        
        keepchangelinehiegh+= changeInHeight;
        
        
        if (changeInHeight != 0.0f) {
            [UIView animateWithDuration:0.25f
                             animations:^{
                                 UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                        0.0f,
                                                                        self.tableView.contentInset.bottom + changeInHeight,
                                                                        0.0f);
                                 
                                 self.tableView.contentInset = insets;
                                 self.tableView.scrollIndicatorInsets = insets;
                                 [self scrollToBottomAnimated:NO];
                                 
                                 CGRect inputViewFrame = self.inputToolBarView.frame;
                                 self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                          inputViewFrame.origin.y - changeInHeight,
                                                                          inputViewFrame.size.width,
                                                                          inputViewFrame.size.height + changeInHeight);
                             }
                             completion:^(BOOL finished) {
                                 
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];

                             }];
        }
    }else{
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + (-1*keepchangelinehiegh),
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - (-1*keepchangelinehiegh),
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + (-1*keepchangelinehiegh));
                         }
                         completion:^(BOOL finished) {
                             
                             [self.inputToolBarView adjustTextViewHeightBy:-1*keepchangelinehiegh];
                             keepchangelinehiegh = 0;
                             self.countwrappingtext = 0;
                             
                         }];
        
    }
    


  
        self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
    
    CGRect tattooframe = self.inputToolBarView.tattooButton.frame;
    self.inputToolBarView.tattooButton.frame = CGRectMake(tattooframe.origin.x, self.inputToolBarView.sendButton.frame.origin.y, tattooframe.size.width, tattooframe.size.height);
    CGRect optionframe = self.inputToolBarView.optionButton.frame;
    self.inputToolBarView.optionButton.frame = CGRectMake(optionframe.origin.x, self.inputToolBarView.sendButton.frame.origin.y, optionframe.size.width, optionframe.size.height);
    
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
//    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
//    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    NSLog(@"KeyBoard Frame: %@",NSStringFromCGRect(keyboardRect));
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;

                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           inputViewFrameY,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                         
                         
                         
                     }];
     
     
}

- (void)updateTableViewInsets{
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                           0.0f,
                                           self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                           0.0f);
    
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}


- (void)keyboardHanddleShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //    NSLog(@"KeyBoard Frame: %@",NSStringFromCGRect(keyboardRect));
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                         
                         
                         
                     }];
    
    
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
    
    
    //add
    //[self.inputToolBarView.textView resignFirstResponder];
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}



-(void)keyboardDidShow:(UIView *)keyboardview PostOriginalKeyboard:(CGFloat)orgkeyboardY{
    
    return;
    
//    NSLog(@"hidden ey : %d",keyboardview.hidden);
//    NSLog(@"key y : %f",orgkeyboardY);
//    NSLog(@"keyboardview y : %@",NSStringFromCGRect(keyboardview.frame));
//    NSLog(@"inputToolBarView y : %@",NSStringFromCGRect(self.inputToolBarView.frame));
    if (keyboardview.hidden == NO && self.inputToolBarView.frame.origin.y > keyboardview.frame.origin.y) {
        
        //move and display text input
        
//        CGRect inputViewFrame = self.inputToolBarView.frame;
//        //CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
//        inputViewFrame.origin.y = inputViewFrame.origin.y - keyboardview.frame.size.height;
//        self.inputToolBarView.frame = inputViewFrame;
//        
//        NSLog(@"inputViewFrame y : %@",NSStringFromCGRect(inputViewFrame));
//         NSLog(@"inputToolBarView new y : %@",NSStringFromCGRect(self.inputToolBarView.frame));
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             CGRect screenRect = [[UIScreen mainScreen] bounds];
                             CGFloat defaultkeyY = screenRect.size.height - keyboardview.frame.size.height;
                             
                            [self keyboardWillSnapBackToPoint:CGPointMake(0.0f, defaultkeyY)];
                             
                             
                             keyboardview.frame = CGRectMake(0.0f,
                                                              defaultkeyY,
                                                              keyboardview.frame.size.width,
                                                              keyboardview.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
        
    }
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                           0.0f,
                                           self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                           0.0f);
    
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;

}

-(void)keyboardWillShow:(UIView *)keyboardview PostOriginalKeyboard:(CGFloat)orgkeyboardY{
    return;
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect screenRect = [[UIScreen mainScreen] bounds];
                         CGFloat defaultkeyY = screenRect.size.height - keyboardview.frame.size.height;
                         
                         [self keyboardWillSnapBackToPoint:CGPointMake(0.0f, defaultkeyY)];
                         
                         
                         keyboardview.frame = CGRectMake(0.0f,
                                                         defaultkeyY,
                                                         keyboardview.frame.size.width,
                                                         keyboardview.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    
    
}


-(void)keyboardWillHide:(UIView *)keyboardview PostOriginalKeyboard:(CGFloat)orgkeyboardY{
    
    return;
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
    
    
    
    if (keyboardview.hidden == NO) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             keyboardview.frame = CGRectMake(0.0f,
                                                              screenHeight,
                                                              keyboardview.frame.size.width,
                                                              keyboardview.frame.size.height);
                             
                                 [self keyboardWillBeDismissed];
                         }
                         completion:^(BOOL finished) {
                             keyboardview.hidden = YES;
                             keyboardview.frame = CGRectMake(0.0f,
                                                              screenHeight,
                                                              keyboardview.frame.size.width,
                                                              keyboardview.frame.size.height);
                             
                             [self.inputToolBarView.textView resignFirstResponder];
                             
                             
                         }];    }
    
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                           0.0f,
                                           self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                           0.0f);
    
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;

    
}

@end