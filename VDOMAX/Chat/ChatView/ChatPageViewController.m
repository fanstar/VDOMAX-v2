/***
 Messagetype
 0=message
 1=tattoo
 2=image
 3=vdo
 6=location
 7=sharecontact
 ***/

#import "ChatPageViewController.h"

@implementation ChatPageViewController
@synthesize delegate;
@synthesize conversation_id;
@synthesize recentdatadict;
@synthesize user_id;
@synthesize friend_id;
@synthesize token_id;
@synthesize mydatadict;
@synthesize myBadgePush;
@synthesize myImage;


#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     message_page= 1; //default
    message_pagesize = 20;
    enableLoadMore = YES;
    /*
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"Messages";
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     @"Testing some messages here.",
                     @"Options for avatars: none, circles, or squares",
                     @"This is a complete re-write and refactoring.",
                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
                     nil];
    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];
    */
    
    if ([self.recentdatadict count]>0 ) {
        // create socket.io client instance
        socketIO = [[SocketIO alloc] initWithDelegate:self];
        
//        NSLog(@"datadict is: %@",self.recentdatadict);
        
        NSDictionary * frienddict = [[self.recentdatadict objectForKey:@"DATARECENTCHAT"]objectForKey:@"USERFRIENDPROFILE" ];
        
        //self.user_id = [[self.datadict objectForKey:@"USERID"] integerValue];
        self.friend_id = (int)[[frienddict objectForKey:@"FRIENDID"] integerValue];
        //self.token_id = [self.datadict objectForKey:@"USERTOKEN"];
        
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.user_id],@"userID",self.token_id,@"userToken",[NSString stringWithFormat:@"%d",self.friend_id],@"FRIENDID",@"user",@"type", nil];
        
        
        NSString * fName = [frienddict objectForKey:@"FRIENDNAME"];
        if(fName.length > 0)self.navigationItem.title = fName;
        
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"mydatadict" message:[NSString stringWithFormat:@"%@",self.mydatadict] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        
//        UIAlertView * alert2 = [[UIAlertView alloc] initWithTitle:@"friend_id" message:[NSString stringWithFormat:@"%d",self.friend_id] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert2 show];
        
        //open secure HTTPS://
        //socketIO.useSecure = YES;
        
        [socketIO connectToHost:kIPChat onPort:3000 withParams:param];
    }
    
    
    //self.title = @"Messages";
    
//    self.messages = [[NSMutableArray alloc] initWithObjects:
//                     @"Testing some messages here.",
//                     @"Options for avatars: none, circles, or squares",
//                     @"This is a complete re-write and refactoring.",
//                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
//                     nil];
    
    
    
    //NSArray * data = [NSArray arrayWithObjects:dict1,dict2,dict3,dict4, nil];
    
    // NSMutableDictionary * dt = [[NSMutableDictionary alloc] init];
//    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"MESSAGETYPE"
//                           ,@"defualt text",@"MESSAGECHAT"
//                           ,@"2",@"SENDERID"
//                           ,@"name2",@"SENDERUSERNAME"
//                           , nil];
    
//    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"MESSAGETYPE"
//                           ,@"default text", @"MESSAGECHAT"
//                           ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
//                           ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
//                           ,@"", @"TATTOOCODE"
//                           ,@"", @"TATTOOURL"
//                           ,@"", @"IMAGEURL"
//                           ,@"", @"IMAGETYPE"
//                           ,@"", @"IMAGENAME"
//                           ,@"", @"VIDEOURL"
//                           ,@"", @"VIDEOIMAGE"
//                           ,@"", @"LOCATION_LATITUDE"
//                           ,@"", @"LOCATION_LONGTITUDE"
//                           ,@"", @"LOCATIONDETAIL"
//                           ,@"", @"CONTACTNAME"
//                           ,@"", @"CONTACTDETAILS"
//                           ,@"", @"SENDERUSERNAME"
//                           ,@"", @"TIMESTAMP"
//                           ,@"", @"TIMESTAMPMS"
//                           , nil];
    
    self.messages = [[NSMutableArray alloc] init];
    //self.timestamps = [[NSMutableArray alloc] init];
    
//    [self.messages addObject:dict];
//
//    
//    
//    self.timestamps = [[NSMutableArray alloc] initWithObjects:
//                       [NSDate distantPast],
//                       [NSDate distantPast],
//                       [NSDate distantPast],
//                       [NSDate date],
//                       nil];
    
    messageview = [[JSMessagesViewController alloc] initWithNibName:nil bundle:nil];
    
    messageview.delegate = self;
    messageview.dataSource = self;
    messageview.numofrow = 0;//[self.messages count];
    messageview.view.frame = self.view.frame;
    [self.view addSubview:messageview.view];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
//                                                                                           target:self
//                                                                                           action:@selector(buttonPressed:)];


    [self customNavBar];
    
    
   
    //Custome Load More
    refreshControl = [[ODRefreshControl alloc] initInScrollView:messageview.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

}

-(void)viewWillAppear:(BOOL)animated{
    
    if(self.myImage == nil){//Load prepare my image
        
        if (self.mydatadict != nil) {
            NSString * imageNameOut = [self.mydatadict objectForKey:@"UserAvatarPath"];
            
            NSArray * words = [imageNameOut componentsSeparatedByString:@"graph.facebook.com"];
            
            if ([words count] < 2) {
                imageNameOut = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,imageNameOut];
            }
            
            UIImageView * tmp = [[UIImageView alloc] init];
            [tmp setImageWithURL:[NSURL URLWithString:imageNameOut] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                self.myImage = image;
            }];
        }
        
        
    }
}



-(void)customNavBar{
    

//    UIButton *rButton =  [UIButton buttonWithType:UIButtonTypeCustom];
//    [rButton setFrame:CGRectMake(0,0,44,35)];
//    rButton.showsTouchWhenHighlighted = YES;
//    [rButton setBackgroundImage:[UIImage imageNamed:@"more_nav_bar_button.png"] forState:UIControlStateNormal];
//    [rButton addTarget:self action:@selector(showchatmenubar) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem * rightbutton = [[UIBarButtonItem alloc] initWithCustomView:rButton];
//    self.navigationItem.rightBarButtonItem = rightbutton;//menu
    
    
    UIButton *lButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setFrame:CGRectMake(0,0,20,33)];
    lButton.showsTouchWhenHighlighted = YES;
    [lButton setBackgroundImage:[UIImage imageNamed:@"back_nav_button.png"] forState:UIControlStateNormal];
    [lButton addTarget:self action:@selector(BackToChat) forControlEvents:UIControlEventTouchUpInside];//back
    
    UIBarButtonItem * leftbutton = [[UIBarButtonItem alloc] initWithCustomView:lButton];
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    //self.navigationItem.title = @"ChatView";
    
}

