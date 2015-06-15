//
//  GenViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "GenViewController.h"

@interface GenViewController ()

@end

@implementation GenViewController

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

-(UIView *)GetViewCellFromDict:(NSDictionary *)datadict{
    
    //set my profile title
    
    //set image or tattoo, if has
    
    //set description, if has
    
    
    //set like button and comment button
    
    //display like people
    
    //display comment object
    //1. desccription only
    //2. description + tattoo
    
    return self.view;
}



@end
