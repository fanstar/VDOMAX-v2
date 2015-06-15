//
//  OptionMenuViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/23/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionMenuViewDelegate <NSObject>

-(void) OptionMenuViewDidSelectButtonTag:(int) buttontag;

@end

@interface OptionMenuViewController : UIViewController{
    //int current_tag_selected;
}
@property (assign, nonatomic) id<OptionMenuViewDelegate>delegate;


- (IBAction)btActPressButton:(id)sender;

@end