-(void)BackToChat{
    
    if (waitingBack) return;
    
    //NSLog(@"testtt");
    
    waitingBack = YES;
    
    if (viewOption != nil){
        [viewOption.view removeFromSuperview];
        viewOption = nil;
    }
    
    if (tattooView != nil){
        [tattooView.view removeFromSuperview];
        tattooView = nil;
    }
    
    //call update recent chat
    //if([self.messages count]>0)[self updateLastDictForRecentChat:[self.messages lastObject]];
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"chat page" message:[NSString stringWithFormat:@"chat page user_id:%d con_id:%d",self.user_id,self.conversation_id] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    if(self.conversation_id > 0){
        [self sendRequestClearBadgeDataWithUserID:self.user_id ConversationID:self.conversation_id];
        [self.delegate ChatPageViewClosedAndUpdateLastChatDict:[self ChangeFormatRecentChatDict:self.recentdatadict WithChatDict:[self.messages lastObject]]];
    }
    else {
        [self.delegate ChatPageViewClosedAndUpdateLastChatDict:[self ChangeFormatRecentChatDict:self.recentdatadict WithChatDict:[self.messages lastObject]]];
        
//        [self.navigationController popViewControllerAnimated:YES];

    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self.delegate ChatPageViewClosedAndUpdateLastChatDict:[self ChangeFormatRecentChatDict:self.recentdatadict WithChatDict:[self.messages lastObject]]];
//    
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dropViewDidBeginRefreshing

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshContr
{
    if (enableCallService)return;
    
    message_page = message_page+1;
    
    [self sendRequestLoadChatHistoryConvertsationID:self.conversation_id UserID:self.user_id FriendID:self.friend_id MessagePage:message_page  MessageSize:message_pagesize];
    
}

//- (void)LoadMoreRequest
//{
//    
//    message_page = message_page+1;
//    
//    [self sendRequestLoadChatHistoryConvertsationID:self.conversation_id UserID:self.user_id FriendID:self.friend_id MessagePage:message_page  MessageSize:message_pagesize];
//    
//}


-(NSDictionary *)ChangeFormatRecentChatDict:(NSDictionary *) recdict WithChatDict:(NSDictionary *) chatdt{
    
    /*
     "CID": "2",
     "DATARECENTCHAT": {
     "MYPROFILE": {
     "USERID": "11",
     "USERNAME": "shescale",
     "USERIMAGE": "b004cb76a8add0ab2a4771aab16cc04c",
     "USERTOKEN": "asdf11",
     "USERTOKENMOBILE": "asdf11",
     "STATUS": ""
     },
     "USERFRIENDPROFILE": {
     "FRIENDID": "4",
     "FRIENDNAME": "hatecandid",
     "FRIENDIMAGE": "anonymous",
     "USERTOKEN": "1a1b16dce528d71746c09b95f2b1f5af",
     "USERTOKENMOBILE": "babe3a8651c30a1b7d7e5ab184d33c07",
     "STATUS": ""
     },
     "LASTMESSAGE": []
     }
     */
    
    NSDictionary * mydict =[[recdict objectForKey:@"DATARECENTCHAT"] objectForKey:@"MYPROFILE"];
    NSDictionary * frienddict =[[recdict objectForKey:@"DATARECENTCHAT"] objectForKey:@"USERFRIENDPROFILE"];
    
    NSArray * arrmess = [[NSArray alloc] initWithObjects:chatdt, nil];
    
    NSDictionary * chatdict = [[NSDictionary alloc] initWithObjectsAndKeys:mydict,@"MYPROFILE"
                               ,frienddict,@"USERFRIENDPROFILE"
                               ,arrmess,@"LASTMESSAGE"
                               , nil];
    
    NSDictionary * recentdict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.conversation_id],@"CID"
                                 ,chatdict,@"DATARECENTCHAT"
                                 , nil];
    
    
    return recentdict;
    
}


-(void)showchatmenubar{
    
    if(chatmenushow){
        [self.uiviewchatmenu removeFromSuperview];
        chatmenushow = NO;
    }else{
        [self.view addSubview:self.uiviewchatmenu];
        chatmenushow = YES;
    }
    
    
}

//- (void)buttonPressed:(UIButton*)sender
//{
//    // Testing pushing/popping messages view
//    DemoViewController *vc = [[DemoViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - Table view data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.messages.count;
//}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    
    if(text.length <= 0) return;
    //[self.messages addObject:text];
    
    
    //NSArray * data = [NSArray arrayWithObjects:dict1,dict2,dict3,dict4, nil];
    
    // NSMutableDictionary * dt = [[NSMutableDictionary alloc] init];
//    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"MESSAGETYPE"
//                           ,text,@"MESSAGECHAT"
//                           ,@"2",@"SENDERID"
//                           ,@"name2",@"SENDERUSERNAME"
//                           , nil];
    
    
    NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
    [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
    NSString * dtString = [Dateformats stringFromDate:[NSDate date]];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"MESSAGETYPE"
                           ,text, @"MESSAGECHAT"
                           ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
                           ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
                           ,@"", @"TATTOOCODE"
                           ,@"", @"TATTOOURL"
                           ,@"", @"IMAGEURL"
                           ,@"", @"IMAGETYPE"
                           ,@"", @"IMAGENAME"
                           ,@"", @"VIDEOURL"
                           ,@"", @"VIDEOIMAGE"
                           ,@"", @"LOCATION_LATITUDE"
                           ,@"", @"LOCATION_LONGTITUDE"
                           ,@"", @"LOCATIONDETAIL"
                           ,@"", @"CONTACTNAME"
                           ,@"", @"CONTACTDETAILS"
                           ,[self.mydatadict objectForKey:@"UserAvatarPath"], @"SENDERIMAGE"
                           ,[self.mydatadict objectForKey:@"UserName"], @"SENDERUSERNAME"
                           ,dtString, @"TIMESTAMP"
                           ,@"", @"TIMESTAMPMS"
                           , nil];
    
    
    
    
    
    [self.messages addObject:dict];
    
    
    //[self.timestamps addObject:[NSDate date]];
    
//    if((self.messages.count - 1) % 2)
//        [JSMessageSoundEffect playMessageSentSound];
//    else
//        [JSMessageSoundEffect playMessageReceivedSound];
    
    [JSMessageSoundEffect playMessageSentSound];
    
    messageview.numofrow = (int )[self.messages count];
    
    //[self finishSend];
    [messageview finishSend];
    
    
    //[socketIO sendMessage:@"I hear u"];
    [socketIO sendEvent:@"SendMessage" withData:dict];
    
    //end tes
    
    
}


//add
-(void)tattooPressed:(UIButton *)sender{
//    NSLog(@"tattoo pressed");
    
    [messageview.inputToolBarView.textView becomeFirstResponder];
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            
            if (tattooView == nil) {
                //created subview
                tattooView = [[TattooViewController alloc] initWithNibName:@"TattooViewController_iPhone" bundle:nil];
                
                tattooView.delegate = self;
                keyboard = [[keyboard subviews] objectAtIndex:1];
                [keyboard addSubview:tattooView.view];
                
                //check keyboard
                
                AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                app.delegate2 = self;
                
            }else{
                [tattooView.view removeFromSuperview];
                tattooView = nil;
                
                if (viewOption == nil) {
                    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    app.delegate2 = nil;
                }
            }
            
        }
        
    }
    
    if (viewOption != nil){
        [viewOption.view removeFromSuperview];
        viewOption = nil;
    }
}



-(void)optionPressed:(UIButton *)sender{
//    NSLog(@"option pressed");
    
    [messageview.inputToolBarView.textView becomeFirstResponder];

    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            
            if (viewOption == nil) {
                //created subview
                viewOption = [[OptionMenuViewController alloc] initWithNibName:@"OptionMenuViewController_iPhone" bundle:nil];
                viewOption.delegate = self;
                keyboard = [[keyboard subviews] objectAtIndex:1];
                [keyboard addSubview:viewOption.view];
                
                AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                app.delegate2 = self;
                
            }else{
                [viewOption.view removeFromSuperview];
                viewOption = nil;
                
                if (tattooView == nil) {
                    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    app.delegate2 = nil;
                }
            }

        }
 
    }
    
    if (tattooView != nil) {
        [tattooView.view removeFromSuperview];
        tattooView = nil;
    }
    
}

-(void)CheckDelegateDidBecame{
 
    if (tattooView != nil) {
        [tattooView.view removeFromSuperview];
        tattooView = nil;
        
        [self tattooPressed:nil];
    }else if (viewOption != nil) {
        [viewOption.view removeFromSuperview];
        viewOption = nil;
        
        [self optionPressed:nil];
    }
}


-(void)recordPressed:(UIButton *)sender{
//    NSLog(@"record pressed");
    
//    [messageview.inputToolBarView.textView becomeFirstResponder];
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            
            if (reccordView == nil) {
                //created subview
                reccordView = [[RecordViewController alloc] initWithNibName:@"RecordViewController_iPhone" bundle:nil];
                reccordView.delegate = self;
                keyboard = [[keyboard subviews] objectAtIndex:1];
                [keyboard addSubview:reccordView.view];
            }
            
//            else{
//                [reccordView.view removeFromSuperview];
//                reccordView = nil;
//            }
            
        }
        
    }
    
//    if (tattooView != nil) {
//        [tattooView.view removeFromSuperview];
//        tattooView = nil;
//    }
//    
//    if (viewOption != nil) {
//        [viewOption.view removeFromSuperview];
//        viewOption = nil;
//    }
}


#pragma mark - RecordViewDelegate
-(void)DidcancelRecordView{
    if (reccordView != nil) {
        [reccordView.view removeFromSuperview];
        reccordView = nil;
    }
}

