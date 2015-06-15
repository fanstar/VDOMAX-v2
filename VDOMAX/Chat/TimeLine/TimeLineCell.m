//
//  TimeLineCell.m
//  VDOMAXCHAT
//
//  Created by yut on 8/23/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "TimeLineCell.h"

@implementation TimeLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
   [[self.imgBg layer] setCornerRadius:5];
    [[self.imgBg layer] setMasksToBounds:YES];
    
    [[self.imgProfile layer] setBorderWidth:1];
    [[self.imgProfile layer] setBorderColor:[[UIColor blackColor] CGColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

- (IBAction)btActLike:(id)sender {
}

- (IBAction)btActComment:(id)sender {
}

- (IBAction)btActLikeHeart:(id)sender {
}
@end
