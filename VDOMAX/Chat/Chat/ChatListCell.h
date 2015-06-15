//
//  FriendListCell.h
//  VDOMAXCHAT
//
//  Created by yut on 8/22/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

@interface ChatListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;

@property (assign, nonatomic) int NotReadCount;

@property (weak, nonatomic) IBOutlet UIImageView *imvLabelBG;
@property (weak, nonatomic) IBOutlet UILabel *lbNotRead;
@property (retain, nonatomic) JSBadgeView * bubview;

@end
