
//  Created by yut on 8/22/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize delegate;
@synthesize recentdict;
@synthesize user_id;
@synthesize token_id;
@synthesize dataBageArr;
@synthesize mydatadict;
//@synthesize friendDataArray;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DataSearchArray = [[NSMutableArray alloc] init];
    DataAllArray = [[NSMutableArray alloc] init];
    
    chatpage = 0;
    chatpagesize = 20;
    enableLoadMore = YES;
    
//    self.tbFriendList.tableFooterView = self.uiviewLoadmore;
//    self.tbFriendList.tableFooterView.hidden = YES;
    
    //Custome Load More
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tbFriendList];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.title = @"Recent Chat";
    
    
//    for (int i = 0; i<20; i++) {
//        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"namechat_%d",i],@"USERNAME",
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
    
    DataAllArray = [[NSMutableArray alloc] init];
    
//    if ([self.friendDataArray count]>0) {
//        
//        for (NSDictionary * dt in self.friendDataArray) {
//            [DataAllArray addObject:dt];
//        }
//        
//        [self sendRequestBadgeDataWithUserID:self.user_id PageSize:chatpagesize Page:chatpage];
//        
//        //after call recent chat
//    }else{
//        
//        
//        
//    }
    
    
    
    
    /*
    
    NSArray * tmp = (NSArray *)[self LoadDataDictFromPlistFileName:@"RECENTCHATPLIST"];

    for (NSDictionary * dt in tmp) {
        [DataAllArray addObject:dt];
    }
    
    if([self.dataBageArr count] <= 0){
        [self sendRequestBadgeDataWithUserID:self.user_id];
    }
    else {
        BadgeArray = [self.dataBageArr copy];
    }
     */
    
    
    //call service Recent chat เมื่อ view did load หรือ มี Push มา
    //[self CallServiceUpdateRecentChat];
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!app.isGetNewChatNotification) {
        [self CallServiceUpdateRecentChat];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (app.isGetNewChatNotification) {
        [self CallServiceUpdateRecentChat];
    }
}


-(void)CallServiceUpdateRecentChat{
    chatpage = 0;
    
    [self sendRequestRecentChatUserID:self.user_id Page:chatpage Pagesize:chatpagesize];
}

-(void)CallClearBadgeDictWithConversationID:(int ) conversationid{
    
    NSMutableArray * tmp = [[NSMutableArray alloc] init];
 
    for (NSDictionary * dt in BadgeArray) {
        
        int conid = [[dt objectForKey:@"id"] intValue];
        //int conidclear = [[dictclear objectForKey:@"id"] intValue];
        
        
        if (conid != conversationid) {
            [tmp addObject:dt];
        }
    }//for
    
    //new batch
    BadgeArray = [tmp copy];
    
    //refresh table
    [self.tbFriendList reloadData];
    
    
    if (self.delegate) {
        int numbadge = 0;
        
        for (NSDictionary * dt in BadgeArray) {
            
            int num = [[dt objectForKey:@"badge"] intValue];
            
            numbadge += num;

        }//for

        
        [self.delegate ChatViewControlCallNewDisplayBadgeNum:numbadge];
    }
}

#pragma mark - dropViewDidBeginRefreshing

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshContr
{

    if (enableCallService) return;
    
        chatpage = 0;
        current_tChat = 0;
        
        if(keepState == RECENTCHATCONNECT){
            //[DataAllArray removeAllObjects];
            //[self.tbFriendList reloadData];
            [self sendRequestRecentChatUserID:self.user_id Page:chatpage Pagesize:chatpagesize];
        }
        
        else if(keepState == SEARCH_FRIEND_RECENT_CONNECT){
            //[DataSearchArray removeAllObjects];
            //[self.tbFriendList reloadData];
            [self sendRequestSearchWord:self.searchBarDisplay.text MyID:self.user_id MyToken:self.token_id SizePage:chatpagesize Page:chatpage];
        }
    
    
}

