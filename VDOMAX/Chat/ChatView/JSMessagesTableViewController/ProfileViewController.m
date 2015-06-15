//
//  ProfileViewController.m
//  VDOMAXCHAT
//
//  Created by shadow on 22/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    self.imgvProfile.image = self.imageProfile;
    self.profileName.text = self.strNameProfile;
    self.profileURL.text = self.strURLProfile;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
