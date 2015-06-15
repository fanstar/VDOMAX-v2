//
//  ViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/22/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "MainChatViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"

#define pagesizevalue 20

@interface MainChatViewController ()

@end

@implementation MainChatViewController
@synthesize myDataDict;
@synthesize myBadgeDataArr;
@synthesize badgebubble;
@synthesize myBadgeDict;

@synthesize enablenoti;
@synthesize pushfriendid;
@synthesize myTokenid;
//@synthesize countBadgeNotRead;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //fix button fill frame
    
    self.btFriends.contentMode = UIViewContentModeScaleAspectFit;
    self.btChats.contentMode = UIViewContentModeScaleAspectFit;
    
    DataSearchArray = [[NSMutableArray alloc] init];
    DataAllArray = [[NSMutableArray alloc] init];
    
    friendlist_page = 0;
    friendlist_page_size = pagesizevalue;
    
//    
    self.tbFriendList.tableFooterView = nil;
//    self.tbFriendList.tableFooterView.hidden = YES;
    
    //Custome Load More
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tbFriendList];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    //add june
    revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    //end june
    
//    NSLog(@"my datadict:%@",self.myDataDict);
    
//    myDataDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"9",@"USERID",
//                  @"asdf9",@"USERTOKEN",
//                  @"9a9603ae75c066b85ca087660ce247a3",@"USERIMAGE",
//                  @"iamnotkorr",@"USERNAME",
//                  @"token mobile",@"USERTOKENMOBILE",
//                  @"noe status",@"STATUS",
//                  nil];
//    
//    UIAlertView * alert2 = [[UIAlertView alloc] initWithTitle:@"user data " message:[NSString stringWithFormat:@"userdata : %@",myDataDict ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert2 show];
    
    my_user_id = (int)[[myDataDict objectForKey:@"UserID"] integerValue];
    my_token_id = self.myTokenid;//[myDataDict objectForKey:@"UserTokenid"];//@"39b7cf59729f08c7a56b9ab3d2bc26d9";
    my_username = [myDataDict objectForKey:@"UserName"];
    my_imagename = [myDataDict objectForKey:@"UserAvatarPath"];
    my_tokenmobile = @"";//[myDataDict objectForKey:@"USERTOKENMOBILE"];
    my_status = @"";//[myDataDict objectForKey:@"STATUS"];
    
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"myBadgeDataArr" message:[NSString stringWithFormat:@"%@",myBadgeDataArr] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    ///show bade or hide
    if ([self.myBadgeDataArr count] > 0) {
        
        int totalbadge=0;
        
        for (NSDictionary * dt in self.myBadgeDataArr) {
            
            int count = [[dt objectForKey:@"badge"] intValue];
            
            if (count > 0) {
                totalbadge += count;
            }
            
        }//for
        
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"totalbadge found" message:[NSString stringWithFormat:@"%d",totalbadge] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];

        
        if (totalbadge >0 ) {
            [self ShowNumOfChat:totalbadge];
        }else{
            [self HideNumOfChat];
        }
        
        //not request badge service
        firstLoad = YES;
        
    }else{
        [self HideNumOfChat];
    }
    //end ///show bade or hide
    
    
    
//    for (int i = 0; i<20; i++) {
//        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"yut_%d",i],@"USERNAME",
//                               @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"USERIMAGE",
//                               @"my status",@"STATUS",
//                               nil];
//        
//        [DataAllArray addObject:dict];
//    }
    
    
    [self customNavBar];
    
    
    //remove search back ground
    for (UIView * v in self.searchBarDisplay.subviews) {
        
        if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            //[v removeFromSuperview];
            v.alpha = 0.0f;
        }
        
        if ([v isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            //[v removeFromSuperview];
            UITextField * txtfield = (UITextField *) v;
            txtfield.background = nil;
            
        }
    }
    
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"enablenoti " message:[NSString stringWithFormat:@"enablenoti: %d",enablenoti ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
//[self sendRequestGetInfoUserID:49 withToken:my_token_id];
    
    if (enablenoti) {
        
        [self sendRequestGetInfoUserID:self.pushfriendid withToken:my_token_id];
    }else{
        [self sendRequestFriendsFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page_size Page:friendlist_page];
    }
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}


-(void)customNavBar{
    
    
    /*
    //UIImage * image = [UIImage imageNamed:@"chat_blue_nav_bar.png"];
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) //iOS >=5.0
    {
        //[[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        //[[UINavigationBar appearance] setTintColor:BLUE_COLOR];
        
    }
    else
    {
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [[UINavigationBar appearance] setTintColor:BLUE_COLOR];
       // [self.navigationController.navigationBar addSubview:imageView];
        

    }
     
     */
    
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = BLUE_COLOR;
        self.navigationController.navigationBar.translucent = NO;
    }else{
        self.navigationController.navigationBar.tintColor = BLUE_COLOR;
    }
    
    //self.navigationController.navigationBarHidden = NO;
    
    
    
    UIButton *lButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setFrame:CGRectMake(0,0,28,23)];
    lButton.showsTouchWhenHighlighted = YES;
    [lButton setBackgroundImage:[UIImage imageNamed:@"menu_nav_bar_button.png"] forState:UIControlStateNormal];
//    [lButton addTarget:self action:@selector(didSeleMenu) forControlEvents:UIControlEventTouchUpInside];
    [lButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    lButton.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem * leftbutton = [[UIBarButtonItem alloc] initWithCustomView:lButton];
    
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    self.navigationItem.title = @"Friends";
    
    
    self.segmentFilter.tintColor = BLUE_COLOR;
}

-(void)didSeleMenu{
    
}

#pragma mark - dropViewDidBeginRefreshing

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshContr
{
    if (enableCallService)return;
    
    
    //if (enableLoadMore) {
    //    enableLoadMore = NO;//reject twice press button
        
        friendlist_page = 0;
    currentpage_previouse = 0;
        
        //[self sendRequestFriendListFromMyId:my_token_id ActionType:@"everyone" Pagesize:friendlist_page_size Page:friendlist_page];
        
        //[refreshControl beginRefreshing];
    
        switch (keepState) {
            case FRIENDS_CONNECT://Friends
            {
//                [DataAllArray removeAllObjects];
                [self sendRequestFriendsFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page_size Page:friendlist_page];
            }
                break;
            case FOLLOWER_CONNECT://follower
            {
//                [DataAllArray removeAllObjects];
                [self sendRequestFollowerFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page_size Page:friendlist_page];
                
            }
                break;
            case FOLLOWING_CONNECT://Following
            {
//                [DataAllArray removeAllObjects];
                [self sendRequestFollowingFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page_size Page:friendlist_page];
                
            }
                break;
            case PEOPLE_CONNECT://People
            {
//                [DataAllArray removeAllObjects];
                [self sendRequestPeopleFromTokenID:my_token_id Pagesize:friendlist_page_size Page:friendlist_page];
                
            }
                break;
            case SEARCH_PEOPLE_CONNECT:
            {
//                [DataSearchArray removeAllObjects];
                [self sendRequestSearchWord:self.searchBarDisplay.text MyID:my_user_id MyToken:my_token_id FriendType:0 SizePage:friendlist_page_size Page:friendlist_page];
            }
                break;
            case SEARCH_FOLLOWING_CONNECT:
            {
//                [DataSearchArray removeAllObjects];
                [self sendRequestSearchWord:self.searchBarDisplay.text MyID:my_user_id MyToken:my_token_id FriendType:1 SizePage:friendlist_page_size Page:friendlist_page];
            }
                break;
            case SEARCH_FOLLOWER_CONNECT:
            {
//                [DataSearchArray removeAllObjects];
                [self sendRequestSearchWord:self.searchBarDisplay.text MyID:my_user_id MyToken:my_token_id FriendType:2 SizePage:friendlist_page_size Page:friendlist_page];
            }
                break;
            case SEARCH_FRIENDS_CONNECT:
            {
//                [DataSearchArray removeAllObjects];
                [self sendRequestSearchWord:self.searchBarDisplay.text MyID:my_user_id MyToken:my_token_id FriendType:3 SizePage:friendlist_page_size Page:friendlist_page];
            }
                break;
                
            default:
                break;
        }
        
        
        
   // }
    
}

