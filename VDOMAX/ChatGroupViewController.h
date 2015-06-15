//
//  ConferenceGroupViewController.h
//  VDOMAX
//
//  Created by fanstar on 5/11/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactItemView.h"
#import "FriendContactViewController.h"
#import "ConferenceCallingViewController.h"

@interface ConferenceGroupViewController : UIViewController<ContactItemDelegate>{
    FriendContactViewController * friendContactView;
    ConferenceCallingViewController * conferenceCallingView;
    NSMutableArray * contactList;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uiscrollview;
@property (weak, nonatomic) IBOutlet UILabel *lbAddMember;

@end
