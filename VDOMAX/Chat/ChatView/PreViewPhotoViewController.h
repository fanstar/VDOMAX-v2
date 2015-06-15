//
//  PreViewPhotoViewController.h
//  VDOMAXCHAT
//
//  Created by shadow on 23/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreViewPhotoViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgPreview;
@property (weak, nonatomic) IBOutlet UIScrollView *uiscroll;

- (IBAction)btActClose:(id)sender;

@end