- (void)LoadMoreRequest
{
    
    if (enableCallService) return;
    
        chatpage = chatpage+1;
    if (current_tChat == RECENTCHATCONNECT) {
        currentpage_recentchat = chatpage;
    }
        
        if(keepState == RECENTCHATCONNECT)[self sendRequestRecentChatUserID:self.user_id Page:chatpage Pagesize:chatpagesize];
        else if(keepState == SEARCH_FRIEND_RECENT_CONNECT){
            [self sendRequestSearchWord:self.searchBarDisplay.text MyID:self.user_id MyToken:self.token_id SizePage:chatpagesize Page:chatpage];
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
    if (openDict == nil) {
        return nil;
    }else{
        NSArray * dictArryTmp = [openDict objectForKey:@"RECENTCHAT"];
        return dictArryTmp;
    }
}

/*
-(void)chatHistoryAddTempDict{
    
//    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"namechat_%d",0],@"USERNAME",
//                           @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"USERIMAGE",
//                           @"add my status",@"STATUS",
//                           nil];
//
    
    
    if ([self.recentdict count]>0) {
        
        //int friendid = (int)[[self.datadict objectForKey:@"USERID"] intValue];//is friend id
        
        
        
        
        
        //create free dict
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"MESSAGETYPE"
                               ,@"recent chat", @"MESSAGECHAT"
                               ,@"0", @"CONVERSATION_ID"
                               ,[NSString stringWithFormat:@"%d", self.user_id], @"SENDERID" //is my id
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
                               ,[self.mydatadict objectForKey:@"USERIMAGE"], @"SENDERIMAGE"
                               ,[self.mydatadict objectForKey:@"USERNAME"], @"SENDERUSERNAME"
                               ,@"", @"TIMESTAMP"
                               ,@"", @"TIMESTAMPMS"
                               , nil];
        
        NSDictionary * dictRecent = [[NSDictionary alloc] initWithObjectsAndKeys:[self.datadict objectForKey:@"USERID"],@"FRIENDID"
                                     ,[self.datadict objectForKey:@"USERNAME"],@"FRIENDNAME"
                                     ,[self.datadict objectForKey:@"USERIMAGE"],@"FRIENDIMAGE"
                                     ,dict,@"LASTMESSAGEDATA"
                                     ,nil];
        
        
        [DataAllArray insertObject:dictRecent atIndex:0];
        
    }
    
}

 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customNavBar{
    
    UIBarButtonItem * rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(AddNewFriend)];
    self.navigationItem.rightBarButtonItem = rightbutton;
    
    //self.navigationItem.title = @"Chat";
    
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
    static NSString *CellIdentifier = @"ChatListCell";
    ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSString *_nibFileCell = @"ChatListCell_iPhone";
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:_nibFileCell owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        
    }
    
    
    if (cell != nil) {
        cell.bubview = nil;
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        NSDictionary * dtDict = (NSDictionary *)[[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"DATARECENTCHAT"];
        
        NSString * urlString = [[dtDict objectForKey:@"USERFRIENDPROFILE"] objectForKey:@"FRIENDIMAGE"];
        
        if (![urlString isKindOfClass:[NSNull class]]) {
            NSArray * words = [urlString componentsSeparatedByString:@"graph.facebook.com"];
            
            //        NSLog(@"words = %@",words);
            
            if ([words count] < 2) {
                urlString = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,urlString];
            }
        }else{
            urlString = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,@"anonymous"];
        }
        
        [cell.imgProfile setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
        cell.lbName.text = [[dtDict objectForKey:@"USERFRIENDPROFILE"] objectForKey:@"FRIENDNAME"];
        
        
        NSArray * arrchat = (NSArray *)[dtDict objectForKey:@"LASTMESSAGE"];
        if ([arrchat count]>0) {
            cell.lbStatus.text = [[arrchat objectAtIndex:0] objectForKey:@"MESSAGECHAT"];
        }else{
            cell.lbStatus.text = @"";
        }
        
        
        //int f_id = [[[dtDict objectForKey:@"FRIENDID"] objectForKey:@"USERFRIENDPROFILE"] intValue];
        int c_id = [[[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"CID"] intValue];
        
        int cNoteRead = [self CheckCountBageFromDict:BadgeArray ConversationID:c_id];
        //cell.NotReadCount = cNoteRead;
        
        if (cNoteRead > 0 ) {
            if (cell.bubview == nil) {
                cell.bubview = [[JSBadgeView alloc] initWithParentView:cell alignment:JSBadgeViewAlignmentCenterRight];
                cell.bubview.badgePositionAdjustment = CGPointMake(-20, 0);
                
            }
            
            [cell.bubview setBadgeText:[NSString stringWithFormat:@"%d",cNoteRead]];
        }else{
            if (cell.bubview != nil)[cell.bubview setBadgeText:@""];
        }

        
        
    }
    else {
        //NSString * urlString = [[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"FRIENDIMAGE"];
        
        NSDictionary * dtDict = (NSDictionary *)[[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"DATARECENTCHAT"];
        
        NSString * urlString = [[dtDict objectForKey:@"USERFRIENDPROFILE"] objectForKey:@"FRIENDIMAGE"];
        
        if (![urlString isKindOfClass:[NSNull class]]) {
            NSArray * words = [urlString componentsSeparatedByString:@"graph.facebook.com"];
            
            //        NSLog(@"words = %@",words);
            
            if ([words count] < 2) {
                urlString = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,urlString];
            }
        }else{
            urlString = [NSString stringWithFormat:@"%@/photo/%@",kIPServiceAddress,@"anonymous"];
        }
        
        
        [cell.imgProfile setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
        cell.lbName.text = [[dtDict objectForKey:@"USERFRIENDPROFILE"] objectForKey:@"FRIENDNAME"];
        
        NSArray * arrchat = (NSArray *)[dtDict objectForKey:@"LASTMESSAGE"];
        if ([arrchat count]>0) {
            cell.lbStatus.text = [[arrchat objectAtIndex:0] objectForKey:@"MESSAGECHAT"];
        }else{
            cell.lbStatus.text = @"";
        }
        
//        int f_id = [[[dtDict objectForKey:@"USERFRIENDPROFILE"] objectForKey:@"FRIENDID"] intValue];
//        
//        int cNoteRead = [self CheckCountBageFromDict:BadgeArray FriendID:f_id];
        
        int c_id = [[[DataAllArray objectAtIndex:indexPath.row] objectForKey:@"CID"] intValue];
        
        int cNoteRead = [self CheckCountBageFromDict:BadgeArray ConversationID:c_id];
        
        //cell.NotReadCount = 10;//cNoteRead;
        
        if (cNoteRead > 0 ) {
            if (cell.bubview == nil) {
                cell.bubview = [[JSBadgeView alloc] initWithParentView:cell alignment:JSBadgeViewAlignmentCenterRight];
                cell.bubview.badgePositionAdjustment = CGPointMake(-20, 0);
                
            }
            
            [cell.bubview setBadgeText:[NSString stringWithFormat:@"%d",cNoteRead]];
        }else{
            if (cell.bubview != nil)[cell.bubview setBadgeText:@""];
        }
    }
    
    
    return cell;
}

-(NSDictionary *) getBageDictFromDict:(NSArray *) arrdict ConversationID:(int) con_id{
    
    // NSLog(@"data : %@",arrdict);
    
    if ([arrdict count] >0) {
        
        for(NSDictionary * dt in arrdict){
            
            
            int c_id = [[dt objectForKey:@"id"] intValue];
            
            if (con_id == c_id) {///found chat match
                
                NSString * from_id = [NSString stringWithFormat:@"%d",[[dt objectForKey:@"from_id"] intValue]];
                NSString * push_id = [NSString stringWithFormat:@"%d",[[dt objectForKey:@"push_id"] intValue]];
                
                
                NSDictionary * dtTemp = [[NSDictionary alloc] initWithObjectsAndKeys:from_id,@"from_id",
                                  push_id,@"push_id",
                                  [NSString stringWithFormat:@"%d",con_id],@"converesation_id",
                                  nil];
                
                return dtTemp;
            }
            
        }
        
        return nil;
        
    }else{
        return nil;
    }
    
}

-(int ) CheckCountBageFromDict:(NSArray *) arrdict FriendID:(int) friendid{
    
   // NSLog(@"data : %@",arrdict);
    
    if ([arrdict count] >0) {
        
        for(NSDictionary * dt in arrdict){
            
            
            int f_id = [[dt objectForKey:@"from_userid"] intValue];
            
            if (friendid == f_id) {///found chat match
                int badgeCount = [[dt objectForKey:@"badge"] intValue];
                return badgeCount;
            }
            
        }
        
        return 0;
        
    }else{
        return 0;
    }
    
}

-(int ) CheckCountBageFromDict:(NSArray *) arrdict ConversationID:(int) con_id{
    
    // NSLog(@"data : %@",arrdict);
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"arrdict" message:[NSString stringWithFormat:@"%@",arrdict] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    if ([arrdict count] >0) {
        
        for(NSDictionary * dt in arrdict){
            
            
            int c_id = [[dt objectForKey:@"id"] intValue];
            
            if (con_id == c_id) {///found chat match
                int badgeCount = [[dt objectForKey:@"badge"] intValue];
                return badgeCount;
            }
            
        }
        
        return 0;
        
    }else{
        return 0;
    }
    
}

-(int ) getPushIDBageFromDict:(NSArray *) arrdict FreindID:(int) friendid{
    
    
    if ([arrdict count] >0) {
        
        for(NSDictionary * dt in arrdict){
            
            
            int f_id = [[dt objectForKey:@"from_userid"] intValue];
            
            if (friendid == f_id) {///found chat match
                int pushid = [[dt objectForKey:@"push_id"] intValue];
                return pushid;
            }
            
        }
        
        return -1;
        
    }else{
        return -1;
    }
    
}

-(NSDictionary *) getPushBageDictFromDict:(NSArray *) arrdict FreindID:(int) friendid{
    
    
    if ([arrdict count] >0) {
        
        for(NSDictionary * dt in arrdict){
            
            
            int f_id = [[dt objectForKey:@"from_userid"] intValue];
            
            if (friendid == f_id) {///found chat match
                //int pushid = [[dt objectForKey:@"push_id"] intValue];
                return dt;
            }
            
        }
        
        return nil;
        
    }else{
        return nil;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatListCell * cell = (ChatListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.bubview != nil) {
        [cell.bubview setBadgeText:@""];
    }
    
    //call clear badge not show progress
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        //close search display and set new current_tChat  from SEARCH_FRIEND_RECENT_CONNECT to RECENTCHATCONNECT
        
        
        //manage connect search
        if (current_tChat == SEARCH_FRIEND_RECENT_CONNECT) {
            keepState = RECENTCHATCONNECT;
            chatpage = currentpage_recentchat;
        }
        //end search
        
        
//        NSDictionary * dtDict = (NSDictionary *)[[[DataSearchArray objectAtIndex:indexPath.row] objectForKey:@"DATARECENTCHAT"] objectForKey:@"USERFRIENDPROFILE"];
        
        NSDictionary * dtDict = (NSDictionary *)[DataSearchArray objectAtIndex:indexPath.row];

        int c_id = [[dtDict objectForKey:@"CID"] intValue];
        
//        NSDictionary * dt;
//        if ([self CheckCountBageFromDict:BadgeArray FriendID:f_id] > 0) {
//            //int pushid = [self getPushIDBageFromDict:BadgeArray FreindID:f_id];
//            dt = [self getPushBageDictFromDict:BadgeArray FreindID:f_id];
//            //[self sendRequestClearBadgeDataWithUserID:self.user_id Push_ID:pushid];
//        }
        NSDictionary * dictfound = [self getBageDictFromDict:BadgeArray ConversationID:c_id];
        
        [self.delegate ChatViewControl:self DidSelectIndexPath:[indexPath copy] Datadict:[[DataSearchArray objectAtIndex:indexPath.row ] copy] BadgeDict:dictfound];
        
        //[self CallClearBadgeDictWithConversationID:c_id];
        
        //if (cell.bubview != nil)cell.bubview = nil;
        
        self.searchDisplayController.active = NO;
        
    }else{
        
        NSDictionary * dtDict = (NSDictionary *)[DataAllArray objectAtIndex:indexPath.row];
        
        int c_id = [[dtDict objectForKey:@"CID"] intValue];
//        NSDictionary * dt;
//        if ([self CheckCountBageFromDict:BadgeArray FriendID:f_id] > 0) {
//            //int pushid = [self getPushIDBageFromDict:BadgeArray FreindID:f_id];
//            
//            //[self sendRequestClearBadgeDataWithUserID:self.user_id Push_ID:pushid];
//            
//            dt = [self getPushBageDictFromDict:BadgeArray FreindID:f_id];
//        }
        
        NSDictionary * dictfound = [self getBageDictFromDict:BadgeArray ConversationID:c_id];
        
        [self.delegate ChatViewControl:self DidSelectIndexPath:[indexPath copy] Datadict:[[DataAllArray objectAtIndex:indexPath.row ] copy] BadgeDict:dictfound];
        
        //[self CallClearBadgeDictWithConversationID:c_id];
        
        //if (cell.bubview != nil)cell.bubview = nil;
        
    }
    
}

//-(NSDictionary *)FindDataDict:(NSArray *) arrdict UserID:(int ) userid ConversationID:(int ) conid{
//    if ([arrdict count] >0) {
//        
//        for(NSDictionary * dt in arrdict){
//            
//            
//            int conver_id = [[dt objectForKey:@"id"] intValue];
//            
//            if (conid == conver_id && ) {///found chat match
//                int badgeCount = [[dt objectForKey:@"badge"] intValue];
//                return badgeCount;
//            }
//            
//        }
//        
//        return nil;
//        
//    }else{
//        return nil;
//    }
//}

/*
-(void)SelectFirstRecord{
    [self chatHistoryAddTempDict];
    [self.tbFriendList reloadData];
    
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tbFriendList didSelectRowAtIndexPath:indexpath];
}
*/

-(void)UpdateRecentChatWithDict:(NSDictionary *)lastrecentdict{
    
    //[DataAllArray removeAllObjects];
    
   // DataAllArray = (NSMutableArray *)[self LoadDataDictFromPlistFileName:@"RECENTCHATPLIST"];
    
    //[self.tbFriendList reloadData];
    
    
    //[self sendRequestBadgeDataWithUserID:self.user_id PageSize:chatpagesize Page:chatpage];
    
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!app.isGetNewChatNotification) {
        BOOL foundflag= NO;
        int index=0;
        NSDictionary * dictfound;
        int up_con_id = [[lastrecentdict objectForKey:@"CID"] intValue];
        
        NSArray * dataArrCheck;
        
        
        if (self.tbFriendList == self.searchDisplayController.searchResultsTableView) {
            
            dataArrCheck = [DataSearchArray copy];
            
        }else{
            dataArrCheck = [DataAllArray copy];
        }
        
        
        for (NSDictionary * dt in dataArrCheck) {
            
            //NSDictionary * ldict = [dt objectForKey:@"LASTMESSAGE"];
            
            int con_id = [[dt objectForKey:@"CID"] intValue];
            
            
            if (up_con_id == con_id) {
                
                foundflag = YES;
                
                dictfound = [dt copy];
                
                break;
                
            }
            
            index++;
        }
        
        
        if (foundflag) {
            //update ontop index0
            
            //NSDictionary * newdict = [[NSDictionary alloc] initWithObjectsAndKeys:[dictfound objectForKey:@"USERPROFILE"],@"USERPROFILE",lastdict,@"LASTMESSAGE", nil];
            if (self.tbFriendList == self.searchDisplayController.searchResultsTableView) {
                
                [DataSearchArray removeObjectAtIndex:index];
                //add new dict
                [DataSearchArray insertObject:lastrecentdict atIndex:0];
                
            }else{
                [DataAllArray removeObjectAtIndex:index];
                //add new dict
                [DataAllArray insertObject:lastrecentdict atIndex:0];
            }
            
        }else{
            
            if (self.tbFriendList == self.searchDisplayController.searchResultsTableView) {
                
                //add new dict
                [DataSearchArray insertObject:lastrecentdict atIndex:0];
                
                
            }else{
                //add new dict
                [DataAllArray insertObject:lastrecentdict atIndex:0];
            }
            
            
            
        }
        
        
        [self CallClearBadgeDictWithConversationID:up_con_id];
        //[self.tbFriendList reloadData];

    }else{
        //call update new badge if viewappear not call
        
        
//        [self CallServiceUpdateRecentChat];
        
        
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.tbFriendList == self.searchDisplayController.searchResultsTableView) {
        
        if ([DataSearchArray count] >= chatpagesize && indexPath.row==([DataSearchArray count]-1)) {
            //        NSLog(@" Display last row : %d ",indexPath.row);
            [self showFooter];
        }
        
    }else{
        if ([DataAllArray count] >= chatpagesize && indexPath.row==([DataAllArray count]-1)) {
            //        NSLog(@" Display last row : %d ",indexPath.row);
            [self showFooter];
        }
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

#pragma mark - SearchDelegate
/*
 
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
    //manage connect search
    if (current_tChat == SEARCH_FRIEND_RECENT_CONNECT) {
        keepState = RECENTCHATCONNECT;
        chatpage = currentpage_recentchat;
    }
    //end search
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    //call service search
    
    //clear data
    //[DataSearchArray removeAllObjects];
    
    [self sendRequestSearchWord:searchBar.text MyID:self.user_id MyToken:self.token_id SizePage:chatpagesize Page:chatpage];
    
    
}


//#pragma mark Content Filtering
/*
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [DataSearchArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.DATARECENTCHAT.USERFRIENDPROFILE.FRIENDNAME contains[c] %@",searchText];
    DataSearchArray = [NSMutableArray arrayWithArray:[DataAllArray filteredArrayUsingPredicate:predicate]];
}
*/



#pragma mark - SendRequest
-(void)sendRequestRecentChatUserID:(int) usr_id Page:(int) page Pagesize:(int) pages_ize{
    
    current_tChat = RECENTCHATCONNECT;
    keepState = RECENTCHATCONNECT;
    enableCallService = YES;
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/chat/?action=recentchat&USERID=%d&page=%d,pagesize=%d",kIPAPIServiceAddress,usr_id,page,pages_ize]];
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
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


-(void)sendRequestSearchWord:(NSString *) stringsearch MyID:(int) myid MyToken:(NSString *) mytoken SizePage:(int) sizepage Page:(int) page{
    //0=people, 1 = follwing, 2 = follower, 3 = friends
    
 
    current_tChat = SEARCH_FRIEND_RECENT_CONNECT;
    keepState = SEARCH_FRIEND_RECENT_CONNECT;
    enableCallService = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/chat/?action=searchrecentchat&USERID=%d&q=%@",kIPAPIServiceAddress,myid,stringsearch]];
    //    NSLog(@"URL = %@",url);
    
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", mytoken] forKey:@"token"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%d", myid] forKey:@"userID"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%@", stringsearch] forKey:@"keyword"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"type"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%d", sizepage*page] forKey:@"startPoint"];
//    [requestData addPostValue:[NSString stringWithFormat:@"%d", sizepage] forKey:@"sizePage"];
    
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

-(void)sendRequestBadgeDataWithUserID:(int) usr_id{
    
     current_tChat = BADGECONNECT;
    enableCallService = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.vdomax.com/noti/?method=getchats&user_id=%d",usr_id]];
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

-(void)sendRequestClearBadgeDataWithUserID:(int) usr_id Push_ID:(int) pushid{
    
    current_tChat = CLEARBADGECONNECT;
    enableCallService = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.vdomax.com/noti/?method=readed&user_id=%d&push_id=%d",usr_id,pushid]];
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData startAsynchronous];
    
    //url	NSURL *	@"http://128.199.254.106/notification/?method=readed&user_id=9&push_id=197"

}

#pragma mark - ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
//    NSLog(@"requestFinished : %@", [request responseString]);
    
  
//    UIAlertView * alert2 = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:[NSString stringWithFormat:@"%d",current_tChat] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert2 show];
//    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:[NSString stringWithFormat:@"%@",[request responseString]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    if(refreshControl){
        [refreshControl endRefreshing];
        [self hideFooter];
    }
    
    //trun off progress
    if(HUD != nil)[HUD hide:YES];
    
    
    enableCallService = NO;
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if (current_tChat == RECENTCHATCONNECT) {
        
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.isGetNewChatNotification = NO;
        
        
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
        
//        NSLog(@"Jsone Data:is %@",jsonObject);
        
        //[DataAllArray removeAllObjects];
        if (chatpage<=0)[DataAllArray removeAllObjects];//clear data
        
        NSArray * data = (NSArray *)[jsonObject objectForKey:@"data"];
        
        //add new message first step
        for (NSDictionary * dt in data) {
            
            NSArray * messarr = (NSArray *)[[dt objectForKey:@"DATARECENTCHAT"] objectForKey:@"LASTMESSAGE"];
            if ([messarr count]>0) {
                [DataAllArray addObject:dt];
            }
            
            
        }
        
        [self.tbFriendList reloadData];
        

        if(data != nil)[self sendRequestBadgeDataWithUserID:self.user_id];
    }
    else if (current_tChat == BADGECONNECT) {
        
        NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
        
        if ([[jsonObject objectForKey:@"status"] intValue] == 1) {
            
            
            BadgeArray = (NSArray *)[jsonObject objectForKey:@"data"];
            [self.tbFriendList reloadData];
            
            
            if (self.delegate) {
                int numbadge = 0;
                
                for (NSDictionary * dt in BadgeArray) {
                    
                    int num = [[dt objectForKey:@"badge"] intValue];
                    
                    numbadge += num;
                    
                }//for
                
                
                [self.delegate ChatViewControlCallNewDisplayBadgeNum:numbadge];
            }
            
            
        }else{
            
            //NSString * msg = [jsonObject objectForKey:@"msg"];
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:@"Load status error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
        }
    }
    else if(current_tChat == CLEARBADGECONNECT){
        //clear badge  already
        // set badge display
        
//        if (self.delegate) {
//            self.delegate ChatViewControlCallNewDisplayBadgeNum:<#(int)#>
//        }
    
    }else  if (current_tChat == SEARCH_FRIEND_RECENT_CONNECT) {
        
        
        /*
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
        
        NSLog(@"Jsone Data:is %@",jsonObject);
        
        
        NSArray * data = (NSArray *)[jsonObject objectForKey:@"data"];
        
        //add new message first step
        for (NSDictionary * dt in data) {
            
            NSArray * messarr = (NSArray *)[[dt objectForKey:@"DATARECENTCHAT"] objectForKey:@"LASTMESSAGE"];
            if ([messarr count]>0) {
                [DataSearchArray addObject:dt];
            }
            
            
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
         */
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
        //NSArray *jsonObject = (NSArray *)[parser objectWithString:[request responseString]];
        
        if (![jsonObject isKindOfClass:[NSNull class]]) {
            
//            NSArray * data = (NSArray *)[jsonObject objectForKey:@"data"];
            
            if (![[jsonObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                
                NSArray * data = (NSArray *)[jsonObject objectForKey:@"data"];
                
                if (chatpage<=0)[DataSearchArray removeAllObjects];//clear data
                
                
                //if (![[jsonObject objectForKey:@"Content"] isKindOfClass:[NSNull class]]) {
                    
                   // NSArray * data = (NSArray *)[jsonObject objectForKey:@"Content"];
                    
                    if ([data count] > 0) {
                        
                        //add new message first step
                        for (NSDictionary * dt in data) {
                            
//                            NSLog(@"dict : %@", dt);
                            [DataSearchArray addObject:dt];
                            
                        }
                        
                        //refresh table
                        
                        [self.searchDisplayController.searchResultsTableView reloadData];

                    }//end if
              //  }
                
            }else{
                //7101
                
//                NSString * msg = [jsonObject objectForKey:@"msg"];
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                
//                [alert show];
                
            }

        }
        
        
            
    }//end if
    
    

    
    
    
}

-(void)requestFailed:(ASIHTTPRequest *)request{
//    NSLog(@"requestFailed : %@", [request responseString]);
    
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



- (IBAction)btActLoadmore:(id)sender {
    
    if (enableLoadMore) {
        enableLoadMore = NO;//reject twice press button
        
        chatpage = chatpage+1;
        
        [self sendRequestRecentChatUserID:self.user_id Page:chatpage Pagesize:chatpagesize];
    }
    
}
@end
