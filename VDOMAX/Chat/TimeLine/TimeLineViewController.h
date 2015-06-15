//
//  TimeLineViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/23/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineCell.h"
#import "UIImageView+WebCache.h"
#import "WritePostViewController.h"
//#import "TimeLineDetailsViewController.h"

#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

#import "AppDelegate.h"


@class TimeLineViewController;
@protocol TimeLineDelegate <NSObject>

-(void)TimeLineViewControl:(TimeLineViewController *) timelineview DidSelectIndexPath:(NSIndexPath *) indextpath withDict:(NSDictionary *) dict;

@end

@interface TimeLineViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate>{
    NSMutableArray * dataTimeline;
    
    //internet connect
    MBProgressHUD * HUD;
}

@property (weak, nonatomic) IBOutlet UITableView *tbTimeline;
@property (assign, nonatomic) id<TimeLineDelegate>delegate;
- (IBAction)btActPressMenu:(id)sender;

@end