-(void)DidSendRecordView:(RecordViewController *)recorderview FilePath:(NSString *)filepart
{
    
    //call service sendfile
    
//    NSLog(@"record url: %@",filepart);
    if (enableCallService)return;
    
    [self sendRequestUploadSoundFile:filepart withTokenID:self.token_id];
    
    

    
    if (reccordView != nil) {
        [reccordView.view removeFromSuperview];
        reccordView = nil;
    }
    
    
}


//end add

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
    
    
    NSDictionary * dtdict = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
    
    int typedata = (int)[[dtdict objectForKey:@"SENDERID"] integerValue];
    
    return (typedata == self.user_id) ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
    //SENDERID
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

-(JSBubbleTypeData)messageTypeDataForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return JSBubbleTyeMessage;
    //return JSBubbleTypeImage;
    
        NSDictionary * dict = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
        NSString * mess = [dict objectForKey:@"MESSAGECHAT"];
    
    
    if (mess.length >0) {
        
        
        NSURL * urlcheck = [NSURL URLWithString:mess];
        
        if ([[urlcheck scheme] isEqual:@"http"] ||  [[urlcheck scheme] isEqual:@"https"]) {
            return JSBubbleTypeLink;
        }else{
            return JSBubbleTyeMessage;
        }
        
        
        
    }else{
        
        NSDictionary * dict = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
        NSString * ttcode = [dict objectForKey:@"TATTOOCODE"];
        
         int msgType = (int)[[dict objectForKey:@"MESSAGETYPE"] integerValue];
        
        if([self isTatooFromString:ttcode]){
            return JSBubbleTypeImage;
        }else if(msgType == 2) //photo
        {
            NSString * msgSound = [dict objectForKey:@"IMAGETYPE"];
            
            if ([msgSound isEqualToString:@"other"]) {
                return JSBubbleTypeSound;
            }else{
                return JSBubbleTypePhoto;
            }
            
        }else if(msgType == 3)
        {
            return JSBubbleTypeVDO;
        }else if(msgType == 6)
        {
            return JSBubbleTypeLocation;
        }else if(msgType == 7)
        {
            return JSBubbleTypeContact;
        }
        else if(msgType == 8)
        {
            return JSBubbleTypeSound;
        }
        else{
            return JSBubbleTyeMessage;
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([self.messages count] >= message_pagesize && indexPath.row<=0) {
//        NSLog(@" Display last row : %d ",indexPath.row);
//        [self showFooter];
//    }
    
}


//-(void)showFooter
//{
//    [self.activityLoadMore startAnimating];
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         messageview.tableView.tableFooterView = self.footerView;
//                     }
//                     completion:^(BOOL finished){
//                         
//                         [self LoadMoreRequest];
//                         
//                     }];
//    
//}
//
//-(void)hideFooter
//{
//    [self.activityLoadMore stopAnimating];
//    [UIView animateWithDuration:0.7 animations:^{
//        messageview.tableView.tableFooterView = nil;
//    }];
//}

- (void)didSelectLoadMore{
    
    
//    if (enableLoadMore) {
//        
//        if (self.conversation_id > 0) {
//            enableLoadMore = NO;
//            message_page = message_page +1;
//            
//            [self sendRequestLoadChatHistoryConvertsationID:self.conversation_id UserID:self.user_id FriendID:self.friend_id MessagePage:message_page  MessageSize:message_pagesize];
//        }
//        
//    }
    
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    //return JSMessagesViewTimestampPolicyEveryThree;
    return JSMessagesViewTimestampPolicyAll;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    //return JSAvatarStyleSquare;
    return JSAvatarStyleCircle;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

#pragma mark - Messages view data source
/*
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [self.messages objectAtIndex:indexPath.row];
    
    NSDictionary * dict = (NSDictionary * )[self.messages objectAtIndex:indexPath.row];
    NSString * text = [dict objectForKey:@"MESSAGECHAT"];
    
    
    if (text.length > 0) {
        return text;
    }else{
        //return tattoo code
        NSString * ttoo = [dict objectForKey:@"TATTOOCODE"];
        if (ttoo.length>0) {
            return ttoo;
        }else{
            return text;
        }
    }
    
    return text;
}
 */

-(NSDictionary *)DataDictForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.messages objectAtIndex:indexPath.row];
}

//- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.timestamps objectAtIndex:indexPath.row];
//}

//- (UIImage *)avatarImageForIncomingMessage
//{
//    //return [UIImage imageNamed:@"demo-avatar-woz"];
//    return incomingImage;
//}
//
//- (UIImage *)avatarImageForOutgoingMessage
//{
//    //return [UIImage imageNamed:@"demo-avatar-jobs"];
//    return outgoingImage;
//}

-(NSString *)avatarImageURLForIncomingMessageAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = (NSDictionary * )[self.messages objectAtIndex:indexPath.row];
    NSString * imageNameIn = [dict objectForKey:@"SENDERIMAGE"];
    
    NSArray * words = [imageNameIn componentsSeparatedByString:@"graph.facebook.com"];
    
    //        NSLog(@"words = %@",words);
    
    if ([words count] < 2) {
        imageNameIn = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,imageNameIn];
    }
    
    return imageNameIn;
    
//    NSString * urlImageIn = [NSString stringWithFormat:@"%@/%@",kIPServiceAddress,imageNameIn];
//    
//    return urlImageIn;
}

-(NSString *)avatarImageURLForOutgoingMessageAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = (NSDictionary * )[self.messages objectAtIndex:indexPath.row];
    NSString * imageNameOut = [dict objectForKey:@"SENDERIMAGE"];
    
    NSArray * words = [imageNameOut componentsSeparatedByString:@"graph.facebook.com"];
    
    //        NSLog(@"words = %@",words);
    
    if ([words count] < 2) {
        imageNameOut = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,imageNameOut];
    }
    
    return imageNameOut;
    
//    NSString * urlImageOut = [NSString stringWithFormat:@"%@/%@",kIPServiceAddress,imageNameOut];
//    
//    return urlImageOut;
}

