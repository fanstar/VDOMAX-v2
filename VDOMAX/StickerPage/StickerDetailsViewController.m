//
//  StickerDetailsViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "StickerDetailsViewController.h"
#define STICKERPREVIEWWIDTH 80
#define STICKERPREVIEWHEIGHT 80
#define NUMPERROW 4

@interface StickerDetailsViewController ()

@end

@implementation StickerDetailsViewController
@synthesize datadict;

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
    
    self.navigationItem.title = @"Details";
    
    
    if ([self.datadict count]>0) {
        [self SetupPreviewTatooMenuWithDict:[self.datadict objectForKey:@"STICKERGROUP"]];
        NSString * imagepath = [self.datadict objectForKey:@"IMAGESTICKER"];
        [self.imgStickerGroup setImageWithURL:[NSURL URLWithString:imagepath]];
        self.lbCompanyName.text = [self.datadict objectForKey:@"COMPANYNAME"];
        self.lbStickerName.text = [self.datadict objectForKey:@"TATTOONAME"];
        self.lbPrice.text = [self.datadict objectForKey:@"TATTOOPRICE"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btActDownLoad:(id)sender {
}

-(void)SetupPreviewTatooMenuWithDict:(NSArray *) menuarr{
    
    int numofitem = [menuarr count];
    int row = ceilf((float)(numofitem) / NUMPERROW);
    
    int x=0;
    int y=0;
    self.uiscrollviewpreview.contentSize = CGSizeMake(self.uiscrollviewpreview.frame.size.width,STICKERPREVIEWHEIGHT * row);
    for (NSDictionary * dict in menuarr) {
        
        CGRect rect = CGRectMake(STICKERPREVIEWWIDTH * x, STICKERPREVIEWHEIGHT * y, STICKERPREVIEWWIDTH, STICKERPREVIEWHEIGHT);
        NSString * imagepath = [dict objectForKey:@"IMAGEPATH"];
        
        UIImageView * menuview = [[UIImageView alloc] initWithFrame:rect];
        [menuview setImageWithURL:[NSURL URLWithString:imagepath]];
        menuview.contentMode = UIViewContentModeScaleAspectFit;
        [self.uiscrollviewpreview addSubview:menuview];
        
        if (x>=NUMPERROW-1) {
            x = 0;
            y++;
        }else{
            x++;
        }
    }
}


@end
