//
//  StickerDetailsViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface StickerDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgStickerGroup;
@property (weak, nonatomic) IBOutlet UILabel *lbStickerName;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UIScrollView *uiscrollviewpreview;
@property (nonatomic) NSDictionary * datadict;


- (IBAction)btActDownLoad:(id)sender;
@end
