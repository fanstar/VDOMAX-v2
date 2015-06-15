//
// Created by Mustafin Askar on 22/05/2014.
// Copyright (c) 2014 Asich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AMTumblrHud;

@protocol AMTumblHudDelegate <NSObject>

-(void)didSelectCancelLoadingFromAMThublHud:(AMTumblrHud *) hud;

@end
@interface AMTumblrHud : UIView
@property (assign) id<AMTumblHudDelegate>delegate;
@property (nonatomic, strong) UIColor *hudColor;
@property (nonatomic, retain) UILabel * lbWatingInfo;
@property (nonatomic, retain) UIButton * btCancelWaiting;
@property (nonatomic, retain) UILabel * lbWaiting;
@property (assign) BOOL isShowProgressing;

-(void)showWithButtonCancelAnimated:(BOOL)animated;
- (void)showAnimated:(BOOL)animated withTitle:(NSString *) title;
-(void)showAnimated:(BOOL)animated;
-(void)hide;

@end