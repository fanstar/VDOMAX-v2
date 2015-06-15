//
//  StickerCell_iPhone.h
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgSticker;
@property (weak, nonatomic) IBOutlet UIImageView *imgLabelSticker;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lbTattooName;
@property (weak, nonatomic) IBOutlet UILabel *lbTattooPrice;

@end