#pragma mark - OptionMenuViewDelegate
-(void)OptionMenuViewDidSelectButtonTag:(int)buttontag{
    
    //[messageview.inputToolBarView.textView resignFirstResponder];
    
//    [messageview.inputToolBarView.textView resignFirstResponder];
    
    
    switch (buttontag) {
        case 0://Gallery
        {
            [messageview.inputToolBarView.textView resignFirstResponder];
            
            [AKSVideoAndImagePicker needImage:TRUE needVideo:FALSE FromLibrary:YES from:self didFinished:^(NSString *filePath, NSString *fileType) {
//                NSLog(@"%@",filePath);
//                NSLog(@"%@",fileType);
                
                [messageview.inputToolBarView.textView becomeFirstResponder];
                
                [self sendRequestUploadPhotoFileImage:filePath withTokenID:self.token_id];
                
                
                
            }];
            
            
//            NSArray * mediatype = [[NSArray alloc] initWithObjects:@"public.image", nil];
//            [self selectPictureType:UIImagePickerControllerSourceTypeSavedPhotosAlbum MediaType:mediatype];
            
        }
            break;
        case 1://Camera
        {
            [messageview.inputToolBarView.textView resignFirstResponder];
            
            [AKSVideoAndImagePicker needImage:TRUE needVideo:TRUE FromLibrary:NO from:self didFinished:^(NSString *filePath, NSString *fileType) {
//                NSLog(@"%@",filePath);
//                NSLog(@"%@",fileType);
                [messageview.inputToolBarView.textView becomeFirstResponder];
                
                if ([fileType isEqualToString:@"public.image"]) {
                   [self sendRequestUploadPhotoFileImage:filePath withTokenID:self.token_id];
                }else{
                    [self sendRequestUploadMediaFile:filePath withTokenID:self.token_id];
                }
                
            }];
            
            
//            NSArray * mediatype = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage, nil];
//            [self selectPictureType:UIImagePickerControllerSourceTypeCamera MediaType:mediatype];
        }
            break;
        case 2://VDO
        {

            [messageview.inputToolBarView.textView resignFirstResponder];
            
            [AKSVideoAndImagePicker needImage:FALSE needVideo:TRUE FromLibrary:YES from:self didFinished:^(NSString *filePath, NSString *fileType) {
//                NSLog(@"%@",filePath);
//                NSLog(@"%@",fileType);
                [messageview.inputToolBarView.textView becomeFirstResponder];
                
                [self sendRequestUploadMediaFile:filePath withTokenID:self.token_id];
                
                
            }];
            
//            NSArray * mediatype = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
//            
//            [self selectPictureType:UIImagePickerControllerSourceTypeSavedPhotosAlbum MediaType:mediatype];
            
            /*
            NSURL *url = [NSURL URLWithString:@"http://203.151.162.5/app2/mp4:1f9e5d45ee22f2811b896096a44384f9.mp4/playlist.m3u8"];
            MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlaybackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:mp];
            
            mp.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
            
            [self presentMoviePlayerViewControllerAnimated:mp];
  
            */
        }
            break;
        case 3://Share location
        {
            
            
            [self StartGetLocation];
            
            
        }
            break;
        case 4://Sound
        {
            
            [self recordPressed:nil];
            
//            RecordViewController * recView = [[RecordViewController alloc] initWithNibName:@"RecordViewController_iPhone" bundle:nil];
//            
//            recView.view.opaque = NO;
//            recView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
//            
//            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            
////            [app viewController
//            
//            
//            [app.window addSubview:recView.view];
            
            //[self.view addSubview:recView.view];
            
//            [self presentViewController:recView animated:YES completion:nil];
            
            
            //create popover and put V2 in the popover view
//            UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:recView];
//            //popoverController.delegate = self;  //optional
//            CGSize size = CGSizeMake(325, 75); // size of view in popover…V2
//            popoverController.popoverContentSize = size;
            //[d release];
            
            
            
            
//            [popoverController presentPopoverFromRect:CGRectMake(0, 0, 10, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            
            
            
//            NSString *url = [NSString stringWithFormat :@"http://203.151.162.3/voice/df272e8735cc8378dde025acdbaaa828.wav"];
//            NSURL *fileURL = [NSURL URLWithString:url];
//            
//            MPMoviePlayerController * moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
//            [moviePlayerController.view setFrame:CGRectMake(0, 70, 320, 270)];
//            [self.view addSubview:moviePlayerController.view];
//            moviePlayerController.fullscreen = YES;
//            moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
//            [moviePlayerController play];
            

            
//            NSString *strURlString =@"http://broadcast.infomaniak.net/radionova-high.mp3";
//            NSString *strURlString =@"http://203.151.162.3/voice/df272e8735cc8378dde025acdbaaa828.wav";
//            
//            NSLog(@"%@",strURlString);
//            
//            strURlString =[strURlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//            
//            NSLog(@"img url ==%@",strURlString);
//            
//            NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURlString]];
//            NSError *error;
//            
//            audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
////            audioPlayer.numberOfLoops = 0;
////            audioPlayer.volume = 10.0f;
////            [audioPlayer prepareToPlay];
//            
////            if (audioPlayer == nil)
////                NSLog(@"%@", [error description]);
////            else
//                [audioPlayer play];
   
        }
            break;
        case 5://contact
        {
            NSString * username = [NSString stringWithFormat:@":%@:", [self.recentdatadict objectForKey:@"USERNAME"] ];
            
           

            
            
            NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
            [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
            NSString * dtString = [Dateformats stringFromDate:[NSDate date]];
            
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"7", @"MESSAGETYPE"
                                   ,@"", @"MESSAGECHAT"
                                   ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
                                   ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
                                   ,@"", @"TATTOOCODE"
                                   ,@"", @"TATTOOURL"
                                   ,@"", @"IMAGEURL"
                                   ,@"", @"IMAGETYPE"
                                   ,@"", @"IMAGENAME"
                                   ,@"", @"VIDEOURL"
                                   ,@"", @"VIDEOIMAGE"
                                   ,@"", @"LOCATION_LATITUDE"
                                   ,@"", @"LOCATION_LONGTITUDE"
                                   ,@"", @"LOCATIONDETAIL"
                                   ,username, @"CONTACTNAME"
                                   ,@"", @"CONTACTDETAILS"
                                   ,[self.mydatadict objectForKey:@"UserAvatarPath"], @"SENDERIMAGE"
                                   ,[self.mydatadict objectForKey:@"UserName"], @"SENDERUSERNAME"
                                   ,dtString, @"TIMESTAMP"
                                   ,@"", @"TIMESTAMPMS"
                                   , nil];
            
            [self.messages addObject:dict];
            
            [JSMessageSoundEffect playMessageSentSound];
            
            messageview.numofrow = (int )[self.messages count];
            
            //[self finishSend];
            [messageview finishSend];
            
            
            //[socketIO sendMessage:@"I hear u"];
            [socketIO sendEvent:@"SendMessage" withData:dict];
            
            //end
        }
            break;
        default:
            break;
    }
    
//    NSLog(@"Select Option Button Tag:%d", buttontag);
}


-(void)AKSVideoAndImagePickerDidCancel{
    
    [messageview.inputToolBarView.textView becomeFirstResponder];
}


-(void)moviePlaybackDidFinish:(MPMoviePlayerController *) mp{
    
}

#pragma mark - TattooViewDelegate
-(void)TattooViewSelectAtTattooCode:(NSDictionary *)tattoodict{
//    NSLog(@"Select Tattoo dict:%@",tattoodict);
 /*
    NSString * tattooName = [NSString stringWithFormat:@"%@.png", [tattoodict objectForKey:@"TATTOONAME"] ];
    
    //check tattoo indefaul and save
    UIImage * tattooimage = [UIImage imageNamed:tattooName];
    
    //check savelist
    if (tattooimage == nil) {
        //tattooimage = [self LoadTattooImageFromDict:tattoodict];
        
        NSString * tattoourl = [NSString stringWithFormat:@"%@/assets/image/tattoo/%@",kIPAPIServiceAddress, [tattoodict objectForKey:@"TATTOOURL"] ];
        
        tattooimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tattoourl]]];
        
        //checkurl
        if (tattooimage == nil) {
            
        }else{
            //return tattooimage;
        }
        
    }else{
        
        
    }
    
   */
    
    //default not load image tattoo
  /*
    [self.messages addObject:tattoocode];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((self.messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    messageview.numofrow = [self.messages count];
    
    //[self finishSend];
    [messageview finishSend];
    */
    
    NSString * tattooCode = [NSString stringWithFormat:@":%@:", [tattoodict objectForKey:@"TATTOOCODE"] ];
    NSString * tattoourl = [NSString stringWithFormat:@"%@", [tattoodict objectForKey:@"TATTOOURL"] ];
    
    NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
    [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
    NSString * dtString = [Dateformats stringFromDate:[NSDate date]];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"MESSAGETYPE"
                           ,@"", @"MESSAGECHAT"
                           ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
                           ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
                           ,tattooCode, @"TATTOOCODE"
                           ,tattoourl, @"TATTOOURL"
                           ,@"", @"IMAGEURL"
                           ,@"", @"IMAGETYPE"
                           ,@"", @"IMAGENAME"
                           ,@"", @"VIDEOURL"
                           ,@"", @"VIDEOIMAGE"
                           ,@"", @"LOCATION_LATITUDE"
                           ,@"", @"LOCATION_LONGTITUDE"
                           ,@"", @"LOCATIONDETAIL"
                           ,@"", @"CONTACTNAME"
                           ,@"", @"CONTACTDETAILS"
                           ,[self.mydatadict objectForKey:@"UserAvatarPath"], @"SENDERIMAGE"
                           ,[self.mydatadict objectForKey:@"UserName"], @"SENDERUSERNAME"
                           ,dtString, @"TIMESTAMP"
                           ,@"", @"TIMESTAMPMS"
                           , nil];
    
    
    
    
    
    [self.messages addObject:dict];
    
    
    //[self.timestamps addObject:[NSDate date]];
    
    //    if((self.messages.count - 1) % 2)
    //        [JSMessageSoundEffect playMessageSentSound];
    //    else
    //        [JSMessageSoundEffect playMessageReceivedSound];
    
    [JSMessageSoundEffect playMessageSentSound];
    
    messageview.numofrow = (int )[self.messages count];
    
    //[self finishSend];
    [messageview finishSend];
    
    
    //[socketIO sendMessage:@"I hear u"];
    [socketIO sendEvent:@"SendMessage" withData:dict];
    
    //end tes
    
    
}

-(UIImage *)LoadTattooImageFromDict:(NSDictionary *) dict{
    
    return nil;
}