- (void)LoadMoreRequest
{
    //if (enableLoadMore) {
    //    enableLoadMore = NO;//reject twice press button
    
    friendlist_page = friendlist_page+1;
    currentpage_previouse = friendlist_page;
    
    //[self sendRequestFriendListFromMyId:my_token_id ActionType:@"everyone" Pagesize:friendlist_page_size Page:friendlist_page];
    
    //[refreshControl beginRefreshing];
    
    switch (keepState) {
        case FRIENDS_CONNECT://Friends
        {
            [self sendRequestFriendsFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page Page:friendlist_page_size];
        }
            break;
        case FOLLOWER_CONNECT://follower
        {
            [self sendRequestFollowerFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page Page:friendlist_page_size];
            
        }
            break;
        case FOLLOWING_CONNECT://Following
        {
            [self sendRequestFollowingFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page Page:friendlist_page_size];
            
        }
            break;
        case PEOPLE_CONNECT://People
        {
            [self sendRequestPeopleFromTokenID:my_token_id Pagesize:friendlist_page_size Page:friendlist_page];
            
        }
            break;
        case SEARCH_PEOPLE_CONNECT:
        {
            [self sendRequestSearchWord:self.searchBarDisplay.text MyID:my_user_id MyToken:my_token_id FriendType:0 SizePage:friendlist_page_size Page:friendlist_page];
        }
            break;
        case SEARCH_FOLLOWING_CONNECT:
        {
            [self sendRequestSearchWord:self.searchBarDisplay.text MyID:my_user_id MyToken:my_token_id FriendType:1 SizePage:friendlist_page_size Page:friendlist_page];
        }
            break;
        case SEARCH_FOLLOWER_CONNECT:
        {
            [self sendRequestSearchWord:self.searchBarDisplay.text MyID:my_user_id MyToken:my_token_id FriendType:2 SizePage:friendlist_page_size Page:friendlist_page];
        }
            break;
        case SEARCH_FRIENDS_CONNECT:
        {
            [self sendRequestSearchWord:self.searchBarDisplay.text MyID:my_user_id MyToken:my_token_id FriendType:3 SizePage:friendlist_page_size Page:friendlist_page];
        }
            break;
        default:
            break;
    }
    
    
    
    // }
    
}


-(void)customNavBarForChat{
    
    UIButton *lButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setFrame:CGRectMake(0,0,28,23)];
    lButton.showsTouchWhenHighlighted = YES;
    [lButton setBackgroundImage:[UIImage imageNamed:@"menu_nav_bar_button.png"] forState:UIControlStateNormal];
    //[lButton addTarget:self action:@selector(EditChat) forControlEvents:UIControlEventTouchUpInside];
    [lButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    lButton.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem * leftbutton = [[UIBarButtonItem alloc] initWithCustomView:lButton];
    
//    UIBarButtonItem * rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(EditChat)];
    
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    self.navigationItem.title = @"Recent Chat";
    
}

-(void)EditChat{
    
}

-(void)customNavBarForTimeLine{
    
//    UIBarButtonItem * rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(PostNewTimeline)];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.title = @"Timeline";
    
}

-(void)PostNewTimeline{
    WritePostViewController * writevc =[[WritePostViewController alloc] initWithNibName:@"WritePostViewController_iPhone5" bundle:nil];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:writevc];
    
    [self presentViewController:nav animated:YES completion:nil];
}


-(void)customNavBarForSetting{
    
//    UIBarButtonItem * rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(SettingDone)];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.title = @"Setting";
    
}

-(void)SettingDone{
    
}

