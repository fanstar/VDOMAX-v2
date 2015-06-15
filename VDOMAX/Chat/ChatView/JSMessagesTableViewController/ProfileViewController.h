//
//  ProfileViewController.h
//  VDOMAXCHAT
//
//  Created by shadow on 22/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (retain, nonatomic) UIImage * imageProfile;
@property (retain, nonatomic) NSString * strNameProfile;
@property (retain, nonatomic) NSString * strURLProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgvProfile;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileURL;


@end