#pragma Mark - Self Methods
-(void)selectPictureType:(UIImagePickerControllerSourceType) SourceType MediaType:(NSArray *) mediatype{
    controlImagePicker = [[UIImagePickerController alloc] init];
    
    if (SourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [controlImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Camera" message:@"Can't Open Camera" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(SourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum){
//        controlImagePicker.mediaTypes = mediatype;//[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        controlImagePicker.allowsEditing = YES;
        
        //controlImagePicker.delegate = self;

        
    }else{
        [controlImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    controlImagePicker.delegate = self;
    
    controlImagePicker.mediaTypes = mediatype;
    
    
    [self presentViewController:controlImagePicker animated:YES completion:nil];
    
//    [self presentModalViewController:controlImagePicker animated:YES];
    
}



#pragma mark - UIImagePickerControl
-(void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    
    
    //image mediaType:public.image
    
//    NSLog(@"Photo source:%d",picker.sourceType);
    
    //video
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//        NSLog(@"mediaType:%@",mediaType);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        // Handle a movie capture
        if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0)
            == kCFCompareEqualTo) {
            
            NSString *moviePath = [[info objectForKey:
                                    UIImagePickerControllerMediaURL] path];
//            NSLog(@"moviePath:%@",moviePath);
//            NSLog(@"Movie Path:%@",[info objectForKey:
//                                    UIImagePickerControllerMediaURL]);
//            MPMoviePlayerViewController* theMovie =
//            [[MPMoviePlayerViewController alloc] initWithContentURL: [info objectForKey:
//                                                                      UIImagePickerControllerMediaURL]];
//            [self presentMoviePlayerViewControllerAnimated:theMovie];
//            
            // Register for the playback finished notification
//            [[NSNotificationCenter defaultCenter]
//             addObserver: self
//             selector: @selector(myMovieFinishedCallback:)
//             name: MPMoviePlayerPlaybackDidFinishNotification
//             object: theMovie];
            
            
        }else if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeImage, 0)
                  == kCFCompareEqualTo){
            
        }
        
        
    }else{//image
        UIImage * photo = [self scaleAndRotateImage:[info objectForKey: UIImagePickerControllerOriginalImage]];
        //[picker dismissModalViewControllerAnimated:NO];
        [picker dismissViewControllerAnimated:YES completion:nil];
        // Do stuff to image.
        //[self SendImagePacketWithImage:photo];
        
        NSData * data = UIImageJPEGRepresentation(photo, 1.0f);
        
        [self sendRequestUploadPhotoFileImage:data withTokenID:self.token_id];
        
        
    }
    
    

    //call service send image
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //return keyboard
    [messageview.inputToolBarView.textView becomeFirstResponder];
}


-(void)SendImagePacketWithImage:(UIImage * ) image{
    
    
    
//    NSString * username = [NSString stringWithFormat:@":%@:", [self.datadict objectForKey:@"USERNAME"] ];
    
    
    NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
    [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
    NSString * dtString = [Dateformats stringFromDate:[NSDate date]];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"MESSAGETYPE"
                           ,@"", @"MESSAGECHAT"
                           ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
                           ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
                           ,@"", @"TATTOOCODE"
                           ,@"", @"TATTOOURL"
                           ,@"https://www.vdomax.com/photo/bf7ddb404bde1f749046cc2c397f5909", @"IMAGEURL"
                           ,@"image", @"IMAGETYPE"
                           ,@"imagename", @"IMAGENAME"
                           ,@"", @"VIDEOURL"
                           ,@"", @"VIDEOIMAGE"
                           ,@"", @"LOCATION_LATITUDE"
                           ,@"", @"LOCATION_LONGTITUDE"
                           ,@"", @"LOCATIONDETAIL"
                           ,@"", @"CONTACTNAME"
                           ,@"", @"CONTACTDETAILS"
                           ,[self.mydatadict objectForKey:@"UserAvatarPath"], @"SENDERIMAGE"
                           ,[self.mydatadict objectForKey:@"UserName"], @"SENDERUSERNAME"
                           ,dtString, @"TIMESTAMP"
                           ,@"", @"TIMESTAMPMS"
                           , nil];
    
    [self.messages addObject:dict];
    
    [JSMessageSoundEffect playMessageSentSound];
    
    messageview.numofrow = (int )[self.messages count];
    
    //[self finishSend];
    [messageview finishSend];
    
    
    //[socketIO sendMessage:@"I hear u"];
    [socketIO sendEvent:@"SendMessage" withData:dict];
    
    //end
    
}

