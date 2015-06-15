//
//  TimeLineCell.h
//  VDOMAXCHAT
//
//  Created by yut on 8/23/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TimeLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgPost;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbDateTime;
@property (weak, nonatomic) IBOutlet UITextView *txtviewDesc;
@property (weak, nonatomic) IBOutlet UILabel *lbNumOfLike;
@property (weak, nonatomic) IBOutlet UILabel *lbNumOfComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;

- (IBAction)btActLike:(id)sender;
- (IBAction)btActComment:(id)sender;

- (IBAction)btActLikeHeart:(id)sender;
@end
