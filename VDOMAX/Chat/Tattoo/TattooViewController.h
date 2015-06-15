//
//  TattooViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/23/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TattooViewDelegate <NSObject>

-(void)TattooViewSelectAtTattooCode:(NSDictionary *) tattoodict;

@end


@interface TattooViewController : UIViewController{
    NSArray * dataTattooArr;
    NSArray * currentTattooList;
    
    UIImageView * current_select_tatoogroup;
}
@property (assign, nonatomic) id<TattooViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *uiscrollviewpreview;
@property (weak, nonatomic) IBOutlet UIScrollView *uiscrollviewmenu;

@end
