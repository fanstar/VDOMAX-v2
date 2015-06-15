
#import <UIKit/UIKit.h>
#import "Global.h"
#import "JSMessagesViewController.h"
#import "OptionMenuViewController.h"
#import "TattooViewController.h"
#import "UIImageView+WebCache.h"

#import "SocketIO.h"
#import "SocketIOPacket.h"

//fo video
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

//service connect
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

//map
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

//media
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "YouTubeView.h"
#import "XCDYouTubeVideoPlayerViewController.h"

#import "RecordViewController.h"
#import "AKSVideoAndImagePicker.h"
#import "AppDelegate.h"
#import "ODRefreshControl.h"

typedef enum{
    CHATHISTORYCONNECT,
    GETLOCATIONINFOCONNECT,
    UPLOADPHOTOCONNECT,
    UPLOADMEDIACONNECT,
    UPLOADSOUNDCONNECT,
    CLEARBADGE_CHAT_CONNECT
} TYPECONNECT;


@protocol ChatPageViewDelegate <NSObject>

-(void)ChatPageViewClosedAndUpdateLastChatDict:(NSDictionary *) recentdictupdate;
//-(void)ChatPageViewClearBadgeDict:(NSDictionary *) badgedict;

@end

@interface ChatPageViewController :  UIViewController<JSMessagesViewDelegate, JSMessagesViewDataSource,OptionMenuViewDelegate,TattooViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SocketIODelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate,CLLocationManagerDelegate,RecordViewDelegate,CheckKeyboardDelegate,AKSVideoAndImagePickerDelegate>{//JSMessagesViewController
    JSMessagesViewController * messageview;
    
    //BOOL showOptionView;
    OptionMenuViewController * viewOption;
    TattooViewController * tattooView;
    RecordViewController * reccordView;
    
    UIImagePickerController * controlImagePicker;
    
    BOOL chatmenushow;
    
    SocketIO *socketIO;
    
    //internet connect
    MBProgressHUD * HUD;
    
    TYPECONNECT current_connect;
    
    UIImage * incomingImage;
    UIImage * outgoingImage;
    
    BOOL flagHanshake;
    
    //location
    CLLocationManager *locationManager;
    double cur_latitude;
    double cur_longtitude;
    NSString * location_Name;
    BOOL enableMap;
    
    AVAudioPlayer * audioPlayer;
    
    int message_page;
    int message_pagesize;
    BOOL enableLoadMore;
    
    ODRefreshControl * refreshControl;
    BOOL enableCallService;
    BOOL waitingBack;
    
}

@property (assign, nonatomic) id<ChatPageViewDelegate>delegate;
@property (strong, nonatomic) NSMutableArray *messages;
//@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) IBOutlet UIView *uiviewchatmenu;
@property (assign, nonatomic) int conversation_id;
@property (assign, nonatomic) int user_id;
@property (assign, nonatomic) int friend_id;
@property (retain, nonatomic) NSString * token_id;
@property (retain, nonatomic) NSDictionary * recentdatadict;
@property (retain, nonatomic) NSDictionary * mydatadict;
@property (retain, nonatomic) NSDictionary * myBadgePush;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoadMore;
@property (retain, nonatomic) UIImage * myImage;

- (IBAction)btActFreecall:(id)sender;
- (IBAction)btActBlock:(id)sender;
- (IBAction)btActSetting:(id)sender;

@end
