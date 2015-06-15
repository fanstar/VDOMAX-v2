//
//  PreViewPhotoViewController.m
//  VDOMAXCHAT
//
//  Created by shadow on 23/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import "PreViewPhotoViewController.h"

@interface PreViewPhotoViewController ()

@end

@implementation PreViewPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    self.uiscroll.minimumZoomScale=1.0;
    self.uiscroll.maximumZoomScale=3.0;
    self.uiscroll.contentSize=CGSizeMake(1280, 960);
    self.uiscroll.delegate=self;
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//    
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgPreview;
}

//-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    [self.uiscroll zoomToRect:[self zoomRectForScrollView:scrollView withScale:1.0 withCenter:self.imgPreview.center] animated:YES];
//}
//
//- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
//    
//    CGRect zoomRect;
//    
//    // The zoom rect is in the content view's coordinates.
//    // At a zoom scale of 1.0, it would be the size of the
//    // imageScrollView's bounds.
//    // As the zoom scale decreases, so more content is visible,
//    // the size of the rect grows.
//    zoomRect.size.height = scrollView.frame.size.height / scale;
//    zoomRect.size.width  = scrollView.frame.size.width  / scale;
//    
//    // choose an origin so as to get the right center.
//    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
//    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
//    
//    return zoomRect;
//}



- (IBAction)btActClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
