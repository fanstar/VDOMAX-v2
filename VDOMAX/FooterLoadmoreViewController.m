//
//  FooterLoadmoreViewController.m
//  YooTube
//
//  Created by fanstar on 2/5/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "FooterLoadmoreViewController.h"

@interface FooterLoadmoreViewController ()

@end

@implementation FooterLoadmoreViewController
@synthesize delegate;

-(instancetype)initWithFrame:(CGRect)frame{

        self = [super initWithFrame:frame];
        if (self) {
            // Initialization code
            
            [self SetupView];
        }
        return self;

    
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.view.backgroundColor = [UIColor redColor];
//    
//    _progressloading = [[ UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    _progressloading.frame = CGRectMake(0, 0, 50, 50);
//    _progressloading.center = CGPointMake(self.view.frame.size.width*0.3f, self.view.frame.size.width*0.5f);
//    
//    
//    [self.view addSubview:_progressloading];
//    
//    
//    _lbLoadMore = [[UILabel alloc] initWithFrame:CGRectMake(_progressloading.frame.origin.x+_progressloading.frame.size.width+10.0f, _progressloading.frame.origin.y, self.view.frame.size.width-(_progressloading.frame.origin.y+_progressloading.frame.size.width), _progressloading.frame.size.height)];
//    _lbLoadMore.text = @"Release to load more...";
//    _lbLoadMore.textColor = [UIColor grayColor];
//    _lbLoadMore.textAlignment = NSTextAlignmentLeft;
//    _lbLoadMore.font = [UIFont systemFontOfSize:10.0f];
//    
//    [self.view addSubview:_lbLoadMore];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//    
//}


-(void)SetupView{
    self.backgroundColor = [UIColor redColor];
    
    _progressloading = [[ UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _progressloading.frame = CGRectMake(0, 0, 50, 50);
    _progressloading.center = CGPointMake(self.frame.size.width*0.3f, self.frame.size.height*0.5f);
    
    
    [self addSubview:_progressloading];
    
    
    _lbLoadMore = [[UILabel alloc] initWithFrame:CGRectMake(_progressloading.frame.origin.x+_progressloading.frame.size.width+10.0f, _progressloading.frame.origin.y, self.frame.size.width-(_progressloading.frame.origin.y+_progressloading.frame.size.width), _progressloading.frame.size.height)];
    _lbLoadMore.text = @"Release to load more...";
    _lbLoadMore.textColor = [UIColor whiteColor];
    _lbLoadMore.textAlignment = NSTextAlignmentLeft;
    _lbLoadMore.font = [UIFont systemFontOfSize:10.0f];
    
    [self addSubview:_lbLoadMore];
}

-(void)StartActivity{
    [_progressloading startAnimating];
    if (self.delegate) {
        [self.delegate didStartProgressActivity];
    }
}

-(void)StopActivity{
    [_progressloading stopAnimating];
    
    if (self.delegate) {
        [self.delegate didStopProgressActivity];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
