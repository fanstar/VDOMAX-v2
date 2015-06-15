//
//  ConferenceGroupViewController.m
//  VDOMAX
//
//  Created by fanstar on 5/11/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "ConferenceGroupViewController.h"
#import "AppDelegate.h"

@interface ConferenceGroupViewController (){
    AppDelegate * app;
}

@end

@implementation ConferenceGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    contactList = [[NSMutableArray alloc] init];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self CustomNav];
    [self SetupScrollview];
    [self SetupFriendContactView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)SetupScrollview{
    
//    NSMutableArray * contactList = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"01-splash.png",@"ImageName",@"Name",@"NameContact", nil];
        
        [contactList addObject:dict];
    }


    int index=0;
    float offsetx = 0;
    float itemwidth = 80;
    for (NSDictionary * dt in contactList) {
        
        CGRect itemRect = CGRectMake(offsetx+(index*itemwidth), 5, itemwidth, itemwidth) ;
     
        ContactItemView * item = [[ContactItemView alloc] initWithFrame:itemRect];
        item.imvProfile.image = [UIImage imageNamed:[dt objectForKey:@"ImageName"]];
        item.lbName.text = [dt objectForKey:@"NameContact"];
        item.delegate = self;
        
        [_uiscrollview addSubview:item];
        
        index++;
    }

    _uiscrollview.contentSize = CGSizeMake(index*itemwidth, _uiscrollview.frame.size.height);

}


-(void)CustomNav{
    UIButton * btMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    btMenu.frame = CGRectMake(0, 0, 30, 30);
    //    [_btMenu setTitle:@"se" forState:UIControlStateNormal];
    [btMenu setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    //    [_btMenu setBackgroundColor:[UIColor redColor]];
    [btMenu addTarget:self action:@selector(didSelectButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:btMenu];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    UIButton * btCreateConference = [UIButton buttonWithType:UIButtonTypeCustom];
    btCreateConference.frame = CGRectMake(0, 0, 30, 30);
//    [btCreateConference setTitle:@"Create" forState:UIControlStateNormal];
    [btCreateConference setBackgroundImage:[UIImage imageNamed:@"t2.png"] forState:UIControlStateNormal];
    //    [_btMenu setBackgroundColor:[UIColor redColor]];
    [btCreateConference addTarget:self action:@selector(didSelectButtonCreateConference:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:btCreateConference];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    self.navigationItem.title = @"Create Conference";
}

-(void)didSelectButtonBack:(id) sender{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didSelectButtonCreateConference:(id) sender{
    conferenceCallingView = [[ConferenceCallingViewController alloc] init];
    conferenceCallingView.contactList = contactList;
    
    [app AppPopupOnWindowsViewWithView:conferenceCallingView.view];
}


-(void)SetupFriendContactView{
    
    float offsetY = _lbAddMember.frame.origin.y+_lbAddMember.frame.size.height;
    
    friendContactView = [[FriendContactViewController alloc] initWithNibName:@"FriendContactViewController" bundle:nil];
    
    friendContactView.view.frame = CGRectMake(0, offsetY, self.view.frame.size.width, self.view.frame.size.height-offsetY);
    
    [self.view addSubview:friendContactView.view];
}

#pragma mark - ContactItemDelegate
-(void)didSelectContactItem:(ContactItemView *)contactitem{
    
    for (ContactItemView * contact in contactList) {
        if (contactitem == contact) {
            NSLog(@"Found item:%@",contactitem);
        }
    }
}
@end
