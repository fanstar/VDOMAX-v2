//
//  ChannelFullViewController.h
//  VDOMAX
//
//  Created by fanstar on 1/20/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ChannelFullViewController : UIViewController{
    
}
@property (strong,nonatomic) UIImageView *  imvProfile;
@property (strong,nonatomic) UIImageView *  imvThumb;
@property (strong,nonatomic) UILabel *  lbName;
@property (strong,nonatomic) UIButton *  btFollow;
@property (strong,nonatomic) UIButton *  btDone;
@property (retain,nonatomic) NSDictionary * dict;
@end