//for change orientation from camera take a photo
- (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 2448; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
//add
-(UIImage *)ResizeImage:(UIImage *)image NewSize:(CGSize )newsize{
    
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // Create a new image from current context
    UIImage * imageresize = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    return imageresize;
}


-(BOOL)isTatooFromString:(NSString *) messagetext
{
    //if (!([messagetext isKindOfClass:[NSNull class]] || [messagetext isEqualToString:@""]) ) {
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



//add

-(void)updateLastDictForRecentChat:(NSDictionary *) dict{
    
    BOOL founddict = NO;
    int foundIndex = 0;
    
    
    NSMutableArray * datarecent = [[NSMutableArray alloc] init];
    
    NSArray * tmp = (NSArray *)[self LoadDataDictFromPlistFileName:@"RECENTCHATPLIST"];
    for (NSDictionary * dt in tmp) {
        [datarecent addObject:dt];
    }
    
    for (NSDictionary * dt in datarecent) {
        
        int con_id = (int)[[[dt objectForKey:@"LASTMESSAGEDATA"] objectForKey:@"CONVERSATION_ID"] intValue];
        
        if (con_id == self.conversation_id) {
            founddict = YES;
            
            //[datarecent removeObject:dt];
            
            break;
        }
        
        foundIndex ++;
        
    }
    
    if(dict != nil){
        
        if (founddict) {
            [datarecent removeObjectAtIndex:foundIndex];
        }
        
        NSDictionary * dictRecent = [[NSDictionary alloc] initWithObjectsAndKeys:[self.recentdatadict objectForKey:@"FRIENDID"],@"FRIENDID"
                                     ,[self.recentdatadict objectForKey:@"FRIENDNAME"],@"FRIENDNAME"
                                     ,[self.recentdatadict objectForKey:@"FRIENDIMAGE"],@"FRIENDIMAGE"
                                     ,dict,@"LASTMESSAGEDATA"
                                     ,nil];
        
        if([datarecent count]>1){
            [datarecent insertObject:dictRecent atIndex:0];
        }
        else {
            [datarecent addObject:dictRecent];
        }
        
        NSDictionary * Datadict = [[NSDictionary alloc] initWithObjectsAndKeys:datarecent,@"RECENTCHAT", nil];
        
        [self UpdateDataDict:Datadict ToPlistFile:@"RECENTCHATPLIST"];
        
        
    }
    
}

-(NSArray *)LoadDataDictFromPlistFileName:(NSString *) plistfilename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist" ,plistfilename]];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath: plistPath])
//    {
//        BOOL ret = [[NSDictionary dictionary] writeToFile:plistPath atomically:YES];
//        assert(ret); // better work!
//    }
//    
//    
    NSDictionary *openDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if ([openDict count]>0) {
        NSArray * dictArryTmp = [openDict objectForKey:@"RECENTCHAT"];
        return dictArryTmp;
        
    }else{
        return nil;
    }
}

-(void)UpdateDataDict:(NSDictionary *)itemdict ToPlistFile:(NSString *)plistfilename{
    //   NSString* plistPath = [[NSBundle mainBundle] pathForResource:plistfilename ofType:@"plist"];
    //    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist" ,plistfilename]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: plistPath])
    {
        BOOL ret = [[NSDictionary dictionary] writeToFile:plistPath atomically:YES];
        assert(ret); // better work!
    }
    
    //    NSLog(@"Path Save Add:%@",plistPath);
    /*
    NSDictionary *openDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //NSLog(@"openDict%@",openDict);
    //    NSLog(@"dict:%@",itemarray);
    //NSLog(@"openDict:%@",openDict);
    
    NSMutableArray * arrayTemp = [[NSMutableArray alloc]init];
    NSArray * dictArryTmp = nil;
    if (openDict != nil) {
        dictArryTmp = (NSArray *)[openDict objectForKey:@"RECENTCHAT"];
    }
    
    for (NSDictionary * dt in dictArryTmp) {
        [arrayTemp addObject:dt];
    }
    [arrayTemp insertObject:itemdict atIndex:0];
    //[arrayTemp addObject:itemarray];
    
    //assign current profile
    //self.current_IndexProfile = [arrayTemp count]-1;
    */
    //NSDictionary * dictPlist = [[NSDictionary alloc] initWithObjectsAndKeys:arrayTemp, @"RECENTCHAT", nil];
    
    //    NSLog(@"dictPlist:%@",dictPlist);
    
    [itemdict writeToFile:plistPath atomically:YES];
    
    //[dictPlist release];
    
}




# pragma mark -
# pragma mark socket.IO-objc delegate methods

- (void) socketIODidConnect:(SocketIO *)socket
{
//    NSLog(@"socket.io connected.");
    
    NSDictionary * dictJoinRoom = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"CONVERSATION_ID"
                           ,@"user",@"CONVERSATION_TYPE"
                           ,[NSString stringWithFormat:@"%d", self.user_id],@"USERID"
                           ,[NSString stringWithFormat:@"%d", self.friend_id],@"FRIENDID"
                           ,@"",@"LIVE_USER_ID"
                           , nil];

    //[socketIO sendMessage:@"I hear u"];
    [socketIO sendEvent:@"JoinRoom" withData:dictJoinRoom];
    
    
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",packet.args] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
//    NSLog(@"didReceiveEvent()");
//    NSLog(@"packet is:%@", packet.args);
//    NSLog(@"name is:%@", packet.name);
//
//    if ([packet.args count] >0) {
//        NSDictionary * argDict = (NSDictionary *)[packet.args objectAtIndex:0];
//        
//        int arg_userid = [[argDict objectForKey:@"userid_request"] integerValue];
//    }
    
    if([packet.name isEqualToString:@"JoinRoom"]  && !(flagHanshake)){
        
        flagHanshake = YES;
        
        NSArray * mesArr = (NSArray *)[packet args];
        NSDictionary * dict = (NSDictionary *)[mesArr objectAtIndex:0];
        //NSLog(@"dict is:%@", dict);
        
        if ([[dict objectForKey:@"status"] intValue] == 1 && [[dict objectForKey:@"userid_request"] integerValue] == self.user_id) {
            
            self.conversation_id = [[dict objectForKey:@"conversation_id"] intValue];
            
            
//            UIAlertView * alShow = [[UIAlertView alloc] initWithTitle:@"Conversation id" message:[NSString stringWithFormat:@"%d",self.conversation_id] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alShow show];
            
            //call history chat
            //.
            //.
            //.
            
            if (self.conversation_id > 0) {
                
                [self sendRequestLoadChatHistoryConvertsationID:self.conversation_id UserID:self.user_id FriendID:self.friend_id MessagePage:message_page MessageSize:message_pagesize];
            }
            
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't Join Room" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
    }else if([packet.name isEqualToString:@"SendMessage"] && flagHanshake){
        
        
        NSArray * mesArr = (NSArray *)[packet args];
        NSDictionary * dict = (NSDictionary *)[mesArr objectAtIndex:0];
//        NSLog(@"dict mess iss: %@", dict);
        
//        SocketIOCallback cb = ^(id argsData) {
//            NSDictionary *response = argsData;
//            // do something with response
//            NSLog(@"ack arrived: %@", response);
//            
//            // test forced disconnect
//            //[socketIO disconnectForced];
//        };
        // [socketIO sendMessage:@"hello back!" withAcknowledge:cb];
        
        //[socketIO sendMessage:@"I hear u"];
        
        
        //    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"MESSAGETYPE"
        //                           ,text,@"MESSAGECHAT"
        //                           ,@"2",@"SENDERID"
        //                           ,@"name2",@"SENDERUSERNAME"
        //                           , nil];
        
        int senderid = (int )[[dict objectForKey:@"SENDERID"] integerValue]; //not same my self
        if(senderid != self.user_id){
            [self.messages addObject:dict];
            
            
            //[self.timestamps addObject:[NSDate date]];
            
            [JSMessageSoundEffect playMessageReceivedSound];
            
            messageview.numofrow = (int )[self.messages count];
            //[messageview.tableView reloadData];
            
            [messageview finishSend];
        }
        
    }
    
    
    
    
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"onError() %@", error);
}


- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"socket.io disconnected. did error occur? %@", error);
}


-(void)StartGetLocation{
    
    enableMap = YES;
    
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }else{
        [locationManager startUpdatingLocation];
    }
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil && enableMap) {
        cur_longtitude = currentLocation.coordinate.longitude;
        cur_latitude = currentLocation.coordinate.latitude;
        
        [manager stopUpdatingLocation];
        
        enableMap = NO;
        
        // call send share location
        
        [self sendRequestLoadLocationInfoAtLongtitude:cur_longtitude Latitude:cur_latitude];
    }
}



#pragma mark - Service Connection
-(void)sendRequestLoadChatHistoryConvertsationID:(int ) con_id UserID:(int ) userid FriendID:(int ) friendid MessagePage:(int ) msgpage MessageSize:(int) msgsize {
    
    current_connect = CHATHISTORYCONNECT;
    enableCallService = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/chat/?action=chathistory&USERID=%d&FRIENDID=%d&CONVERSATION_ID=%d&MESSAGESIZE=%d&MESSAGEPAGE=%d&sort=1",kIPAPIServiceAddress,userid,friendid,con_id,msgsize,msgpage]];
    
//    NSLog(@"URL is: %@", url);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData startAsynchronous];
    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    
//        //Start Progress
//        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//        [vc.view addSubview:HUD];
//        
//        HUD.delegate = self ;
//        HUD.labelText=@"loading";
//        [HUD show:YES];
    
    
}

-(void)sendRequestLoadLocationInfoAtLongtitude:(double ) long_tude Latitude:(double ) la_tude {
    
    current_connect = GETLOCATIONINFOCONNECT;
    enableCallService = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/chat/?action=location&lat=%f&lon=%f",kIPAPIServiceAddress,la_tude,long_tude]];
    
//    NSLog(@"URL is: %@", url);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData startAsynchronous];
    
    
    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    
    UIViewController * vc = app.window.rootViewController;
    
    //Start Progress
    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    [vc.view addSubview:HUD];
    
    HUD.delegate = self ;
    HUD.labelText=@"loading";
    [HUD show:YES];
    
    //{"status":1,"msg":"Login is successful.","tokenid":"50807c8c09201f207db39d2f04cf526c"}
    
}

-(void)sendRequestUploadPhotoFileImage:(NSString *)path withTokenID:(NSString * ) tokenid {
    
    current_connect = UPLOADPHOTOCONNECT;
    enableCallService = YES;
    
    //https://api.vdomax.com/service/postPhotoChat/mobile
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/postPhotoChat/mobile",kIPAPIServiceAddress]];
    
//    NSLog(@"URL is: %@", url);
//     NSLog(@"path is: %@", path);
    
//    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                           NSUserDomainMask,
//                                                           YES);
//    NSString *path = [[pathArr objectAtIndex:0]
//                      stringByAppendingPathComponent:@"imageTemp.jpg" ];
    
    //NSData * data = UIImagePNGRepresentation(imagefile);
//    [imagedata writeToFile:path atomically:YES];
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData addPostValue:[NSString stringWithFormat:@"%@", tokenid] forKey:@"token"];
    [requestData addFile:path forKey:@"photo"];
    //[requestData addData:imagedata forKey:@"photo"];
    
    [requestData startAsynchronous];
    
    
    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    
    UIViewController * vc = app.window.rootViewController;
    
    //Start Progress
    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    [vc.view addSubview:HUD];
    
    HUD.delegate = self ;
    HUD.labelText=@"sending";
    [HUD show:YES];
    
    //{"status":1,"msg":"Login is successful.","tokenid":"50807c8c09201f207db39d2f04cf526c"}
    
}

-(void)sendRequestUploadMediaFile:(NSString *) path withTokenID:(NSString * ) tokenid {
    
    current_connect = UPLOADMEDIACONNECT;
    enableCallService = YES;
    
    //https://api.vdomax.com/service/postVideoChat/mobile
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/postVideoChat/mobile",kIPAPIServiceAddress]];
//    
//    NSLog(@"URL is: %@", url);
//    NSLog(@"path is: %@", path);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData addPostValue:[NSString stringWithFormat:@"%@", tokenid] forKey:@"token"];
//    [requestData addFile:path forKey:@"movie"];
    
    [requestData setFile:path forKey:@"video"];
    
    [requestData startAsynchronous];
    
    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    
    UIViewController * vc = app.window.rootViewController;
    
    
    //Start Progress
    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    [vc.view addSubview:HUD];
    
    HUD.delegate = self ;
    HUD.labelText=@"sending";
    [HUD show:YES];
    
    //{"status":1,"msg":"Login is successful.","tokenid":"50807c8c09201f207db39d2f04cf526c"}
    
}

