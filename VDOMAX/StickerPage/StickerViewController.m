//
//  StiickerViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "StiickerViewController.h"

@interface StiickerViewController ()

@end

@implementation StiickerViewController

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
    
    NSMutableArray * tmparr0 = [[NSMutableArray alloc] init];
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (int i=0; i<20; i++) {
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"http://www.fordesigner.com/imguploads/Image/cjbc/zcool/png20080526/1211810004.png",@"IMAGEPATH",nil];
        
        [arr addObject:dict];
    }
    
    for (int i=0; i<20; i++) {
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"1",@"LABELNEWSTICKER",
                               @"http://www.fordesigner.com/imguploads/Image/cjbc/zcool/png20080526/1211810004.png",@"IMAGESTICKER",
                               @"http://www.fordesigner.com/imguploads/Image/cjbc/zcool/png20080526/1211810004.png",@"IMAGELABELSTICKER",
                               @"test company name0",@"COMPANYNAME",
                               @"MY TATTOO0",@"TATTOONAME",
                               @"0.99",@"TATTOOPRICE",
                               arr,@"STICKERGROUP",
                               nil];
        
        [tmparr0 addObject:dict];
    }
    
    topStickerList = tmparr0;
    
    NSMutableArray * tmparr1 = [[NSMutableArray alloc] init];
    
    for (int i=0; i<20; i++) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"1",@"LABELNEWSTICKER",
                               @"http://www.fordesigner.com/imguploads/Image/cjbc/zcool/png20080526/1211810004.png",@"IMAGESTICKER",
                               @"http://www.fordesigner.com/imguploads/Image/cjbc/zcool/png20080526/1211810004.png",@"IMAGELABELSTICKER",
                               @"test company name1",@"COMPANYNAME",
                               @"MY TATTOO",@"TATTOONAME1",
                               @"0.99",@"TATTOOPRICE",
                               arr,@"STICKERGROUP",
                               nil];
        
        [tmparr1 addObject:dict];
    }
    
    newStickerList = tmparr1;
    
    NSMutableArray * tmparr2 = [[NSMutableArray alloc] init];
    
    for (int i=0; i<20; i++) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"0",@"LABELNEWSTICKER",
                               @"http://www.fordesigner.com/imguploads/Image/cjbc/zcool/png20080526/1211810004.png",@"IMAGESTICKER",
                               @"http://www.fordesigner.com/imguploads/Image/cjbc/zcool/png20080526/1211810004.png",@"IMAGELABELSTICKER",
                               @"test company name2",@"COMPANYNAME",
                               @"MY TATTOO2",@"TATTOONAME",
                               @"0.99",@"TATTOOPRICE",
                               arr,@"STICKERGROUP",
                               nil];
        
        [tmparr2 addObject:dict];
    }
    eventStickerList = tmparr2;
    
    
    //set default
    tmpStickerList = [topStickerList copy];
    
    self.tbSticker.tableHeaderView = self.uiviewsegment;
    [self customNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customNavBar{
    
    UIBarButtonItem * rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(BackPress)];
    self.navigationItem.rightBarButtonItem = rightbutton;
    
//    UIBarButtonItem * leftbutton = [[UIBarButtonItem alloc] initWithTitle:@"Chat" style:UIBarButtonItemStyleDone target:self action:@selector(BackPress)];
//    self.navigationItem.leftBarButtonItem = leftbutton;
    
    self.navigationItem.title = @"Sticker";
    
}

-(void)BackPress{
//    [self.delegate ChatPageViewClosed];
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tmpStickerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StickerCell";
    StickerCell *cell = (StickerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSString *_nibFileCell = @"StickerCell_iPhone";
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:_nibFileCell owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        
    }
    
    
    NSString * urlProfileString = [[tmpStickerList objectAtIndex:indexPath.row] objectForKey:@"IMAGESTICKER"];
    [cell.imgSticker setImageWithURL:[NSURL URLWithString:urlProfileString] placeholderImage:[UIImage imageNamed:@""]];
    
    BOOL newLabel = [[[tmpStickerList objectAtIndex:indexPath.row] objectForKey:@"LABELNEWSTICKER"] boolValue];
    
    if (newLabel) {
        NSString * urlPostString = [[tmpStickerList objectAtIndex:indexPath.row] objectForKey:@"IMAGELABELSTICKER"];
        [cell.imgLabelSticker setImageWithURL:[NSURL URLWithString:urlPostString] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    cell.lbCompanyName.text = [[tmpStickerList objectAtIndex:indexPath.row] objectForKey:@"COMPANYNAME"];
    cell.lbTattooName.text = [[tmpStickerList objectAtIndex:indexPath.row] objectForKey:@"TATTOONAME"];
    cell.lbTattooPrice.text = [[tmpStickerList objectAtIndex:indexPath.row] objectForKey:@"TATTOOPRICE"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * nib_File = @"StickerDetailsViewController_iPhone";
    
    if (IS_DEVICE_MODEL_5) {
        nib_File = @"StickerDetailsViewController_iPhone5";
    }
    
    StickerDetailsViewController * stickerdetails = [[StickerDetailsViewController alloc] initWithNibName:nib_File bundle:nil];
    stickerdetails.datadict = [tmpStickerList objectAtIndex:indexPath.row] ;
    
    [self.navigationController pushViewController:stickerdetails animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (IBAction)btActSegment:(id)sender {
    
    UISegmentedControl * seg = (UISegmentedControl *)sender;
    
//    NSLog(@"Segment : %d",seg.selectedSegmentIndex);
    
    switch (seg.selectedSegmentIndex) {
        case 0://top
        {
            tmpStickerList = nil;
            tmpStickerList = [topStickerList copy];
            [self.tbSticker reloadData];
        }
            break;
        case 1://new
        {
            tmpStickerList = nil;
            tmpStickerList = [newStickerList copy];
            [self.tbSticker reloadData];
        }
            break;
        case 2://event
        {
            tmpStickerList = nil;
            tmpStickerList = [eventStickerList copy];
            [self.tbSticker reloadData];
        }
            break;
            
        default:
            break;
    }
}
@end
