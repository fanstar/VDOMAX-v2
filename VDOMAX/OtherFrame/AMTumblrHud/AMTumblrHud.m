//
// Created by Mustafin Askar on 22/05/2014.
// Copyright (c) 2014 Asich. All rights reserved.
//

#import "AMTumblrHud.h"

#define kShowHideAnimateDuration 0.2


@implementation AMTumblrHud {
    NSMutableArray *hudRects;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.alpha = 0;
        
        _lbWaiting = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-150)/2.0f,self.frame.size.height * 0.5f,150,30)];
        _lbWaiting.text = @"Data Loading...";
        _lbWaiting.font = [UIFont systemFontOfSize:13.0f];
        _lbWaiting.textAlignment = NSTextAlignmentCenter;
        //    lbTitlePlay.adjustsFontSizeToFitWidth = YES;
//        lbWaiting.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        _lbWaiting.textColor = [UIColor whiteColor];
        
        [self addSubview:_lbWaiting];
//        _btCancelWaiting.center = CGPointMake(self.frame.size.width/2.0f, frame.size.height * 0.65f);
        
        //add button canncel
        _btCancelWaiting = [UIButton buttonWithType:UIButtonTypeCustom];
        _btCancelWaiting.frame = CGRectMake((frame.size.width-100)/2.0f,_lbWaiting.frame.origin.y + 2*_lbWaiting.frame.size.height, 100, 25);
        [_btCancelWaiting setTitle:@"Cancel" forState:UIControlStateNormal];
        [_btCancelWaiting addTarget:self action:@selector(didSelectCancel) forControlEvents:UIControlEventTouchUpInside];
        _btCancelWaiting.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self Custombutton:_btCancelWaiting];
        
        [self addSubview:_btCancelWaiting];
        
        _btCancelWaiting.alpha = 0.0f;
//        _lbWaiting.alpha = 0.0f;
        
//        _btCancelWaiting.center = CGPointMake(self.frame.size.width/2.0f, lbWaiting.center.y+lbWaiting.frame.size.height/2.0f);
    }
    return self;
}

-(void)didSelectCancel{
    
    if (self.delegate) {
        [self.delegate didSelectCancelLoadingFromAMThublHud:self];
    }
}


-(void)Custombutton:(UIButton *) bt{
    [bt setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.9]];
    bt.layer.cornerRadius = 5.0f;
    bt.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    bt.layer.borderWidth = 1.0f;
    bt.showsTouchWhenHighlighted = YES;
}

#pragma mark - config UI

- (void)configUI {
    self.backgroundColor = [UIColor clearColor];
    
    float itemHudWidth = 15.0f;
    float shiftX = 5.0f;
    float offsetX = (self.frame.size.width - (3*itemHudWidth + 2*shiftX))/2.0f;

    UIView *rect1 = [self drawRectAtPosition:CGPointMake(offsetX, 0)];//0
    UIView *rect2 = [self drawRectAtPosition:CGPointMake(rect1.frame.origin.x+itemHudWidth+shiftX, 0)];//20
    UIView *rect3 = [self drawRectAtPosition:CGPointMake(rect2.frame.origin.x+itemHudWidth+shiftX, 0)];//40

    [self addSubview:rect1];
    [self addSubview:rect2];
    [self addSubview:rect3];

    [self doAnimateCycleWithRects:@[rect1, rect2, rect3]];
}

#pragma mark - animation

- (void)doAnimateCycleWithRects:(NSArray *)rects {
    __weak typeof(self) wSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.25 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf animateRect:rects[0] withDuration:0.25];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.25 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wSelf animateRect:rects[1] withDuration:0.2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wSelf animateRect:rects[2] withDuration:0.15];
            });
        });
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf doAnimateCycleWithRects:rects];
    });
}

- (void)animateRect:(UIView *)rect withDuration:(NSTimeInterval)duration {
    [rect setAutoresizingMask:UIViewAutoresizingFlexibleHeight];

    [UIView animateWithDuration:duration
                     animations:^{
                         rect.alpha = 1;
                         rect.transform = CGAffineTransformMakeScale(1, 1.3);
                     } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration
                         animations:^{
                             rect.alpha = 0.5;
                             rect.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL f) {
        }];
    }];
}

#pragma mark - drawing

- (UIView *)drawRectAtPosition:(CGPoint)positionPoint {
    UIView *rect = [[UIView alloc] init];
    CGRect rectFrame;
    rectFrame.size.width = 15;
    rectFrame.size.height = 16.5;
    rectFrame.origin.x = positionPoint.x;
    rectFrame.origin.y = self.frame.size.height *0.45f;//0;
    rect.frame = rectFrame;
    rect.backgroundColor = [UIColor redColor];
    rect.alpha = 0.5;
    rect.layer.cornerRadius = 3;

    if (hudRects == nil) {
        hudRects = [[NSMutableArray alloc] init];
    }
    [hudRects addObject:rect];

    return rect;
}

#pragma mark - Setters

- (void)setHudColor:(UIColor *)hudColor {
    for (UIView *rect in hudRects) {
        rect.backgroundColor = hudColor;
    }
}

#pragma mark -
#pragma mark - show / hide

- (void)hide {
    [UIView animateWithDuration:kShowHideAnimateDuration animations:^{
        self.alpha = 0;
        _btCancelWaiting.alpha = 0.0f;
//        _lbWaiting.alpha = 0.0f;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
        self.alpha = 0.0f;
        _btCancelWaiting.alpha = 0.0f;
//        _lbWaiting.alpha = 0.0f;
        
        _isShowProgressing = NO;
        
    }];
}


- (void)showWithButtonCancelAnimated:(BOOL)animated {
    
    _lbWaiting.text = @"Info Waiting...";
    
    if (animated) {
        [UIView animateWithDuration:kShowHideAnimateDuration animations:^{
            self.alpha = 1;
            _btCancelWaiting.alpha = 1.0f;
//            _lbWaiting.alpha = 1.0f;
        }];
    } else {
        self.alpha = 1;
        _btCancelWaiting.alpha = 1.0f;
//        _lbWaiting.alpha = 1.0f;
        
        _isShowProgressing = YES;
        
    }
}


- (void)showAnimated:(BOOL)animated {
    
    _lbWaiting.text = @"Data Loading...";
    
    if (animated) {
        [UIView animateWithDuration:kShowHideAnimateDuration animations:^{
            self.alpha = 1;
        }];
    } else {
        self.alpha = 1;
        
        _isShowProgressing = YES;
        
    }
}

- (void)showAnimated:(BOOL)animated withTitle:(NSString *) title{
    
    _lbWaiting.text = title;
    
    if (animated) {
        [UIView animateWithDuration:kShowHideAnimateDuration animations:^{
            self.alpha = 1;
        }];
    } else {
        self.alpha = 1;
        
        _isShowProgressing = YES;
        
    }
}

- (void)dealloc {
    hudRects = nil;
}

@end