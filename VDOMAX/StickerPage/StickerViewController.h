//
//  StiickerViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerCell.h"
#import "UIImageView+WebCache.h"
#import "StickerDetailsViewController.h"
#import "Global.h"



@interface StiickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSArray * topStickerList;
    NSArray * newStickerList;
    NSArray * eventStickerList;
    
    NSArray * tmpStickerList;
}

@property (weak, nonatomic) IBOutlet UITableView *tbSticker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *uiviewsegment;

- (IBAction)btActSegment:(id)sender;
@end