-(void)sendRequestUploadSoundFile:(NSString *) path withTokenID:(NSString * ) tokenid {
    
    current_connect = UPLOADSOUNDCONNECT;
    enableCallService = YES;
    
    //https://api.vdomax.com/service/postVoiceChat/mobile
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/postVoiceChat/mobile",kIPAPIServiceAddress]];
    
//    NSLog(@"URL is: %@", url);
//    NSLog(@"path is: %@", path);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData addPostValue:[NSString stringWithFormat:@"%@", tokenid] forKey:@"token"];
    [requestData addFile:path forKey:@"voice"];
    
    [requestData startAsynchronous];
    
    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    
    UIViewController * vc = app.window.rootViewController;
    
    //Start Progress
    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    [vc.view addSubview:HUD];
    
    HUD.delegate = self ;
    HUD.labelText=@"sending";
    [HUD show:YES];
    
    //{"status":1,"msg":"Login is successful.","tokenid":"50807c8c09201f207db39d2f04cf526c"}
    
}

-(void)sendRequestClearBadgeDataWithUserID:(int) usr_id ConversationID:(int) con_id{
    
    current_connect = CLEARBADGE_CHAT_CONNECT;
    enableCallService = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.vdomax.com/noti/?method=readed&user_id=%d&id=%d",usr_id,con_id]];
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"URL Clear" message:[NSString stringWithFormat:@"Clear badge URL: %@",url.absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
//    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData startAsynchronous];
    
    //url	NSURL *	@"http://128.199.254.106/notification/?method=readed&user_id=9&push_id=197"
    
}

#pragma mark - ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
//    NSLog(@"requestFinished : %@", [request responseString]);
    
    if(refreshControl){
        [refreshControl endRefreshing];
    }
    
    //trun off progress
    [HUD hide:YES];
    
    
    enableCallService = NO;
    waitingBack = NO;
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
    //NSArray *jsonObject = (NSArray *)[parser objectWithString:[request responseString]];
    
    //NSLog(@"data: %@",jsonObject);
    
    //int status = [[jsonObject objectForKey:@"status"] intValue];
    
    if(current_connect == CHATHISTORYCONNECT)
    {
        if (![jsonObject isKindOfClass:[NSNull class]]) {//load chat history
            
/*
            //load Image
            NSString * imageNameIn = [jsonObject objectForKey:@"FRIENDIMAGE"];
            NSString * urlImageIn = [NSString stringWithFormat:@"%@/%@",kIPServiceAddress,imageNameIn];
            UIImageView * imgvIncome = [[UIImageView alloc] init];
            if(urlImageIn.length >0)[imgvIncome setImageWithURL:[NSURL URLWithString:urlImageIn] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                incomingImage = [image copy];
            }];
            
            
            NSString * imageNameOut = [jsonObject objectForKey:@"USERIMAGE"];
            NSString * urlImageOut = [NSString stringWithFormat:@"%@/%@",kIPServiceAddress,imageNameOut];
            UIImageView * imgvOut = [[UIImageView alloc] init];
            if(urlImageOut.length >0)[imgvOut setImageWithURL:[NSURL URLWithString:urlImageOut] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                outgoingImage = [image copy];
            }];
*/
            
            NSArray * chatrarray = (NSArray *)[jsonObject objectForKey:@"MESSAGEDATA"];
            
            if ([chatrarray count] > 0) {
                
                
                //[self.messages removeAllObjects];
                //[self.timestamps removeAllObjects];
                
                NSMutableArray * tmp = [[NSMutableArray alloc] initWithArray:self.messages copyItems:YES];
                
//                NSLog(@"tmp : is %@",tmp);
                
                [self.messages removeAllObjects];
                
                //add new message first step
                for (NSDictionary * dt in chatrarray) {
                    
//                    NSLog(@"dict : %@", dt);
                    [self.messages addObject:dt];
                    
                    /*
                    NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
                    
                    [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
                    [Dateformats setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                    NSDate *stmpDate=[Dateformats dateFromString:[dt objectForKey:@"TIMESTAMP"]];
                    //NSLog(@"%@",stmpDate);
                    
                    [self.timestamps addObject:stmpDate];
                     */
                }
                
                
                
                
                //add old message second step
                for (NSDictionary * dt in tmp) {
                    [self.messages addObject:dt];
                }
                
                
                //refresh table
                messageview.numofrow = (int)[self.messages count];
                //[messageview.tableView reloadData];
                
                [[messageview tableView] reloadData];
                
                
                if ([self.messages count] < message_pagesize) {
                    int lastrow = [self.messages count] > 0 ? (int)([self.messages count] - 1) : 0;
                    
                    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:lastrow  inSection:0];
                    
                    CGRect rect = [[messageview tableView] rectForRowAtIndexPath:indexpath];
                    
                    [[messageview tableView] scrollRectToVisible:rect animated:NO];
                }else{
                    int currentrow = [chatrarray count] > 0 ? (int)([chatrarray count] - 1) : 0;
                    
                    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:currentrow  inSection:0];
                    
                    CGRect rect = [[messageview tableView] rectForRowAtIndexPath:indexpath];
                    
                    [[messageview tableView] scrollRectToVisible:rect animated:NO];

                }
                
                //enable load more
                
                //enableLoadMore = YES;
            }else{
                [[messageview tableView] reloadData];
            }
            
            //turn off load more
//            if ([chatrarray count] < message_pagesize) {
//                enableLoadMore = NO;
//                
//                messageview.tableView.tableHeaderView.hidden = YES;
//            }else{
//                enableLoadMore = YES;
//                
//                messageview.tableView.tableHeaderView.hidden = NO;
//            }
            
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Chat Check badge push" message:[NSString stringWithFormat:@"%@",self.myBadgePush] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
            
            //call clear badge if has push
//            if (!([self.myBadgePush isKindOfClass:[NSNull class]] || [self.myBadgePush count] == 0)) {
//                
//               // NSDictionary *params = [self.myBadgePushobjectForKey:@"params"];
//                //NSString *pID = [NSString stringWithFormat:@"%d",[[params objectForKey:@"id"] intValue]];
//                int from_id = [[self.myBadgePush objectForKey:@"from_id"] intValue];
//                //int push_id = [[self.myBadgePush objectForKey:@"push_id"] intValue];
//                int con_id = [[self.myBadgePush objectForKey:@"converesation_id"] intValue];
//                
//                
//                [self sendRequestClearBadgeDataWithUserID:from_id ConversationID:con_id];
//                
//            }
            
            
        }else{
            
//            enableLoadMore = NO;
//            
//            messageview.tableView.tableHeaderView.hidden = YES;
            
            
            //NSString * msg = [jsonObject objectForKey:@"msg"];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:@"not found data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
        
        
        

    }
    else if(current_connect == CLEARBADGE_CHAT_CONNECT){
        //[self.delegate ChatPageViewClearBadgeDict:self.myBadgePush];
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Call clear badge" message:@"success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//
//        if(self.messages != nil)[self.delegate ChatPageViewClosedAndUpdateLastChatDict:[self ChangeFormatRecentChatDict:self.recentdatadict WithChatDict:[self.messages lastObject]]];
//        
//        [self.navigationController popViewControllerAnimated:YES];

    }
    else if(current_connect == GETLOCATIONINFOCONNECT){
        
        //location details
//        NSLog(@"Location : %@", jsonObject);
        
        double Lat = [[jsonObject objectForKey:@"lat"] doubleValue];
        double Long = [[jsonObject objectForKey:@"lon"] doubleValue];
        NSString * LocationName = [jsonObject objectForKey:@"name"];
        
        NSString * username = [NSString stringWithFormat:@":%@:", [self.recentdatadict objectForKey:@"USERNAME"] ];
        
        
        
        
        
        NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
        [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
        NSString * dtString = [Dateformats stringFromDate:[NSDate date]];
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"6", @"MESSAGETYPE"
                               ,@"", @"MESSAGECHAT"
                               ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
                               ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
                               ,@"", @"TATTOOCODE"
                               ,@"", @"TATTOOURL"
                               ,@"", @"IMAGEURL"
                               ,@"", @"IMAGETYPE"
                               ,@"", @"IMAGENAME"
                               ,@"", @"VIDEOURL"
                               ,@"", @"VIDEOIMAGE"
                               ,[NSString stringWithFormat:@"%f",Lat], @"LOCATION_LATITUDE"
                               ,[NSString stringWithFormat:@"%f",Long], @"LOCATION_LONGTITUDE"
                               ,LocationName, @"LOCATIONDETAIL"
                               ,username, @"CONTACTNAME"
                               ,@"", @"CONTACTDETAILS"
                               ,[self.mydatadict objectForKey:@"UserAvatarPath"], @"SENDERIMAGE"
                               ,[self.mydatadict objectForKey:@"UserName"], @"SENDERUSERNAME"
                               ,dtString, @"TIMESTAMP"
                               ,@"", @"TIMESTAMPMS"
                               , nil];
        
        [self.messages addObject:dict];
        
        [JSMessageSoundEffect playMessageSentSound];
        
        messageview.numofrow = (int )[self.messages count];
        
        //[self finishSend];
        [messageview finishSend];
        
        
        //[socketIO sendMessage:@"I hear u"];
        [socketIO sendEvent:@"SendMessage" withData:dict];
        
        //end
        
        
    }
    else if(current_connect == UPLOADPHOTOCONNECT){
        
        int status = (int)[[jsonObject objectForKey:@"status"] integerValue];
        
        if (status == 4001) {//is success
            
            
            NSString * imagename = [jsonObject objectForKey:@"file"];
            
            
            NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
            [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
            NSString * dtString = [Dateformats stringFromDate:[NSDate date]];
            
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"MESSAGETYPE"
                                   ,@"", @"MESSAGECHAT"
                                   ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
                                   ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
                                   ,@"", @"TATTOOCODE"
                                   ,@"", @"TATTOOURL"
                                   ,[NSString stringWithFormat:@"https://www.vdomax.com/photo/%@",imagename], @"IMAGEURL"
                                   ,@"image", @"IMAGETYPE"
                                   ,@"imagename", @"IMAGENAME"
                                   ,@"", @"VIDEOURL"
                                   ,@"", @"VIDEOIMAGE"
                                   ,@"", @"LOCATION_LATITUDE"
                                   ,@"", @"LOCATION_LONGTITUDE"
                                   ,@"", @"LOCATIONDETAIL"
                                   ,@"", @"CONTACTNAME"
                                   ,@"", @"CONTACTDETAILS"
                                   ,[self.mydatadict objectForKey:@"UserAvatarPath"], @"SENDERIMAGE"
                                   ,[self.mydatadict objectForKey:@"UserName"], @"SENDERUSERNAME"
                                   ,dtString, @"TIMESTAMP"
                                   ,@"", @"TIMESTAMPMS"
                                   , nil];
            
            [self.messages addObject:dict];
            
            [JSMessageSoundEffect playMessageSentSound];
            
            messageview.numofrow = (int )[self.messages count];
            
            //[self finishSend];
            [messageview finishSend];
            
            
            //[socketIO sendMessage:@"I hear u"];
            [socketIO sendEvent:@"SendMessage" withData:dict];
            
        }
        
    }
    else if(current_connect == UPLOADSOUNDCONNECT){
        
        int status = (int)[[jsonObject objectForKey:@"status"] integerValue];
        
        if (status == 4001) {//is success
            
            
            NSString * soundname = [jsonObject objectForKey:@"file"];
            
            
            NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
            [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
            NSString * dtString = [Dateformats stringFromDate:[NSDate date]];
            
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"MESSAGETYPE"
                                   ,@"", @"MESSAGECHAT"
                                   ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
                                   ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
                                   ,@"", @"TATTOOCODE"
                                   ,@"", @"TATTOOURL"
                                   ,[NSString stringWithFormat:@"%@",soundname], @"IMAGEURL"
                                   ,@"other", @"IMAGETYPE"
                                   ,@"", @"IMAGENAME"
                                   ,@"", @"VIDEOURL"
                                   ,@"", @"VIDEOIMAGE"
                                   ,@"", @"LOCATION_LATITUDE"
                                   ,@"", @"LOCATION_LONGTITUDE"
                                   ,@"", @"LOCATIONDETAIL"
                                   ,@"", @"CONTACTNAME"
                                   ,@"", @"CONTACTDETAILS"
                                   ,[self.mydatadict objectForKey:@"UserAvatarPath"], @"SENDERIMAGE"
                                   ,[self.mydatadict objectForKey:@"UserName"], @"SENDERUSERNAME"
                                   ,dtString, @"TIMESTAMP"
                                   ,@"", @"TIMESTAMPMS"
                                   , nil];
            
            [self.messages addObject:dict];
            
            [JSMessageSoundEffect playMessageSentSound];
            
            messageview.numofrow = (int )[self.messages count];
            
            //[self finishSend];
            [messageview finishSend];
            
            
            //[socketIO sendMessage:@"I hear u"];
            [socketIO sendEvent:@"SendMessage" withData:dict];
            
        }

        
        
    }
    else if(current_connect == UPLOADMEDIACONNECT){
        
        int status = (int)[[jsonObject objectForKey:@"status"] integerValue];
        
        if (status == 4001) {//is success
            
            
            NSString * medianame = [jsonObject objectForKey:@"teststream"];
            NSString * mediathums = [jsonObject objectForKey:@"thumbnail"];
            
            
            NSDateFormatter * Dateformats= [[NSDateFormatter alloc] init];
            [Dateformats setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //ex "2014-03-24 19:26:02"
            NSString * dtString = [Dateformats stringFromDate:[NSDate date]];
            
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"MESSAGETYPE"
                                   ,@"", @"MESSAGECHAT"
                                   ,[NSString stringWithFormat:@"%d",self.conversation_id], @"CONVERSATION_ID"
                                   ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID"
                                   ,@"", @"TATTOOCODE"
                                   ,@"", @"TATTOOURL"
                                   ,@"", @"IMAGEURL"
                                   ,@"", @"IMAGETYPE"
                                   ,@"", @"IMAGENAME"
                                   ,[NSString stringWithFormat:@"%@",medianame], @"VIDEOURL"
                                   ,[NSString stringWithFormat:@"https://www.vdomax.com/photo/%@",mediathums], @"VIDEOIMAGE"
                                   ,@"", @"LOCATION_LATITUDE"
                                   ,@"", @"LOCATION_LONGTITUDE"
                                   ,@"", @"LOCATIONDETAIL"
                                   ,@"", @"CONTACTNAME"
                                   ,@"", @"CONTACTDETAILS"
                                   ,[self.mydatadict objectForKey:@"UserAvatarPath"], @"SENDERIMAGE"
                                   ,[self.mydatadict objectForKey:@"UserName"], @"SENDERUSERNAME"
                                   ,dtString, @"TIMESTAMP"
                                   ,@"", @"TIMESTAMPMS"
                                   , nil];
            
            [self.messages addObject:dict];
            
            [JSMessageSoundEffect playMessageSentSound];
            
            messageview.numofrow = (int )[self.messages count];
            
            //[self finishSend];
            [messageview finishSend];
            
            
            //[socketIO sendMessage:@"I hear u"];
            [socketIO sendEvent:@"SendMessage" withData:dict];
            
        }
        
    }
    

    //[self hideFooter];
    
//    if(refreshControl){
//        [refreshControl endRefreshing];
//    }
//    
//    //trun off progress
//    [HUD hide:YES];
    
    
}

-(void)requestFailed:(ASIHTTPRequest *)request{
//    NSLog(@"requestFailed : %@", [request responseString]);
//    NSLog(@"requestFailed desc : %@", [[request error] description]);
    
    //[self hideFooter];
    enableCallService = NO;
    waitingBack = NO;
    
    if(refreshControl){
        [refreshControl endRefreshing];
    }
    //trun off progress
    [HUD hide:YES];
    
    //[soundPlay stop];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check your internet connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}




- (IBAction)btActFreecall:(id)sender {
}

- (IBAction)btActBlock:(id)sender {
}

- (IBAction)btActSetting:(id)sender {
}
@end