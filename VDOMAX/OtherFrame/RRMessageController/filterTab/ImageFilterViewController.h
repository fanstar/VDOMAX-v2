//
//  TextViewController.h
//  tincam
//
//  Created by yut on 7/16/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"

@protocol ImageFilterViewDelegate <NSObject>

-(void)ImageFilterViewSelectFilterIndex:(int ) filterindex;
-(void)ImageFilterCallSaveViewSelectFilterIndex:(int ) filterindex Name:(NSString *) name;

@end

@interface ImageFilterViewController : UIViewController<UIGestureRecognizerDelegate>{
    NSArray * FilterList;
    
    NSMutableArray * FilterCreateList;
    
    int count;
    
    float frameX;
    float frameY;
    float shiftitem;
    float font_size;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uiscrollview;
@property (assign, nonatomic) id<ImageFilterViewDelegate>delegate;
@property (retain, nonatomic) UIImage * imageforcreateshape;
@end
