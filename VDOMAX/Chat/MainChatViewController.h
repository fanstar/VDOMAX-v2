//
//  ViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/22/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListCell.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"
#import "TimeLineViewController.h"
//#import "SettingViewController.h"
#import "ChatPageViewController.h"
#import "WritePostViewController.h"
#import "TimeLineDetailsViewController.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "JSBadgeView.h"
#import "ODRefreshControl.h"
#import "AppDelegate.h"


typedef enum{
    BADGEINFO_CONNECT,
    FRIENDS_CONNECT,
    FOLLOWER_CONNECT,
    FOLLOWING_CONNECT,
    PEOPLE_CONNECT,
    GETUSERINFO_CONNECT,
    SEARCH_FRIENDS_CONNECT,
    SEARCH_FOLLOWER_CONNECT,
    SEARCH_FOLLOWING_CONNECT,
    SEARCH_PEOPLE_CONNECT,
} MAINTYPECONNECT;




@interface MainChatViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,ChatViewDelegate,ChatPageViewDelegate,TimeLineDelegate,TimeLineDetatilsDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate>
{
    NSMutableArray * DataSearchArray;
    NSMutableArray * DataAllArray;
    ChatViewController * chatlistview;
    
    
    /* //add Jun's code* สามารถเปลี่ยนตัวแปล  timelineview เป็นของจูนทั้งหมดได้เลยครับ */
    TimeLineViewController * timelineview;
    /****** end June's code*****/
    
    
    //SettingViewController * settingview;
    
    //internet connect
    MBProgressHUD * HUD;
    
    NSDictionary * dictSelected;
    
    int my_user_id;
    NSString * my_token_id;
    NSString * my_username;
    NSString * my_imagename;
    NSString * my_tokenmobile;
    NSString * my_status;
    
    
    MAINTYPECONNECT current_connect;
    
    BOOL checkbadgeagain;
    BOOL firstLoad;
    BOOL enableLoadMore;
    
    int friendlist_page_size;
    int friendlist_page;
    int currentpage_previouse;
    
    MAINTYPECONNECT keepState;
    
   // JSBadgeView * badgebubble;
    
    SWRevealViewController *revealController;
    
    ODRefreshControl * refreshControl;
    BOOL enableCallService;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tbFriendList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarDisplay;
@property (weak, nonatomic) IBOutlet UIButton *btFriends;
@property (weak, nonatomic) IBOutlet UIButton *btChats;
@property (weak, nonatomic) IBOutlet UIButton *btTimeline;
@property (weak, nonatomic) IBOutlet UIButton *btSetting;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentFilter;
@property (strong, nonatomic) IBOutlet UIView *uiViewLoadMore;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoadMore;

//for june
@property (assign, nonatomic) BOOL enablenoti;
@property (assign, nonatomic) int pushfriendid;


@property (retain, nonatomic) NSDictionary * myDataDict;
@property (retain, nonatomic) NSDictionary * myBadgeDict;
@property (strong, nonatomic) NSString * myTokenid;
@property (retain, nonatomic) NSArray * myBadgeDataArr;
@property (retain, nonatomic) JSBadgeView * badgebubble;
//@property (assign) int countBadgeNotRead;

//pop num of chat
@property (weak, nonatomic) IBOutlet UILabel *lbNumOfChat;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGNumOfChat;

- (IBAction)btActFriends:(id)sender;
- (IBAction)btActChats:(id)sender;
- (IBAction)btActTimeline:(id)sender;
- (IBAction)btActSetting:(id)sender;
- (IBAction)btActSegmentFilter:(id)sender;
- (IBAction)btActLoadmore:(id)sender;

@end
