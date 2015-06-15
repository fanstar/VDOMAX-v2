//
//  FirstViewController.m
//  VDOMAX
//
//  Created by fanstar on 1/13/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "VideoViewController.h"
#import "AppDelegate.h"

static NSString *PostTableViewCellIdentifier = @"VideoTableViewCell";

@interface VideoViewController (){
    AppDelegate * app;
}

@end



@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = kBACKGROUNDCOLOR;//[UIColor colorWithWhite:0.9 alpha:1];
    
    //load data test
    _dataPostArr = [NSMutableArray array];
    
    // Load sample data into the array
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
//    [_dataPostArr addObjectsFromArray:[NSArray arrayWithContentsOfFile:filePath]];
    
    app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [app.myTabbar setHiddenCustom:YES];
    
    
    
//    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars=NO;
//    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self AddMainUICustom];
    [self CreateDropdownPopularList];
    
    [self RequestLoadDataVideoUserID:6 withToken:app.appToken Page:1 Perpage:20 Type:@"clip"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [app.myTabbar setHiddenCustom:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self checkHideKeyBoard];
    
}

-(void)AddMainUICustom{
    
//    _searcbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 30)];
////    _searcbar.hidden = YES;
//    
//    [_searcbar setBackgroundImage:[UIImage new]];
    
    float offsetY= 20;
    float shiftX =  5.0f;
    float offsetX = shiftX;//(_tmpTextField.frame.origin.x + _tmpTextField.frame.size.width) - (_tmpTextField.frame.size.height/2.0f);
    float myBGTimeLineHeight = self.view.frame.size.width * 0.3f;
    float myImageHeight = 60.0f;
    int numoftab_seg = 6;
    
    float searchheight = 30.0f;

    
    //search button
    _btMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    _btMenu.frame = CGRectMake(offsetX, 20, searchheight, searchheight);
//    [_btMenu setTitle:@"se" forState:UIControlStateNormal];
    [_btMenu setBackgroundImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
//    [_btMenu setBackgroundColor:[UIColor redColor]];
    [_btMenu addTarget:self action:@selector(didSelectButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_btMenu];
    
    
    _tmpTextField = [[UITextField alloc] initWithFrame:CGRectMake(_btMenu.frame.origin.x + _btMenu.frame.size.width + shiftX, offsetY, self.view.frame.size.width*0.6f, searchheight)];
    _tmpTextField.borderStyle = UITextBorderStyleRoundedRect;
    _tmpTextField.delegate = self;
    _tmpTextField.placeholder = @"search";
    [self.view addSubview:_tmpTextField];
   

    //search button
    _btSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    _btSearch.frame = CGRectMake(_tmpTextField.frame.origin.x + _tmpTextField.frame.size.width - searchheight, offsetY, searchheight, searchheight);
    [_btSearch setBackgroundImage:[UIImage imageNamed:@"search-icon.png"] forState:UIControlStateNormal];
//    [_btSearch setBackgroundColor:[UIColor redColor]];
    [_btSearch addTarget:self action:@selector(didSelectButtonSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btSearch];
    
//    //filters button
//    _btFilter = [UIButton buttonWithType:UIButtonTypeCustom];
//    float offsetx_filter = _tmpTextField.frame.origin.x + _tmpTextField.frame.size.width + shiftX;
//    
//    _btFilter.frame = CGRectMake( offsetx_filter, offsetY, self.view.frame.size.width - offsetx_filter-shiftX, searchheight);
//    [_btFilter setTitle:@"filters" forState:UIControlStateNormal];
//    [_btFilter setBackgroundColor:[UIColor redColor]];
//    
//    [self.view addSubview:_btFilter];
    
    //set table view
    _tbPostView = [[UITableView alloc] initWithFrame:CGRectMake(offsetX, _tmpTextField.frame.origin.y+_tmpTextField.frame.size.height + shiftX, self.view.frame.size.width - (shiftX * 2.0f), self.view.frame.size.height - (_tmpTextField.frame.origin.y + _tmpTextField.frame.size.height + shiftX)  )];
    _tbPostView.dataSource = self;
    _tbPostView.delegate = self;
    _tbPostView.backgroundColor = [UIColor clearColor];
    _tbPostView.showsHorizontalScrollIndicator = NO;
    _tbPostView.showsVerticalScrollIndicator = NO;
    _tbPostView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbPostView.allowsSelection = NO;
//    _tbPostView.backgroundColor = [UIColor redColor];
    _tbPostView.separatorColor = [UIColor whiteColor];
    [_tbPostView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:PostTableViewCellIdentifier];
    
    [_tbPostView layer].cornerRadius = 5.0f;
    [[_tbPostView layer] setMasksToBounds:YES];
    
    originalFrameTablePost = _tbPostView.frame;
    
    [self.view addSubview:_tbPostView];
    
//    [self RequestLoadDataVideoUserID:6 withToken:app.appToken Page:1 Perpage:20 Type:@"clip"];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    showSearchKeyBoard = YES;
    
//    _searcbar.hidden = NO;
//    [_searcbar becomeFirstResponder];
}

-(void)checkHideKeyBoard{
    if (showSearchKeyBoard) {
        showSearchKeyBoard = NO;
        [_tmpTextField resignFirstResponder];

    }
}

#pragma mar - Private Method
-(void)didSelectButtonWritePost:(id) sender{
    
}

-(void)didSelectButtonLive:(id) sender{
    
}

-(void)didSelectGesture:(UITapGestureRecognizer *) tap{
    
}

-(void)didSelectButtonMenu:(id) sender{
    
    [app.sideBar show];
    
}

-(void)didSelectButtonFilters:(id) sender{
    
}

-(void)didSelectButtonSearch:(id) sender{
    
    if ([_tmpTextField.text isEqualToString:@""]) {
        
    }else{
        //call search service
        
    }
    
    [self checkHideKeyBoard];
}

-(void)didSelectButtonSegment:(id) sender{
    
    UIButton * bt = (UIButton *) sender;
    
    switch (bt.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
    
}


-(void)didSelectImageProfile:(UITapGestureRecognizer *) tap {
    
    [self openProfileActionSheet:nil];
    
}


-(void)openProfileActionSheet:(id)sender {
    
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Change Avatar",@"Edi Profile",@"Change Cover", @"Reposition Cover",@"Cancel"] buttonStyle:JGActionSheetButtonStyleDefault];
//    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
    
    for (int i=0; i<(int)[section1.buttons count];i++) {
        [section1 setButtonStyle:JGActionSheetButtonStyleOverlay forButtonAtIndex:i];
    }
    
    NSArray *sections = @[section1];
    
    JGActionSheet *actionSheet = [JGActionSheet actionSheetWithSections:sections];
    
    [actionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
        //select
        
//        NSLog(@"select item: %d", (int)indexPath.row);
        
        [self actionSheetClickedButtonAtIndex:indexPath.row];
        
    }];
    
    [actionSheet showInView:self.view animated:YES];
}

-(void)actionSheetClickedButtonAtIndex:(NSInteger)buttonIndex {
    //coordinates for the place we want to display
   
    switch (buttonIndex) {
        case 0://Change Avatar
        {
            
        }
            break;
        case 1://Edi Profile
        {
            
        }
            break;
        case 2://Change Cover
        {
            
        }
            break;
        case 3://Reposition Cover
        {
            
        }
            break;
        case 4://cancel
        {
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - IGLDropDownMenuDelegate

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    if (index >=0 && index != currentItemSelectIndex) {
        
        currentItemSelectIndex = (int)index;
        
        IGLDropDownItem *item = dropDownMenu.dropDownItems[index];
        
        
        //        [self RequestLoadYoutubeForMusicWithToken:@"" WithMusicLanguage:_musicLang CountryCode:_countryCode TopChart:YES MusicCountryQuery:_musicCountryQuery withTabIndex:currentTabSelect];
    }
    //    self.textLabel.text = [NSString stringWithFormat:@"Selected: %@", item.text];
}
-(void)CreateDropdownPopularList{
    
    NSDictionary * icon1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"all-icon",@"ImageFileName",@"All",@"Caption",nil];
    NSDictionary * icon2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"text-icon",@"ImageFileName",@"Text",@"Caption",nil];
    NSDictionary * icon3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"camera-icon",@"ImageFileName",@"Camera",@"Caption",nil];
    NSDictionary * icon4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"video-icon",@"ImageFileName",@"Video",@"Caption",nil];
    NSDictionary * icon5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"youtube-icon",@"ImageFileName",@"Yotube",@"Caption",nil];
    NSDictionary * icon6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"music-icon",@"ImageFileName",@"Music",@"Caption",nil];
    NSDictionary * icon7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"place-icon",@"ImageFileName",@"Place",@"Caption",nil];
    
    
    NSArray * arrayImageName = [[NSMutableArray alloc] initWithObjects:icon1,icon2,icon3,icon4,icon5,icon6,icon7, nil];
    
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayImageName.count; i++) {
        
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        UIImage * resizeImage = [self ResizeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[arrayImageName[i] objectForKey:@"ImageFileName"]]] AspectFitNewSize:CGSizeMake(29, 29)];
        [item setIconImage:resizeImage];
        [item setText:[arrayImageName[i] objectForKey:@"Caption"]];
        [dropdownItems addObject:item];
    }
    
    dropDownMenu = [[IGLDropDownMenu alloc] init];
    dropDownMenu.dropDownItems = dropdownItems;
    dropDownMenu.paddingLeft = 0;
    //    [self.dropDownMenu setFrame:CGRectMake(60, 100, 200, 45)];
    [dropDownMenu setFrame:CGRectMake(self.view.frame.size.width-85, 20, 80, 58)];
    dropDownMenu.delegate = self;
    dropDownMenu.type = IGLDropDownMenuTypeStack;
    dropDownMenu.gutterY = 0;
    
    [dropDownMenu reloadView];
    
    [self.view addSubview:dropDownMenu];
    
    dropDownMenu.menuButton.textLabel.text = @"ALL";
    dropDownMenu.menuButton.iconImageView.image = [UIImage imageNamed:@"all-icon.png"];
    dropDownMenu.menuButton.bgView.backgroundColor = [UIColor clearColor];
    //    dropDownMenu.menuButton.bgView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0f].CGColor;
    //    dropDownMenu.menuButton.bgView.layer.borderWidth = 2.0f;
    //    dropDownMenu.hidden = YES;
}