-(void)ShowNumOfChat:(int) numofchat{
//    self.lbNumOfChat.text = [NSString stringWithFormat:@"%d",numofchat];
//    self.lbNumOfChat.hidden = NO;
//    self.imgBGNumOfChat.hidden = NO;
    
    if (badgebubble == nil) {
        badgebubble = [[JSBadgeView alloc] initWithParentView:self.btChats alignment:JSBadgeViewAlignmentTopRight];
        
        [badgebubble setBadgeTextFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        badgebubble.badgePositionAdjustment = CGPointMake(-20, 10);

    }
    
    if (numofchat <=0) {
        [badgebubble setBadgeText:@""];
    }else{
        [badgebubble setBadgeText:[NSString stringWithFormat:@"%d",numofchat]];
    }
}


-(void)HideNumOfChat{
//    self.lbNumOfChat.hidden = YES;
//    self.imgBGNumOfChat.hidden = YES;
    [self ShowNumOfChat:0];
}


- (IBAction)btActFriends:(id)sender {
    [self ControlOpenPageByButtonTag:(int)[sender tag]];
}

- (IBAction)btActChats:(id)sender {
    //clear dictSelect Auto
    dictSelected = nil;
    
    
    [self ControlOpenPageByButtonTag:(int)[sender tag]];
}

- (IBAction)btActTimeline:(id)sender {
    [self ControlOpenPageByButtonTag:(int)[sender tag]];
}

- (IBAction)btActSetting:(id)sender {
    [self ControlOpenPageByButtonTag:(int)[sender tag]];
}

- (IBAction)btActSegmentFilter:(id)sender {
    
    
    friendlist_page = 0;
    friendlist_page_size = pagesizevalue;
    //clear data table
    [DataAllArray removeAllObjects];
    
    [self.tbFriendList reloadData];
    
    UISegmentedControl * seg = (UISegmentedControl *) sender;
    
    switch (seg.selectedSegmentIndex) {
        case 0://Friends
        {
            [self sendRequestFriendsFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page_size Page:friendlist_page];
        }
            break;
        case 1://follower
        {
            [self sendRequestFollowerFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page_size Page:friendlist_page];

        }
            break;
        case 2://Following
        {
            [self sendRequestFollowingFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page_size Page:friendlist_page];

        }
            break;
        case 3://People
        {
            [self sendRequestPeopleFromTokenID:my_token_id Pagesize:friendlist_page_size Page:friendlist_page];

        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)btActLoadmore:(id)sender {
    
    if (enableLoadMore) {
        enableLoadMore = NO;//reject twice press button
        
        friendlist_page = friendlist_page+1;
        
        //[self sendRequestFriendListFromMyId:my_token_id ActionType:@"everyone" Pagesize:friendlist_page_size Page:friendlist_page];
        
        
        switch (keepState) {
            case FRIENDS_CONNECT://Friends
            {
                [self sendRequestFriendsFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page Page:friendlist_page_size];
            }
                break;
            case FOLLOWER_CONNECT://follower
            {
                [self sendRequestFollowerFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page Page:friendlist_page_size];
                
            }
                break;
            case FOLLOWING_CONNECT://Following
            {
                [self sendRequestFollowingFromMyTokenID:my_token_id UserID:my_user_id Pagesize:friendlist_page Page:friendlist_page_size];
                
            }
                break;
            case PEOPLE_CONNECT://People
            {
                [self sendRequestPeopleFromTokenID:my_token_id Pagesize:friendlist_page_size Page:friendlist_page];
                
            }
                break;
                
            default:
                break;
        }

        
        
    }
}


-(void)ControlOpenPageByButtonTag:(int) buttontag{
    
    [self SetDefaultImageButton];
    
    switch (buttontag){
        case 0:{//friends
            if (chatlistview != nil) {
                chatlistview.view.hidden = YES;
            }
            
            if (timelineview != nil) {
                timelineview.view.hidden = YES;
            }
            
//            if (settingview != nil) {
//                settingview.view.hidden = YES;
//            }
            [self customNavBar];
            
            [self.btFriends setBackgroundImage:[UIImage imageNamed:@"friend_white_icon1.png"] forState:UIControlStateNormal];
            
        }break;
        case 1:{//chat
            
            if (timelineview != nil) {
                timelineview.view.hidden = YES;
            }
            
//            if (settingview != nil) {
//                settingview.view.hidden = YES;
//            }
            
            if (chatlistview == nil) {
                
                //assign data dict
                
//                NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"USERID"
//                                       ,@"1",@"FRIENDID"
//                                       ,@"1ce50a48c160202e70c4c3833d599494",@"USERTOKEN"
//                                       , nil];
                
                
                
                
                
                
                NSString * nib_File = @"ChatViewController_iPhone";
                
                if (IS_DEVICE_MODEL_5) {
                    nib_File = @"ChatViewController_iPhone5";
                }
                
                
                
                chatlistview = [[ChatViewController alloc] initWithNibName:nib_File bundle:nil];
                chatlistview.delegate = self;
                chatlistview.user_id = my_user_id;
                chatlistview.token_id = my_token_id;
                chatlistview.mydatadict = [myDataDict copy];
                chatlistview.dataBageArr = [self.myBadgeDataArr copy];
                
                //chatlistview.datadict = dict;
                
                [self.view addSubview:chatlistview.view];
                
//                if (dictSelected != nil) {
//                    
//                    NSLog(@"dictSelected: %@",dictSelected);
//                    
//                    chatlistview.datadict = dictSelected;
//                    
//                    [chatlistview SelectFirstRecord];
//                }
                
                
                
            }
            
            
            else{
                //chatlistview.view.hidden = NO;
                chatlistview.view.hidden = NO;
                
//                if (dictSelected != nil) {
//                    
//                    if (chatlistview != nil) {
//                        [chatlistview.view removeFromSuperview];
//                        chatlistview = nil;
//                    }
//                    
//                    
//                    //assign data dict
//                    
////                    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"USERID"
////                                           ,@"1",@"FRIENDID"
////                                           ,@"1ce50a48c160202e70c4c3833d599494",@"USERTOKEN"
////                                           , nil];
//                    
//                    
//                    NSString * nib_File = @"ChatViewController_iPhone";
//                    
//                    if (IS_DEVICE_MODEL_5) {
//                        nib_File = @"ChatViewController_iPhone5";
//                    }
//                    
////                    
//                    chatlistview = [[ChatViewController alloc] initWithNibName:nib_File bundle:nil];
//                    chatlistview.delegate = self;
//                    chatlistview.user_id = my_user_id;
//                    chatlistview.token_id = my_token_id;
//                    chatlistview.mydatadict = [myDataDict copy];
//                    //chatlistview.datadict = dict;
//                     chatlistview.dataBageArr = [self.myBadgeDataArr copy];
//                    
//                    [self.view addSubview:chatlistview.view];
//                    
//                    NSLog(@"dictSelected: %@",dictSelected);
//                    
//                    chatlistview.datadict = dictSelected;
//                    
//                   
//                    
//                    [chatlistview SelectFirstRecord];
//                }else{// dictSelect = nil
//                    
//                    
//                    chatlistview.view.hidden = NO;
//                    
//                }
                
                
            }

            [self customNavBarForChat];
            
            [self.btChats setBackgroundImage:[UIImage imageNamed:@"chat_white_icon1.png"] forState:UIControlStateNormal];
        }break;
        case 2:{//time line
            
            if (chatlistview != nil) {
                chatlistview.view.hidden = YES;
            }

//            if (settingview != nil) {
//                settingview.view.hidden = YES;
//            }
            
            if (timelineview == nil) {
                timelineview = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController_iPhone5" bundle:nil];
                timelineview.delegate = self;
                
                [self.view addSubview:timelineview.view];
                
            }else{
                timelineview.view.hidden = NO;
            }
            
            [self customNavBarForTimeLine];
            
            [self.btTimeline setBackgroundImage:[UIImage imageNamed:@"timeline_white_icon.png"] forState:UIControlStateNormal];
        }break;
        case 3:{//setting
            
            if (chatlistview != nil) {
                chatlistview.view.hidden = YES;
            }
            
            if (timelineview != nil) {
                timelineview.view.hidden = YES;
            }
 /*
            if (settingview == nil) {
                
                NSString * nib_File = @"SettingViewController_iPhone";
                
                if (IS_DEVICE_MODEL_5) {
                    nib_File = @"SettingViewController_iPhone5";
                }
                
                settingview = [[SettingViewController alloc] initWithNibName:nib_File bundle:nil];
                settingview.delegate = self;
                
                [self.view addSubview:settingview.view];
                
            }else{
                settingview.view.hidden = NO;
            }
*/
            [self customNavBarForSetting];
            
            [self.btSetting setBackgroundImage:[UIImage imageNamed:@"setting_white_icon.png"] forState:UIControlStateNormal];
            
        }break;
    }
}

-(void)SetDefaultImageButton{
    
    [self.btFriends setBackgroundImage:[UIImage imageNamed:@"friends_icon1.png"] forState:UIControlStateNormal];
    [self.btChats setBackgroundImage:[UIImage imageNamed:@"chat_icon1.png"] forState:UIControlStateNormal];
    [self.btTimeline setBackgroundImage:[UIImage imageNamed:@"timeline_icon.png"] forState:UIControlStateNormal];
    [self.btSetting setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [DataSearchArray count];
    }
    else {
        return [DataAllArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendListCell";
    FriendListCell *cell = (FriendListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSString *_nibFileCell = @"FriendListCell_iPhone";
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:_nibFileCell owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        
    }
    
    /*
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString * urlString = [[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"UserAvatarPathSmall"];
        [cell.imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kIPServiceAddress,urlString]] placeholderImage:[UIImage imageNamed:@""]];
        NSString * firstname = [[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"UserFirstName"];
        NSString * lastname = [[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"UserLastName"];
        cell.lbName.text = [NSString stringWithFormat:@"%@ %@",firstname,lastname];
        //cell.lbStatus.text = [[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"STATUS"];
    }
    else {
        NSString * urlString = [[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"UserAvatarPathSmall"];
        [cell.imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kIPServiceAddress,urlString]] placeholderImage:[UIImage imageNamed:@""]];
        NSString * firstname = [[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"UserFirstName"];
        NSString * lastname = [[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"UserLastName"];
        cell.lbName.text = [NSString stringWithFormat:@"%@ %@",firstname,lastname];
        //cell.lbStatus.text = [[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"STATUS"];
    }
    */
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString * urlString = [[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"UserAvatarPath"];
        
        if(![urlString isKindOfClass:[NSNull class]]){
            NSArray * words = [urlString componentsSeparatedByString:@"graph.facebook.com"];
            
            //        NSLog(@"words = %@",words);
            
            if ([words count] < 2) {
                urlString = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,urlString];
            }
            
            
            [cell.imgProfile setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
            
            
            //cell.lbStatus.text = [[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"STATUS"];
        }
        
        NSString * username = [[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"UserName"];
        cell.lbName.text = [NSString stringWithFormat:@"%@",username];
        
    }
    else {
        NSString * urlString = [[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"UserAvatarPath"];
        
        if(![urlString isKindOfClass:[NSNull class]]) {
            NSArray * words = [urlString componentsSeparatedByString:@"graph.facebook.com"];
            
            //        NSLog(@"words = %@",words);
            
            if ([words count] < 2) {
                urlString = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,urlString];
            }
            
            [cell.imgProfile setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
            
        }
        
        NSString * username = [[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"UserName"];
        cell.lbName.text = [NSString stringWithFormat:@"%@",username];
        //cell.lbStatus.text = [[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"STATUS"];
        
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    //assign dict for select chat page auto
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        //mange current Internet connect
        switch (keepState) {
            case SEARCH_PEOPLE_CONNECT:
                keepState = PEOPLE_CONNECT;
                friendlist_page = currentpage_previouse;
                break;
            case SEARCH_FOLLOWER_CONNECT:
                keepState = FOLLOWER_CONNECT;
                friendlist_page = currentpage_previouse;
                break;
            case SEARCH_FOLLOWING_CONNECT:
                keepState = FOLLOWING_CONNECT;
                friendlist_page = currentpage_previouse;
                break;
            case SEARCH_FRIENDS_CONNECT:
                keepState = FRIENDS_CONNECT;
                friendlist_page = currentpage_previouse;
                break;
                
            default:
                break;
        }
        //end manage
        
        dictSelected = [[DataSearchArray objectAtIndex:indexPath.row] copy];
        
        self.searchDisplayController.active = NO;
    }
    else {
        dictSelected = [[DataAllArray objectAtIndex:indexPath.row] copy];
    }
    
    //control open page
    ///[self ControlOpenPageByButtonTag:1];
    
    [self OpenChatViewWithFriendDict:[self ChangeFormatRecentChatWithFrienDic:dictSelected]];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([DataAllArray count] >= friendlist_page_size && indexPath.row==([DataAllArray count]-1)) {
//        NSLog(@" Display last row : %d ",indexPath.row);
        [self showFooter];
    }
}

-(void)showFooter
{
    [self.activityLoadMore startAnimating];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.tbFriendList.tableFooterView = self.footerView;
                     }
                     completion:^(BOOL finished){
                         
                         [self LoadMoreRequest];
                         
                     }];
    
}

-(void)hideFooter
{
    [self.activityLoadMore stopAnimating];
    [UIView animateWithDuration:0.7 animations:^{
        self.tbFriendList.tableFooterView = nil;
    }];
}



-(void)OpenChatViewWithFriendDict:(NSDictionary * ) dict{
    
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"OpenChatViewWithFriendDict" message:[NSString stringWithFormat:@"dict :%@",dict] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    NSString * nib_File = @"ChatPageViewController_iPhone";
    
    if (IS_DEVICE_MODEL_5) {
        nib_File = @"ChatPageViewController_iPhone5";
    }
    
    ChatPageViewController * chatpage = [[ChatPageViewController alloc] initWithNibName:nib_File bundle:nil];
    chatpage.delegate = self;
    chatpage.user_id = my_user_id;
    chatpage.token_id = my_token_id;
    chatpage.recentdatadict = dict;
    chatpage.mydatadict = myDataDict;
    chatpage.myBadgePush = self.myBadgeDict;
    
    
    //chatpage.myBadgePush = self.myBadgeDataArr
    
//    NSLog(@"dict Select is; %@",dict);
//    NSLog(@"my data dict is; %@",myDataDict);
    
    //[self.navigationController presentViewController:chatview animated:YES completion:nil];
    
    //call clear badge
//    int friendid = [[[[dict objectForKey:@"FRIENDID"]objectForKey:@"USERFRIENDPROFILE" ] objectForKey:@"DATARECENTCHAT"] intValue];
//    
//    [self clearBadgeWithFriendID:friendid];
    
    [self.navigationController pushViewController:chatpage animated:YES];
    
}

-(NSDictionary *)ChangeFormatRecentChatWithFrienDic:(NSDictionary *) frienddict{
    
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
    
//    NSLog(@"frienddict: %@",frienddict);
    
    /*
     "UserID": "4",
     "UserName": "hatecandid",
     "UserFirstName": "Hate",
     "UserLastName": "Candid",
     "UserAvatarPath": "anonymous",
     "UserSex": "M",
     "UserPosts": "9",
     "UserFollowers": "0",
     "Live": "0"
     */
    
    NSDictionary * Myprofiledict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",my_user_id],@"USERID"
                                    ,my_username,@"USERNAME"
                                    ,my_imagename,@"USERIMAGE"
                                    ,my_token_id,@"USERTOKEN"
                                    ,my_tokenmobile,@"USERTOKENMOBILE"
                                    ,my_status,@"STATUS"
                                    , nil];
    
    NSDictionary * Friendprofiledict = [[NSDictionary alloc] initWithObjectsAndKeys:[frienddict objectForKey:@"UserID"],@"FRIENDID"
                                    ,[frienddict objectForKey:@"UserName"],@"FRIENDNAME"
                                    ,[frienddict objectForKey:@"UserAvatarPath"],@"FRIENDIMAGE"
                                    ,@"",@"USERTOKEN"
                                    ,@"",@"USERTOKENMOBILE"
                                    ,@"",@"STATUS"
                                    , nil];
    
    NSDictionary * chatdict = [[NSDictionary alloc] initWithObjectsAndKeys:Myprofiledict,@"MYPROFILE"
                                    ,Friendprofiledict,@"USERFRIENDPROFILE"
                                    ,@"",@"LASTMESSAGE"
                                    , nil];
    
    NSDictionary * recentdict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"CID"
                               ,chatdict,@"DATARECENTCHAT"
                                 , nil];
    
    
    return recentdict;

}
/*
#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [DataSearchArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.UserName contains[c] %@",searchText];
    DataSearchArray = [NSMutableArray arrayWithArray:[DataAllArray filteredArrayUsingPredicate:predicate]];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}
*/

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    //mange current Internet connect
    switch (keepState) {
        case SEARCH_PEOPLE_CONNECT:
            keepState = PEOPLE_CONNECT;
            friendlist_page = currentpage_previouse;
            break;
        case SEARCH_FOLLOWER_CONNECT:
            keepState = FOLLOWER_CONNECT;
            friendlist_page = currentpage_previouse;
            break;
        case SEARCH_FOLLOWING_CONNECT:
            keepState = FOLLOWING_CONNECT;
            friendlist_page = currentpage_previouse;
            break;
        case SEARCH_FRIENDS_CONNECT:
            keepState = FRIENDS_CONNECT;
            friendlist_page = currentpage_previouse;
            break;
            
        default:
            break;
    }
    //end manage

    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    //call service search
    
    //clear data
    //[DataSearchArray removeAllObjects];
    
    //0=people, 1 = follwing, 2 = follower, 3 = friends
    switch (self.segmentFilter.selectedSegmentIndex) {
        case 3://segment type //people
        {
            [self sendRequestSearchWord:searchBar.text MyID:my_user_id MyToken:my_token_id FriendType:0 SizePage:friendlist_page_size Page:friendlist_page];
        }
            break;
        case 2://segment type //following
        {
            [self sendRequestSearchWord:searchBar.text MyID:my_user_id MyToken:my_token_id FriendType:1 SizePage:friendlist_page_size Page:friendlist_page];
        }
            break;
        case 1://segment type //follower
        {
            [self sendRequestSearchWord:searchBar.text MyID:my_user_id MyToken:my_token_id FriendType:2 SizePage:friendlist_page_size Page:friendlist_page];
        }
            break;
        case 0://segment type //friends
        {
            [self sendRequestSearchWord:searchBar.text MyID:my_user_id MyToken:my_token_id FriendType:3 SizePage:friendlist_page_size Page:friendlist_page];
        }
            break;
            
        default:
            break;
    }
    
}


-(void)sendRequestSearchWord:(NSString *) stringsearch MyID:(int) myid MyToken:(NSString *) mytoken FriendType:(int) friendtype SizePage:(int) sizepage Page:(int) page{
    //0=people, 1 = follwing, 2 = follower, 3 = friends
    
    switch (friendtype) {
        case 0://people
        {
            current_connect = SEARCH_PEOPLE_CONNECT;
            keepState = SEARCH_PEOPLE_CONNECT;
        }
            break;
        case 1:
        {
            current_connect = SEARCH_FOLLOWING_CONNECT;
            keepState = SEARCH_FOLLOWING_CONNECT;
        }
            break;
        case 2:
        {
            current_connect = SEARCH_FOLLOWER_CONNECT;
            keepState = SEARCH_FOLLOWER_CONNECT;
        }
            break;
        case 3:
        {
            current_connect = SEARCH_FRIENDS_CONNECT;
            keepState = SEARCH_FRIENDS_CONNECT;
        }
            break;
            
        default:
            break;
    }
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/searchPeople/mobile",kIPAPIServiceAddress]];
    //    NSLog(@"URL = %@",url);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    
    [requestData addPostValue:[NSString stringWithFormat:@"%@", mytoken] forKey:@"token"];
    [requestData addPostValue:[NSString stringWithFormat:@"%d", myid] forKey:@"userID"];
    [requestData addPostValue:[NSString stringWithFormat:@"%@", stringsearch] forKey:@"keyword"];
    [requestData addPostValue:[NSString stringWithFormat:@"%d", friendtype] forKey:@"type"];
    [requestData addPostValue:[NSString stringWithFormat:@"%d", sizepage*page] forKey:@"startPoint"];
    [requestData addPostValue:[NSString stringWithFormat:@"%d", sizepage] forKey:@"sizePage"];
    
    [requestData startAsynchronous];
    
    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    
    UIViewController * vc = app.window.rootViewController;
    
    if (page == 0) {
        //Start Progress
        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
        [vc.view addSubview:HUD];
        
        HUD.delegate = self ;
        HUD.labelText=@"loading";
        [HUD show:YES];
    }
    
    
    
}

#pragma mark - ChatViewDelegate
-(void)ChatViewControl:(ChatViewController *)chatview DidSelectIndexPath:(NSIndexPath *)indextpath Datadict:(NSDictionary *)dict BadgeDict:(NSDictionary *)badgedict{
    
    if (chatlistview != nil) {
        chatlistview.view.hidden = YES;
    }
    
    NSString * nib_File = @"ChatPageViewController_iPhone";
    
    if (IS_DEVICE_MODEL_5) {
        nib_File = @"ChatPageViewController_iPhone5";
    }
    
    //ChatPageViewController * chatpage = [ChatPageViewController new];
    ChatPageViewController * chatpage = [[ChatPageViewController alloc] initWithNibName:nib_File bundle:nil];
    chatpage.delegate = self;
    chatpage.user_id = my_user_id;
    chatpage.token_id = my_token_id;
    //--chatpage.friend_id = (int)[[dict objectForKey:@""] intValue];
    chatpage.recentdatadict = dict;
    chatpage.mydatadict = myDataDict;
    chatpage.myBadgePush = badgedict;
    
//    NSLog(@"dict Select is; %@",dict);
//    NSLog(@"my data dict is; %@",myDataDict);
    
    //[self.navigationController presentViewController:chatview animated:YES completion:nil];
    
    //call clear badge
    //int friendid = [[dict objectForKey:@"FRIENDID"] intValue];
    
    //[self clearBadgeWithFriendID:friendid];
    
    [self.navigationController pushViewController:chatpage animated:YES];
    
    
}

-(void) clearBadgeWithFriendID:(int) friendid{
    
    if ([self.myBadgeDataArr count] > 0) {
        
        BOOL foundflag = NO;
        int currentIndex = 0;
        
        for (NSDictionary * dt in self.myBadgeDataArr) {
            
            int senderid = [[dt objectForKey:@"from_userid"] intValue];
            
            if (senderid == friendid) {
                foundflag = YES;
                break;
            }
            
            currentIndex ++;
            
        }
        
        
        if (foundflag) {
            
            //clear badge
            NSMutableArray * tmp = [[NSMutableArray alloc] init];
            
            for (NSDictionary * dt in self.myBadgeDataArr) {
                int senderid = [[dt objectForKey:@"from_userid"] intValue];
                
                if (senderid != friendid) {
                    [tmp addObject:dt];
                }

            }//for
            
            
            self.myBadgeDataArr = (NSArray *)tmp;
            
            //update display badge
            if ([self.myBadgeDataArr count] > 0) {
                
                int totalbadge=0;
                
                for (NSDictionary * dt in self.myBadgeDataArr) {
                    
                    int count = [[dt objectForKey:@"badge"] intValue];
                    
                    if (count > 0) {
                        totalbadge += count;
                    }
                    
                    if (totalbadge >0 ) {
                        [self ShowNumOfChat:totalbadge];
                    }else{
                        [self HideNumOfChat];
                    }
                    
                    
                }
            }else{
                [self HideNumOfChat];
            }

            
            
            
        }
    }
}

#pragma mark - ChatPageViewDelegate
-(void)ChatPageViewClosedAndUpdateLastChatDict:(NSDictionary *)recentdictupdate{
    if (chatlistview != nil) {
        
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"chatlistview" message:@"!= nil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
        
        //[chatlistview reloadDataRecentChat];
        [chatlistview UpdateRecentChatWithDict:recentdictupdate];
        //chatlistview.view.hidden = NO;
         self.navigationItem.title = @"Recent Chat";
        
        [self ControlOpenPageByButtonTag:1];//chat
    }else{
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"chatlistview" message:@"== nil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
        
        NSString * nib_File = @"ChatViewController_iPhone";
        
        if (IS_DEVICE_MODEL_5) {
            nib_File = @"ChatViewController_iPhone5";
        }
        
        chatlistview = [[ChatViewController alloc] initWithNibName:nib_File bundle:nil];
        chatlistview.delegate = self;
        chatlistview.user_id = my_user_id;
        chatlistview.token_id = my_token_id;
        chatlistview.mydatadict = [myDataDict copy];
        //chatlistview.dataBageArr = [self.myBadgeDataArr copy];
        
        //chatlistview.datadict = dict;
        
        [self.view addSubview:chatlistview.view];
        
        //call load recent
        //[chatlistview CallServiceUpdateRecentChat];
        
        self.navigationItem.title = @"Recent Chat";
        [self ControlOpenPageByButtonTag:1];//chat
    }
}

-(void)ChatViewControlCallNewDisplayBadgeNum:(int)numbadge{
    
    //เพิ่ม June's code update badge จาก appdelegate ได้เลยครับ
    //insert here
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app setBadgeChatCount:numbadge];
    
    ////////////////
    
    [self ShowNumOfChat:numbadge];
    
}

//-(void)ChatPageViewClearBadgeDict:(NSDictionary *)badgedict{
//    
//    NSLog(@"ChatPageViewClearBadgeDict : %@",badgedict);
//    
//    if(chatlistview != nil)[chatlistview CallClearBadgeDict:badgedict];
//}

#pragma mark - SettingViewDelegate
-(void)SettingViewDidSelectButtonTag:(int)buttontag{
//    if (settingview != nil) {
//        settingview.view.hidden = YES;
//    }
    switch (buttontag) {
        case 0://sticker
        {
            
//            NSString * nib_File = @"StiickerViewController_iPhone";
//            
//            if (IS_DEVICE_MODEL_5) {
//                nib_File = @"StiickerViewController_iPhone5";
//            }
//            
//            StiickerViewController * stickerView = [[StiickerViewController alloc] initWithNibName:nib_File bundle:nil];
//            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:stickerView];
//            
//            [self presentViewController:nav animated:YES completion:nil];
            //[self.navigationController pushViewController:stckerView animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - TimeLineDelegate
-(void)TimeLineViewControl:(TimeLineViewController *)timelineview DidSelectIndexPath:(NSIndexPath *)indextpath withDict:(NSDictionary *)dict{
    TimeLineDetailsViewController * details = [[TimeLineDetailsViewController alloc] initWithNibName:@"TimeLineDetailsViewController_iPhone5" bundle:nil];
    details.delegate = self;
    details.datadict = dict;
    details.titlename = [dict objectForKey:@"USERNAME"];
    
    [self.navigationController pushViewController:details animated:YES];
}

#pragma mark - TimeLineDetatilsDelegate
-(void)TimeLineDelegateDidClose{
    if (timelineview != nil) {
        timelineview.view.hidden = NO;
    }
}


#pragma mark - data connect
//-(void)sendRequestUserInfo{
//    
//    //current_connect = ENDDAYOFFERSCONNECT;
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?action=getprofileinfo",kIPAPIServiceAddress]];
//    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
//    [requestData setDelegate:self];
//    //[requestData setTimeOutSeconds:360];
//    
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"kimkundad"] forKey:@"username"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"25a50fea6d48cb15f4e37c53fe29ebd5"] forKey:@"tokenid"];
//    
//    [requestData startAsynchronous];
//    
//    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    
//    //Start Progress
//    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//    [vc.view addSubview:HUD];
//    
//    HUD.delegate = self ;
//    HUD.labelText=@"loading";
//    [HUD show:YES];
//    
//}

-(void)sendRequestFriendsFromMyTokenID:(NSString *) mytokenid UserID:(int) myuserid Pagesize:(int) pagesize Page:(int) page{
    
    current_connect = FRIENDS_CONNECT;
    keepState = FRIENDS_CONNECT;
    enableCallService = YES;
    
    
    //ok////>>>>>https://api.vdomax.com/service/getFriends/mobile/?token=asdf11&userID=1&type=1&startPoint=0&sizePage=20
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/getFriends/mobile/?token=%@&userID=%d&type=1&startPoint=%d&sizePage=%d",kIPAPIServiceAddress,mytokenid,myuserid,page*pagesize,pagesize]];
    //    NSLog(@"URL = %@",url);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    
    [requestData startAsynchronous];
    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    
//    if (page == 0) {
//        //Start Progress
//        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//        [vc.view addSubview:HUD];
//        
//        HUD.delegate = self ;
//        HUD.labelText=@"loading";
//        [HUD show:YES];
//    }
    
}
-(void)sendRequestFollowerFromMyTokenID:(NSString *) mytokenid UserID:(int) myuserid Pagesize:(int) pagesize Page:(int) page{
    
    current_connect = FOLLOWER_CONNECT;
    keepState = FOLLOWER_CONNECT;
    enableCallService = YES;
    
    //ok////>>>>>https://api.vdomax.com/service/getFollow/mobile/?token=asdf11&userID=1&type=1&startPoint=0&sizePage=20
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/getFollow/mobile/?token=%@&userID=%d&type=1&startPoint=%d&sizePage=%d",kIPAPIServiceAddress,mytokenid,myuserid,page*pagesize,pagesize]];
    //    NSLog(@"URL = %@",url);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    
    [requestData startAsynchronous];
    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    
//    if (page == 0) {
//        //Start Progress
//        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//        [vc.view addSubview:HUD];
//        
//        HUD.delegate = self ;
//        HUD.labelText=@"loading";
//        [HUD show:YES];
//    }
    
}

-(void)sendRequestFollowingFromMyTokenID:(NSString *) mytokenid UserID:(int) myuserid Pagesize:(int) pagesize Page:(int) page{
    
    current_connect = FOLLOWING_CONNECT;
    keepState = FOLLOWING_CONNECT;
    enableCallService = YES;
    
    //ok////>>>>>https://api.vdomax.com/service/getFollow/mobile/?token=asdf11&userID=1&type=2&startPoint=0&sizePage=20
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/getFollow/mobile/?token=%@&userID=%d&type=2&startPoint=%d&sizePage=%d",kIPAPIServiceAddress,mytokenid,myuserid,page*pagesize,pagesize]];
    //    NSLog(@"URL = %@",url);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    
    [requestData startAsynchronous];
    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    
//    if (page == 0) {
//        //Start Progress
//        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//        [vc.view addSubview:HUD];
//        
//        HUD.delegate = self ;
//        HUD.labelText=@"loading";
//        [HUD show:YES];
//    }
    
}


-(void)sendRequestPeopleFromTokenID:(NSString *) mytokenid Pagesize:(int) pagesize Page:(int) page{
    
    current_connect = PEOPLE_CONNECT;
    keepState = PEOPLE_CONNECT;
    enableCallService = YES;
    
    //ok////>>>>>https://api.vdomax.com/service/getPeople/mobile/?token=asdf2&startPoint=0&sizePage=20
    
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/getPeople/mobile/?token=%@&startPoint=%d&sizePage=%d",kIPAPIServiceAddress,mytokenid,page*pagesize,pagesize]];
//    NSLog(@"URL = %@",url);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    
    [requestData startAsynchronous];
    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    
//    if (page == 0) {
//        //Start Progress
//        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//        [vc.view addSubview:HUD];
//        
//        HUD.delegate = self ;
//        HUD.labelText=@"loading";
//        [HUD show:YES];
//    }
    
}


-(void)sendRequestBadgeDataWithUserID:(int) usr_id{
    
    current_connect = BADGEINFO_CONNECT;
    enableCallService = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.vdomax.com/noti/?method=getchats&user_id=%d",usr_id]];
    
    
    
    
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData startAsynchronous];
    
}


-(void)sendRequestGetInfoUserID:(int) usr_id withToken:(NSString *) tokenid{
    
    current_connect = GETUSERINFO_CONNECT;
    enableCallService = YES;
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/getprofileinfo/mobile/?token=%@&userid=%d",kIPAPIServiceAddress,tokenid,usr_id]];
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:[NSString stringWithFormat:@"url: %@",url.absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData startAsynchronous];
    
}



//-(void)sendRequestUserLogin{
//    
//    //current_connect = ENDDAYOFFERSCONNECT;
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?action=login",kIPAPIServiceAddress]];
//    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
//    [requestData setDelegate:self];
//    //[requestData setTimeOutSeconds:360];
//    
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"yutemail@hotmail.com"] forKey:@"username_email"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"12345678"] forKey:@"password"];
//    
//    [requestData startAsynchronous];
//    
//    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    
//    //Start Progress
//    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//    [vc.view addSubview:HUD];
//    
//    HUD.delegate = self ;
//    HUD.labelText=@"loading";
//    [HUD show:YES];
//    
//    //{"status":1,"msg":"Login is successful.","tokenid":"50807c8c09201f207db39d2f04cf526c"}
//    
//}

