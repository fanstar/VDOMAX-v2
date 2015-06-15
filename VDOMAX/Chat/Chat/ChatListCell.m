//
//  FriendListCell.m
//  VDOMAXCHAT
//
//  Created by yut on 8/22/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "ChatListCell.h"

@implementation ChatListCell
@synthesize NotReadCount;
@synthesize bubview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    
    
    if (self.NotReadCount > 0) {
        self.lbNotRead.hidden = NO;
        self.lbNotRead.text = [NSString stringWithFormat:@"%d",self.NotReadCount];
        
        self.imvLabelBG.hidden = NO;
        
        
        if (bubview == nil) {
             self.bubview = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentCenterRight];
        }
        
        [self.bubview setBadgeText:[NSString stringWithFormat:@"%d",self.NotReadCount]];
        
    }else{
        self.lbNotRead.hidden = YES;
        self.lbNotRead.text = [NSString stringWithFormat:@"%d",0];
        
        self.imvLabelBG.hidden = YES;
        
        
        if (bubview == nil) {
            self.bubview = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentCenterRight];
        }
        
        [self.bubview setBadgeText:@""];
    }
    
    
}

@end
