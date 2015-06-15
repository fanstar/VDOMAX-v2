//
//  WritePostViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "WritePostViewController.h"

@interface WritePostViewController ()

@end

@implementation WritePostViewController
@synthesize currentpost;

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
    
    [self customNavBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.txtInputDesc becomeFirstResponder];
    
    switch (currentpost) {
        case WRITEPOST:
        {
            
        }
            break;
        case PHOTOPOST:
        {
            
        }
            break;
        case TATTOOPOST:
        {
            
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customNavBar{
    
    UIBarButtonItem * rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"โพสต์" style:UIBarButtonItemStyleDone target:self action:@selector(AddPost)];
    self.navigationItem.rightBarButtonItem = rightbutton;
    
    UIBarButtonItem * leftbutton = [[UIBarButtonItem alloc] initWithTitle:@"ยกเลิก" style:UIBarButtonItemStyleDone target:self action:@selector(CancelPost)];
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    self.navigationItem.title = @"เขียนข้อความ";
    
}

-(void)AddPost{
    
    //call service add post
    
    
    if (currentViewAdd != nil) {
        [currentViewAdd removeFromSuperview];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)CancelPost{
    if (currentViewAdd != nil) {
        [currentViewAdd removeFromSuperview];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btActMenuAddTattoo:(id)sender {
    [self AddToolView:self.uiviewAddSticker];
}

- (IBAction)btActMenuAddPhoto:(id)sender {
    [self AddToolView:self.uiviewAddPhoto];
}

- (IBAction)btActMenuAddVDO:(id)sender {
    [self AddToolView:self.uiviewAddVDO];
}

- (IBAction)btActMenuAddLink:(id)sender {
    [self AddToolView:self.uiviewAddLink];
}

- (IBAction)btActMenuAddLocation:(id)sender {
    NSLog(@"Add Location");
}

-(void)AddToolView:(UIView *) viewadd{
    
    if(viewadd == currentViewAdd)return;//not add exist view
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            
            [currentViewAdd removeFromSuperview];
            currentViewAdd = nil;
            
            //add subview
            keyboard = [[keyboard subviews] objectAtIndex:1];
            [keyboard addSubview:viewadd];
            currentViewAdd = viewadd;
          
        }
        
    }
}
- (IBAction)btActPost:(id)sender {
    
    [self AddPost];
}

- (IBAction)btActCancelPost:(id)sender {
    
    [self CancelPost];
}
@end