//-(void)sendRequestRegister{
//    
//    //current_connect = ENDDAYOFFERSCONNECT;
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?action=register",kIPAPIServiceAddress]];
//    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
//    [requestData setDelegate:self];
//    //[requestData setTimeOutSeconds:360];
//    
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"yuttest"] forKey:@"firstname"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"yutlastname"] forKey:@"lastname"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"yutuser"] forKey:@"username"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"yutemail@hotmail.com"] forKey:@"email"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"yutemail@hotmail.com"] forKey:@"confirm"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"12345678"] forKey:@"password"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"M"] forKey:@"sex"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"1"] forKey:@"month"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"1"] forKey:@"day"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"1983"] forKey:@"year"];
//    
//    [requestData startAsynchronous];
//    
//    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    //Start Progress
//    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//    [vc.view addSubview:HUD];
//    
//    HUD.delegate = self ;
//    HUD.labelText=@"loading";
//    [HUD show:YES];
//    
//}


//-(void)sendRequestUserTimeline{
//    
//    //current_connect = ENDDAYOFFERSCONNECT;
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?action=gettimeline",kIPAPIServiceAddress]];
//    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
//    [requestData setDelegate:self];
//    //[requestData setTimeOutSeconds:360];
//    
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"0bf5b74d1cd9d149efb2e118858a40ba"] forKey:@"tokenid"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"home"] forKey:@"app"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"all"] forKey:@"get"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"All"] forKey:@"filter"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"20"] forKey:@"startPoint"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"Most Recent"] forKey:@"sort"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"1"] forKey:@"page"];
//    
//    [requestData startAsynchronous];
//    
//    
//    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
//    
//    UIViewController * vc = app.window.rootViewController;
//    
//    
//    //Start Progress
//    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
//    [vc.view addSubview:HUD];
//    
//    HUD.delegate = self ;
//    HUD.labelText=@"loading";
//    [HUD show:YES];
//    
//    //{"status":1,"msg":"Login is successful.","tokenid":"50807c8c09201f207db39d2f04cf526c"}
//    
//}
//
-(void)OpenChatViewWithFriendID:(int ) friendid{
    
    //    dictSelected = [NSDictionary alloc] initWithObjectsAndKeys:@"",@"USERID",
    //    @"",@"USERTOKEN",
    //    @"",@"USERTOKENMOBILE",
    //    @"",@"USERNAME",
    //    @"",@"USERIMAGE",
    //    @"",@"STATUS",
    //    nil];
    
    if ([DataAllArray count] > 0) {
        
        int i = 0;
        for (NSDictionary * dt in DataAllArray) {
            int idchat = [[dt objectForKey:@"UserID"] intValue];
            if (friendid == idchat) {
                NSIndexPath * indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                [self tableView:self.tbFriendList didSelectRowAtIndexPath:indexpath];
                
                break;
            }
            
            i++;
        }
    }
    
    //[self ControlOpenPageByButtonTag:1];
    
    
    
    
    /*
     {"USERID":"61","USERTOKEN":"1f5dd32c8208a9cbb484b621030df759","USERTOKENMOBILE":"1f5dd32c8208a9cbb484b621030df759","USERNAME":"seanhanphayom","USERIMAGE":"anonymous","STATUS":""}
     */
}

