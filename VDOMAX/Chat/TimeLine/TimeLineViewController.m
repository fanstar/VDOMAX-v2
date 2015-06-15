//
//  TimeLineViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/23/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "TimeLineViewController.h"

@interface TimeLineViewController ()

@end

@implementation TimeLineViewController
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
    dataTimeline = [[NSMutableArray alloc] init];
    
    NSMutableArray * arrLike = [[NSMutableArray alloc] init];
    NSMutableArray * arrComment = [[NSMutableArray alloc] init];

    for (int i=0; i<20; i++) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"yut1",@"USERNAMELIKE",
                               @"20-08 10:10",@"DATETIMELIKE",
                               @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"IMAGEPROFILE",
                               nil];
        
        [arrLike addObject:dict];
    }
    
    for (int i=0; i<20; i++) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"yut1",@"USERNAMECOMMENT",
                               @"20-08 10:10",@"COMMENTDATETIME",
                               @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"IMAGEPROFILE",
                               @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"IMAGEPOSTPATH",
                               @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"TATTOOCODE",
                               @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"TATTOOIMAGEPATH",
                               @"test description test description test description test description test description\n test description",@"COMMENTDESCRIPTION",
                               [NSString stringWithFormat:@"%d",i%2],@"FLAGCOMMENTTYPE",
                               nil];
        
        [arrComment addObject:dict];
    }
    
    for (int i=0; i<20; i++) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"yut1",@"USERNAME",
                               @"20-08 10:10",@"DATETIME",
                               @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"IMAGEPROFILE",
                               @"http://preview.turbosquid.com/Preview/Content_2009_07_26__08_54_47/People-Group2.jpge8ee92b8-c42a-4e4a-9ed0-dd6b801461b9Larger.jpg",@"IMAGEPOSTPATH",
                               [NSString stringWithFormat:@"%d",i%3],@"POSTIMAGETYPE",
                               @"test description test description test description test description test description\n test description",@"DESCRIPTIONPOST",
                               @"3",@"NUMOFLIKE",
                               @"10",@"NUMOFCOMMENT",
                               arrLike,@"LIKELIST",
                               arrComment,@"COMMENTLIST",
                               nil];
        
        [dataTimeline addObject:dict];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataTimeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimeLineCell_Normal";
    TimeLineCell *cell = (TimeLineCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSString *_nibFileCell = @"TimeLineCell_Normal_iPhone";
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:_nibFileCell owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        
    }
    
    
    NSString * urlProfileString = [[dataTimeline objectAtIndex:indexPath.row] objectForKey:@"IMAGEPROFILE"];
    [cell.imgProfile setImageWithURL:[NSURL URLWithString:urlProfileString] placeholderImage:[UIImage imageNamed:@""]];
    
    NSString * urlPostString = [[dataTimeline objectAtIndex:indexPath.row] objectForKey:@"IMAGEPOSTPATH"];
    [cell.imgPost setImageWithURL:[NSURL URLWithString:urlPostString] placeholderImage:[UIImage imageNamed:@""]];
    
    cell.lbUserName.text = [[dataTimeline objectAtIndex:indexPath.row] objectForKey:@"USERNAME"];
    cell.lbDateTime.text = [[dataTimeline objectAtIndex:indexPath.row] objectForKey:@"DATETIME"];
    cell.txtviewDesc.text = [[dataTimeline objectAtIndex:indexPath.row] objectForKey:@"DESCRIPTIONPOST"];
    cell.lbNumOfLike.text = [[dataTimeline objectAtIndex:indexPath.row] objectForKey:@"NUMOFLIKE"];
    cell.lbNumOfComment.text = [[dataTimeline objectAtIndex:indexPath.row] objectForKey:@"NUMOFCOMMENT"];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate TimeLineViewControl:self DidSelectIndexPath:indexPath withDict:[dataTimeline objectAtIndex:indexPath.row]];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 394;
}


- (IBAction)btActPressMenu:(id)sender {
    
    switch ([sender tag]) {
        case 0://0 write
        {
            WritePostViewController * writevc =[[WritePostViewController alloc] initWithNibName:@"WritePostViewController_iPhone5" bundle:nil];
            writevc.currentpost = WRITEPOST;
            
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:writevc];
            
            UIViewController * main = (UIViewController *) self.delegate;
            
            [main presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1://1 photo
        {
            WritePostViewController * writevc =[[WritePostViewController alloc] initWithNibName:@"WritePostViewController_iPhone5" bundle:nil];
            writevc.currentpost = PHOTOPOST;
            
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:writevc];
            
            UIViewController * main = (UIViewController *) self.delegate;
            
            [main presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2://2 tattoo
        {
            WritePostViewController * writevc =[[WritePostViewController alloc] initWithNibName:@"WritePostViewController_iPhone5" bundle:nil];
            writevc.currentpost = TATTOOPOST;
            
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:writevc];
            
            UIViewController * main = (UIViewController *) self.delegate;
            
            [main presentViewController:nav animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


-(void)sendRequestUserTimeline{
    
    //current_connect = ENDDAYOFFERSCONNECT;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?action=gettimeline",kIPAPIServiceAddress]];
    ASIFormDataRequest *requestData = [ASIFormDataRequest requestWithURL:url];
    [requestData setDelegate:self];
    //[requestData setTimeOutSeconds:360];
    
    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"0bf5b74d1cd9d149efb2e118858a40ba"] forKey:@"tokenid"];
    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"home"] forKey:@"app"];
    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"all"] forKey:@"get"];
    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"All"] forKey:@"filter"];
    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"20"] forKey:@"startPoint"];
    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"Most Recent"] forKey:@"sort"];
    [requestData addPostValue:[NSString stringWithFormat:@"%@", @"1"] forKey:@"page"];
    
    [requestData startAsynchronous];
    
    
    AppDelegate * app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    
    UIViewController * vc = app.window.rootViewController;
    
    
    //Start Progress
    HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    [vc.view addSubview:HUD];
    
    HUD.delegate = self ;
    HUD.labelText=@"loading";
    [HUD show:YES];
    
    //{"status":1,"msg":"Login is successful.","tokenid":"50807c8c09201f207db39d2f04cf526c"}
    
}

#pragma mark - ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
//    NSLog(@"requestFinished : %@", [request responseString]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *jsonObject = (NSDictionary *)[parser objectWithString:[request responseString]];
    
//    NSLog(@"data: %@",jsonObject);
    
    int status = [[jsonObject objectForKey:@"status"] intValue];
    
    /*
    if (status == 1) {//login
        
        
        NSDictionary * datadict = (NSDictionary *)[jsonObject objectForKey:@"data"];
        if ([datadict count] >0) {
            
            NSArray * onlineuser = (NSArray *)[datadict objectForKey:@"onlines"];
            
            if ([onlineuser count] > 0) {
                
                [dataTimeline removeAllObjects];
                
                for (NSDictionary * dt in onlineuser) {
                    [dataTimeline addObject:dt];
                }
                
                //refresh table
                [self.tbTimeline reloadData];
            }
        }
        
    }else{
        
        NSString * msg = [jsonObject objectForKey:@"msg"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    */
    //trun off progress
    [HUD hide:YES];
    
    
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed : %@", [request responseString]);
    
    //trun off progress
    [HUD hide:YES];
    
    //[soundPlay stop];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check your internet connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}



@end
