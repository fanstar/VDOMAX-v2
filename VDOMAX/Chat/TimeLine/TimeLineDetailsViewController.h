//
//  TimeLineDetailsViewController.h
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "UIButton+JSMessagesView.h"
#import "JSDismissiveTextView.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "TattooViewController.h"
#import "UIImageView+WebCache.h"

@protocol TimeLineDetatilsDelegate <NSObject>

-(void)TimeLineDelegateDidClose;

@end

@interface TimeLineDetailsViewController : UIViewController<UITextViewDelegate,JSDismissiveTextViewDelegate,UIScrollViewDelegate>{
    BOOL flagshowkeyboard;
    TattooViewController * tattooview;
    //UIScrollView * uiScrollViewContain;
}

@property (assign, nonatomic) id<TimeLineDetatilsDelegate>delegate;
@property (nonatomic) NSString * titlename;
@property (nonatomic) NSDictionary * datadict;
@property (strong, nonatomic) JSMessageInputView *inputToolBarView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *uiScrollViewContain;

@end
