//
//  ViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/22/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatListCell.h"
#import "UIImageView+WebCache.h"
//#import "ChatPageViewController.h"
#import "Global.h"

#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "ODRefreshControl.h"
#import "AppDelegate.h"

#import "AppDelegate.h"


typedef enum{
    BADGECONNECT,
    CLEARBADGECONNECT,
    //FRIENDSALLCONNECT,
    RECENTCHATCONNECT,
    SEARCH_FRIEND_RECENT_CONNECT
} TYPECHATVIEWCONNECT;



@class ChatViewController;
@protocol ChatViewDelegate <NSObject>

-(void)ChatViewControl:(ChatViewController *) chatview DidSelectIndexPath:(NSIndexPath *) indextpath Datadict:(NSDictionary *) dict BadgeDict:(NSDictionary *) badgedict;

-(void)ChatViewControlCallNewDisplayBadgeNum:(int ) numbadge;

@end



@interface ChatViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate>
{
    NSMutableArray * DataSearchArray;
    NSMutableArray * DataAllArray;
    
    NSArray * BadgeArray;
    
    //internet connect
    MBProgressHUD * HUD;
    
    TYPECHATVIEWCONNECT current_tChat;
    TYPECHATVIEWCONNECT keepState;
    
    int chatpage;
    int currentpage_recentchat;
    int chatpagesize;
    BOOL firstLoad;
    BOOL enableLoadMore;
    
    ODRefreshControl * refreshControl;
    
    BOOL enableCallService;
}
@property (assign, nonatomic) id<ChatViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tbFriendList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarDisplay;
@property (retain, nonatomic) NSDictionary * recentdict;
@property (retain, nonatomic) NSDictionary * mydatadict;
@property (assign, nonatomic) int user_id;
@property (retain, nonatomic) NSString * token_id;
@property (strong, nonatomic) NSArray * dataBageArr;
//@property (retain, nonatomic) NSArray * friendDataArray;
@property (strong, nonatomic) IBOutlet UIView *uiviewLoadmore;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoadMore;



- (IBAction)btActFriends:(id)sender;
- (IBAction)btActChats:(id)sender;
- (IBAction)btActTimeline:(id)sender;
- (IBAction)btActSetting:(id)sender;
- (IBAction)btActLoadmore:(id)sender;

//
-(void)SelectFirstRecord;
-(void)UpdateRecentChatWithDict:(NSDictionary *) lastrecentdict;
-(void)CallServiceUpdateRecentChat;
-(void)CallClearBadgeDictWithConversationID:(int ) conversationid;


@end
