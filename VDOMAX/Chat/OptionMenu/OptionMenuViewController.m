//
//  OptionMenuViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/23/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "OptionMenuViewController.h"


@interface OptionMenuViewController ()

@end

@implementation OptionMenuViewController
@synthesize delegate;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btActPressButton:(id)sender {
   
    
    [self.delegate OptionMenuViewDidSelectButtonTag:(int)[sender tag]];
    
    /*
    switch ([sender tag]) {
        case 0://Gallery
        {
            
        }
            break;
        case 1://Camera
        {
            
        }
            break;
        case 2://VDO
        {
            
        }
            break;
        case 3://Share
        {
            
        }
            break;
        case 4://Sound
        {
            
        }
            break;
        case 5://Contact
        {
            
        }
            break;
            
        default:
            break;
    }
     */
}
@end
