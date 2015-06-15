//
//  OptionMenuViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/23/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "TattooViewController.h"
#define MENUWIDTH 40//50
#define MENUHEIGHT 30//40
#define MENUSTARTTAG 1000
#define PREVIEWWIDTH 64//89
#define PREVIEWHEIGHT 70//89
#define PREVIEWSTARTTAG 2000

@interface TattooViewController ()

@end

@implementation TattooViewController
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
    [self LoadDataTattooDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadDataTattooDefault{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"TATTOODEFAULT" ofType:@"plist"];
    NSDictionary *openDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //NSLog(@"openDict%@",openDict);
    dataTattooArr = [openDict objectForKey:@"TATTOOLIST"];
    
    [self SetupPreviewTatooMenuWithDict:dataTattooArr];
}

-(void)SetupPreviewTatooMenuWithDict:(NSArray *) menuarr{
    
    int i=0;
    self.uiscrollviewmenu.contentSize = CGSizeMake(MENUWIDTH * [menuarr count], self.uiscrollviewmenu.frame.size.height);
    for (NSDictionary * dict in menuarr) {
        
        CGRect rect = CGRectMake(MENUWIDTH * i, 0, MENUWIDTH, MENUHEIGHT);
        NSString * imagename = [NSString stringWithFormat:@"%@.png",[dict objectForKey:@"GROUPIMAGE"]];
        
        UIImageView * menuview = [[UIImageView alloc] initWithFrame:rect];
        menuview.image = [UIImage imageNamed:imagename];
        menuview.contentMode = UIViewContentModeScaleAspectFit;
        menuview.tag = MENUSTARTTAG + i;
        [self.uiscrollviewmenu addSubview:menuview];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapImageGesture:)];
        menuview.userInteractionEnabled = YES;
        [menuview addGestureRecognizer:tap];
        
        if(i==0){
            current_select_tatoogroup = menuview;
        }else{
            menuview.alpha = 0.4f;
        }
            
        
        
        i++;
    }
    
    
    
    
    //loadfirst page
    NSArray * dataarr = [[dataTattooArr objectAtIndex:0] objectForKey:@"ITEMARRAY"];
    [self LoadPreviewTatooAtItemDict:dataarr];
}

-(void)TapImageGesture:(UITapGestureRecognizer *) tap{
    
    UIImageView * menuselect = (UIImageView *)[tap view];
    
    if(current_select_tatoogroup != nil)current_select_tatoogroup.alpha = 0.4f;
    current_select_tatoogroup = menuselect;
    menuselect.alpha = 1.0f;

    int index = [menuselect tag]- MENUSTARTTAG;
    
    NSArray * dataarr = [[dataTattooArr objectAtIndex:index] objectForKey:@"ITEMARRAY"];
    
    [self LoadPreviewTatooAtItemDict:dataarr];
    
}

-(void)LoadPreviewTatooAtItemDict:(NSArray *) itemarray{
    
    currentTattooList = nil;
    currentTattooList = [itemarray copy];
    
    for (UIView * v in self.uiscrollviewpreview.subviews) {
        [v removeFromSuperview];
    }
    
    int numofitem = [itemarray count];
    int numofitemperrow = ceilf((float)(numofitem) / 2);
    
    self.uiscrollviewpreview.contentSize = CGSizeMake(PREVIEWWIDTH * numofitemperrow, self.uiscrollviewpreview.frame.size.height);
   
    
    int index=0;
    int x=0;
    int y=0;
    for (NSDictionary * dict in itemarray) {
        
        CGRect rect = CGRectMake(PREVIEWWIDTH * x, PREVIEWHEIGHT * y + (10*(y+1)), PREVIEWWIDTH, PREVIEWHEIGHT);
        NSString * imagename = [NSString stringWithFormat:@"%@.png",[dict objectForKey:@"TATTOONAME"]];
        
        UIImageView * preview = [[UIImageView alloc] initWithFrame:rect];
        preview.image = [UIImage imageNamed:imagename];
        preview.contentMode = UIViewContentModeScaleAspectFit;
        preview.tag = PREVIEWSTARTTAG + index;
        [self.uiscrollviewpreview addSubview:preview];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapImagePreviewGesture:)];
        preview.userInteractionEnabled = YES;
        [preview addGestureRecognizer:tap];
        
        index++;
        
        if (y==0) {
            y++;
        }else{
            y = 0;
            x++;
        }
    }

    
    
}

-(void)TapImagePreviewGesture:(UITapGestureRecognizer *) tap{
    
   
    //NSString * tattoocode = [tattooArr ObjectAtIndex:tap.tag];
    //NSString * tattoocode = @"tattoocodeselect";
    UIImageView * imvTattoo = (UIImageView *)[tap view];
    
//     NSLog(@"tag: %d",imvTattoo.tag);
//    NSLog(@"currentTattooList: %@",currentTattooList);
    
    NSDictionary * tattoodict = [currentTattooList objectAtIndex:imvTattoo.tag-PREVIEWSTARTTAG];
    [self.delegate TattooViewSelectAtTattooCode:tattoodict];
}



@end
