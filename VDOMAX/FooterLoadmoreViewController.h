//
//  FooterLoadmoreViewController.h
//  YooTube
//
//  Created by fanstar on 2/5/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterViewDelegate <NSObject>

-(void)didStartProgressActivity;
-(void)didStopProgressActivity;

@end

@interface FooterLoadmoreViewController : UIView//UIViewController
@property (assign) id<FooterViewDelegate>delegate;
@property (retain, nonatomic) UIActivityIndicatorView * progressloading;
@property (retain, nonatomic) UILabel * lbLoadMore;



-(void)StartActivity;
-(void)StopActivity;
@end