#pragma mark - ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    //NSLog(@"requestFinished : %@", [request responseString]);
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Check Chat view" message:[NSString stringWithFormat:@"%@",[request responseString]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    enableCallService = NO;
    
//    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    //NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
//    NSArray *jsonObject = (NSArray *)[parser objectWithString:[request responseString]];
    
//    NSLog(@"data: %@",jsonObject);
    
    //int status = [[jsonObject objectForKey:@"status"] intValue];
    
        
        /*
        NSDictionary * datadict = (NSDictionary *)[jsonObject objectForKey:@"data"];
        if ([datadict count] >0) {
            
            NSArray * onlineuser = (NSArray *)[datadict objectForKey:@"onlines"];
            
            if ([onlineuser count] > 0) {
                
                //clear table
                [DataAllArray removeAllObjects];
                
                for (NSDictionary * dt in onlineuser) {
                    [DataAllArray addObject:dt];
                }
                
                //refresh table
                [self.tbFriendList reloadData];
            }
        }
         
         */
        
        if (current_connect == FRIENDS_CONNECT
            ||current_connect == FOLLOWER_CONNECT
            ||current_connect == FOLLOWING_CONNECT
            ||current_connect == PEOPLE_CONNECT
            ) {
            
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            
            NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
            //NSArray *jsonObject = (NSArray *)[parser objectWithString:[request responseString]];
            
            if (![jsonObject isKindOfClass:[NSNull class]]) {
                
                int status = [[jsonObject objectForKey:@"status"] intValue];
                
                if (status == 7101 || status == 7001) {
                    
                    if (friendlist_page<=0)[DataAllArray removeAllObjects];//clear data
                    
                    if (![[jsonObject objectForKey:@"Content"] isKindOfClass:[NSNull class]]) {
                        
                        NSArray * data = (NSArray *)[jsonObject objectForKey:@"Content"];
                        
                        if ([data count] > 0) {
                            
                            //add new message first step
                            for (NSDictionary * dt in data) {
                                
//                                NSLog(@"dict : %@", dt);
                                [DataAllArray addObject:dt];
                                
                            }
                            
                            //refresh table
                            [self.tbFriendList reloadData];
                            
                            
                            
//                            if (!firstLoad) {
//                                firstLoad = YES;
//                                [self sendRequestBadgeDataWithUserID:my_user_id];
//                            }
                            
                        }//end if
                        
                        
                        //turn off load more
//                        if ([data count] < friendlist_page_size) {
//                            enableLoadMore = NO;
//                            self.tbFriendList.tableFooterView.hidden = YES;
//                        }else{
//                            enableLoadMore = YES;
//                            self.tbFriendList.tableFooterView.hidden = NO;
//                            
//                        }
                    }else{
//                        enableLoadMore = NO;
//                        self.tbFriendList.tableFooterView.hidden = YES;
                        
                        [self.tbFriendList reloadData];
                    }

                    //update badge
                    
                    if (!firstLoad) {
                        firstLoad = YES;
                        [self sendRequestBadgeDataWithUserID:my_user_id];
                    }
                    
                    
                }else{
                    //7101
                    
                    NSString * msg = [jsonObject objectForKey:@"msg"];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                }
  
            }else{
                
                enableLoadMore = NO;
                self.tbFriendList.tableFooterView.hidden = YES;
                
                //NSString * msg = [jsonObject objectForKey:@"msg"];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:@"not found data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
            
            
        }else if (current_connect == BADGEINFO_CONNECT){
            
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            
            NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
            //NSArray *jsonObject = (NSArray *)[parser objectWithString:[request responseString]];
            
            if ([[jsonObject objectForKey:@"status"] intValue] == 1) {//success
                
                self.myBadgeDataArr = (NSArray *)[jsonObject objectForKey:@"data"];
                
//                NSLog(@"self.myBadgeDataArr %@",self.myBadgeDataArr);
                
                if ([self.myBadgeDataArr count] > 0) {
                    
                    int totalbadge=0;
                    
                    for (NSDictionary * dt in self.myBadgeDataArr) {
                        
                        int count = [[dt objectForKey:@"badge"] intValue];
                        
                        if (count > 0) {
                            totalbadge += count;
                        }
                    }//for
                    
                    if (totalbadge >0 ) {
                        [self ShowNumOfChat:totalbadge];
                    }else{
                        [self HideNumOfChat];
                    }
                    
                }else{
                    [self HideNumOfChat];
                }

                
            }
            
            //call push page
//            if (enablenoti) {
//                
//                [self OpenChatViewWithFriendID:self.pushfriendid];
//                
//            }
            
            
        }else if (current_connect == GETUSERINFO_CONNECT){
            
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            
            NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
            
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"GETUSERINFO_CONNECT " message:[NSString stringWithFormat:@"json:%@",jsonObject ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
            
            int status = [[jsonObject objectForKey:@"status"] intValue];
            if(status == 3001){//success
                
                NSDictionary * userdict = [jsonObject objectForKey:@"data"];
                
                
                if (![userdict isKindOfClass:[NSNull class]]) {
                    [self OpenChatViewWithFriendDict:[self ChangeFormatRecentChatWithFrienDic:userdict]];
                }
                
                
            }
        }

    else if (current_connect == SEARCH_PEOPLE_CONNECT
             ||current_connect == SEARCH_FOLLOWER_CONNECT
             ||current_connect == SEARCH_FOLLOWING_CONNECT
             ||current_connect == SEARCH_FRIENDS_CONNECT){
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
        //NSArray *jsonObject = (NSArray *)[parser objectWithString:[request responseString]];
        
        if (![jsonObject isKindOfClass:[NSNull class]]) {
            
            int status = [[jsonObject objectForKey:@"status"] intValue];
            
            if (status == 7101 || status == 7001) {
                
                if (friendlist_page<=0)[DataSearchArray removeAllObjects];//clear data
                
                if (![[jsonObject objectForKey:@"Content"] isKindOfClass:[NSNull class]]) {
                    
                    NSArray * data = (NSArray *)[jsonObject objectForKey:@"Content"];
                    
                    if ([data count] > 0) {
                        
                        //add new message first step
                        for (NSDictionary * dt in data) {
                            
//                            NSLog(@"dict : %@", dt);
                            [DataSearchArray addObject:dt];
                            
                        }
                        
                        //refresh table
                        //[self.tbFriendList reloadData];
                        
                        [self.searchDisplayController.searchResultsTableView reloadData];
                        
                        
                        
//                        if (!firstLoad) {
//                            firstLoad = YES;
//                            [self sendRequestBadgeDataWithUserID:my_user_id];
//                        }
                        
                    }//end if
                }else{
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }
                
            }else{
                //7101
                
                NSString * msg = [jsonObject objectForKey:@"msg"];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
            
        }else{
            
            enableLoadMore = NO;
            self.tbFriendList.tableFooterView.hidden = YES;
            
            //NSString * msg = [jsonObject objectForKey:@"msg"];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:@"not found data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    
    if(refreshControl){
        [refreshControl endRefreshing];
        [self hideFooter];
    }
    
    //trun off progress
    [HUD hide:YES];
            

}

-(void)requestFailed:(ASIHTTPRequest *)request{
//        NSLog(@"requestFailed : %@", [request responseString]);
    
    enableCallService = NO;
    
    if(refreshControl){
        [refreshControl endRefreshing];
        [self hideFooter];
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



@end