#pragma mark - self method
-(UIImage *)ResizeImage:(UIImage *)image NewSize:(CGSize )newsize{
    
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // Create a new image from current context
    UIImage * imageresize = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    return imageresize;
}

-(UIImage *)ResizeImage:(UIImage *)image AspectFitNewSize:(CGSize )newsize{
    float ratio;
    float maxscale = newsize.width>newsize.height?newsize.width:newsize.height;
    if (image.size.width > image.size.height) {
        ratio = (float)(image.size.width)/maxscale;
    }else{
        ratio = (float)(image.size.height)/maxscale;
    }
    return [self ResizeImage:image NewSize:CGSizeMake(image.size.width/ratio, image.size.height/ratio)];
}



#pragma mark - TableDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataPostArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    VideoTableViewCell *cell = (VideoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PostTableViewCellIdentifier forIndexPath:indexPath];
//    
//    if(cell==nil){
        VideoTableViewCell *cell=[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostTableViewCellIdentifier WithSize:CGSizeMake(tableView.frame.size.width, 100.0f)];
//        cell.delegate = self;
//    }

    cell.delegate = self;
    
    // Load data
    NSDictionary *dataDict = _dataPostArr[indexPath.row];
    cell.datadict = dataDict;
    
    [cell UpdateViewWithSize:CGSizeMake(tableView.frame.size.width, 100.0f)];
    [cell CellSetUpdataForDataDict:dataDict];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    PostTableViewCell * cell = (PostTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    return [cell GetCellHeight] ;
    
//    PostTableViewCell * cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostTableViewCellIdentifier];
//    
//     NSDictionary *dataDict = _dataPostArr[indexPath.row];
//    [cell AdjustCellWithWidth:tableView.frame.size.width WithDataDict:dataDict];
//     float cellheight = [cell GetCellHeight];
    
    float cellheight = 105.0f;

    return cellheight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - PostTableCellDelegate
-(void)didSelectImagePostCell:(PostTableViewCell *)cell withDataDict:(NSDictionary *)dict{
    
    ShowImageViewController *showImageController = [[ShowImageViewController alloc] init];
    
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:showImageController];
    
    if (IS_OS8_OR_LATER) {
        showImageController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        showImageController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }else{
        showImageController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }

    [self presentViewController:showImageController animated:YES completion:nil];
    
    
//    [self addChildViewController:showImageController];
    [self.view addSubview:showImageController.view];
}


