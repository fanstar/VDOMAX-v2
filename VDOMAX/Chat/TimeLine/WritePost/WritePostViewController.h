//
//  WritePostViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"



@interface WritePostViewController : UIViewController{
    UIView * currentViewAdd;
}
@property (weak, nonatomic) IBOutlet UITextView *txtInputDesc;
@property (strong, nonatomic) IBOutlet UIView *uiviewAddSticker;
@property (strong, nonatomic) IBOutlet UIView *uiviewAddPhoto;
@property (strong, nonatomic) IBOutlet UIView *uiviewAddVDO;
@property (strong, nonatomic) IBOutlet UIView *uiviewAddLink;
@property (assign, nonatomic) TYPEPOST currentpost;


- (IBAction)btActMenuAddTattoo:(id)sender;
- (IBAction)btActMenuAddPhoto:(id)sender;
- (IBAction)btActMenuAddVDO:(id)sender;
- (IBAction)btActMenuAddLink:(id)sender;
- (IBAction)btActMenuAddLocation:(id)sender;

- (IBAction)btActPost:(id)sender;
- (IBAction)btActCancelPost:(id)sender;


@end