#pragma mark - TableView Scroll Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    NSLog(@"begin drag");
    prevPoint = scrollView.contentOffset;
    
    [self checkHideKeyBoard];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"end drag");
    
    CGPoint curPoint = scrollView.contentOffset;
    
    if (curPoint.y - prevPoint.y < 0) {//scroll down
        directionScrollDown = YES;
    }else {//scroll up
        directionScrollDown = NO;
    }
    
    
    if (app) {
        if (app.hideTabbarFlag && directionScrollDown) {
            [app.myTabbar setHiddenCustom:NO];
        }
    }
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    NSLog(@"end Decelerating");
    
    if (app) {
        if (!app.hideTabbarFlag && !directionScrollDown) {
            [app.myTabbar setHiddenCustom:YES];
        }
    }
}

#pragma mark - VideoViewCellDelegate
-(void)videoDidSelectImageThumbWithDataDict:(NSDictionary *) dict{
    
    videofullVC = [[VideoFullViewController alloc] init];
    videofullVC.datadict = dict;
    
//    [self presentViewController:videofullVC animated:YES completion:nil];
    [self.view addSubview:videofullVC.view];
    
}



-(void)RequestLoadDataVideoUserID:(int ) userid withToken:(NSString *) token Page:(int) page Perpage:(int) perpage Type:(NSString *) type{
    
    enableCallService = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * urlString = [NSString stringWithFormat:@"%@/1.0/posts/home_timeline/%d",kIPAPIVDOMAX,userid];
    NSString* encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    
    //header param
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-Auth-Token"];
    
    //body param
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",page],@"page",
                             [NSString stringWithFormat:@"%d",perpage],@"per_page",
                             [NSString stringWithFormat:@"%@",type],@"type",
                             nil];
    
    
    [manager POST:encodedUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        enableCallService = NO;
        //        NSLog(@"data: %@", responseObject);
        
        if ([responseObject objectForKey:@"posts"]) {
            NSArray * posts = [responseObject objectForKey:@"posts"];
            if ([posts count] >0) {
                
                
                for (NSDictionary * dt in posts) {
                    [_dataPostArr addObject:dt];
                }
                
                
                //refresh
                _tbPostView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                [_tbPostView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        enableCallService = NO;
    }];
    
}




@end
