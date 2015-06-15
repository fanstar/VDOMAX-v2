//
//  FirstViewController.m
//  VDOMAX
//
//  Created by fanstar on 1/13/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "MyTimelineViewController.h"
#import "AppDelegate.h"

static NSString *PostTableViewCellIdentifier = @"PostTableViewCell";

@interface MyTimelineViewController (){
    AppDelegate * app;
}

@end



@implementation MyTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = kBACKGROUNDCOLOR;
    
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
    
    [self RequestLoadTimelineDataUserID:6 WithToken:app.appToken Page:1 Perpage:10 type:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [app.myTabbar setHiddenCustom:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    /*
    float tabHeigh = app.myTabbar.tabBar.frame.size.height;
    
    if(app.hideTabbarFlag){
//        app.hideTabbarFlag = NO;
        [app.myTabbar setHiddenCustom:NO];
        
        [UIView animateWithDuration:0.25 animations:^{
            _tbPostView.frame = CGRectMake(_tbPostView.frame.origin.x, _tbPostView.frame.origin.y, _tbPostView.frame.size.width, _tbPostView.frame.size.height - tabHeigh );
        } completion:^(BOOL finished) {
        }];
        
    }else{
//        app.hideTabbarFlag = YES;
        [app.myTabbar setHiddenCustom:YES];
        [UIView animateWithDuration:0.25 animations:^{
            _tbPostView.frame = CGRectMake(_tbPostView.frame.origin.x, _tbPostView.frame.origin.y, _tbPostView.frame.size.width, originalFrameTablePost.size.height);
        } completion:^(BOOL finished) {
        }];
        
        
    }
    */
    
    [_tmpTextField resignFirstResponder];
    
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
    float myImageHeight = myBGTimeLineHeight*0.8f;
    int numoftab_seg = 6;
    
    float searchheight = 30.0f;

    
    //search button
    _btMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    _btMenu.frame = CGRectMake(offsetX, 20, searchheight, searchheight);
//    [_btMenu setTitle:@"se" forState:UIControlStateNormal];
//    [_btMenu setBackgroundColor:[UIColor redColor]];
    [_btMenu setBackgroundImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    [_btMenu addTarget:self action:@selector(didSelectButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_btMenu];
    
    
    _tmpTextField = [[UITextField alloc] initWithFrame:CGRectMake(_btMenu.frame.origin.x + _btMenu.frame.size.width + shiftX, offsetY, self.view.frame.size.width*0.6f, searchheight)];
    _tmpTextField.borderStyle = UITextBorderStyleRoundedRect;
    _tmpTextField.delegate = self;
    _tmpTextField.placeholder = @"search";
    [self.view addSubview:_tmpTextField];
   
    
//    _searchBarDisplayControl = [[UISearchDisplayController alloc] initWithSearchBar:_searcbar contentsController:self];
//    _searchBarDisplayControl.delegate = self;
//    [self.view addSubview:_searcbar];
    
    
    
    
    //search button
    _btSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    _btSearch.frame = CGRectMake(_tmpTextField.frame.origin.x + _tmpTextField.frame.size.width - searchheight, offsetY, searchheight, searchheight);
//    [_btSearch setTitle:@"se" forState:UIControlStateNormal];
//    [_btSearch setBackgroundColor:[UIColor redColor]];
    [_btSearch setBackgroundImage:[UIImage imageNamed:@"search-icon.png"] forState:UIControlStateNormal];
    [_btSearch addTarget:self action:@selector(didSelectButtonSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btSearch];
    
    //filters button
//    _btFilter = [UIButton buttonWithType:UIButtonTypeCustom];
//    float offsetx_filter = _tmpTextField.frame.origin.x + _tmpTextField.frame.size.width + shiftX;
//    
//    _btFilter.frame = CGRectMake( offsetx_filter, offsetY, self.view.frame.size.width - offsetx_filter-shiftX, searchheight);
//    [_btFilter setTitle:@"filters" forState:UIControlStateNormal];
//    [_btFilter setBackgroundColor:[UIColor redColor]];
//    
//    [self.view addSubview:_btFilter];
    
    //Image BG Profile
    _myImageBGProfile = [[UIImageView alloc] initWithFrame:CGRectMake( 0, offsetY + shiftX + searchheight, self.view.frame.size.width, myBGTimeLineHeight)];
//    myImageBGProfile.backgroundColor = [UIColor grayColor];
    _myImageBGProfile.image = [UIImage imageNamed:@"cover_image.png"];
    
    [self.view addSubview:_myImageBGProfile];
    
    //Image BG Profile
    _myImageOverayBG = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, myBGTimeLineHeight)];
    //    myImageBGProfile.backgroundColor = [UIColor grayColor];
    _myImageOverayBG.image = [UIImage imageNamed:@"overlay-cover-image.png"];
//    _myImageOverayBG.alpha = 0.3f;
    
    [_myImageBGProfile addSubview:_myImageOverayBG];
    
    
    //Write Post button
    UIButton * _btWritePost = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btWritePost.frame = CGRectMake( offsetX,_myImageBGProfile.frame.origin.y + _myImageBGProfile.frame.size.height + shiftX +searchheight, (self.view.frame.size.width - (shiftX * 3.0f))/2.0f, searchheight);
    [_btWritePost setTitle:@"Write Post" forState:UIControlStateNormal];
    [_btWritePost setBackgroundImage:[UIImage imageNamed:@"writepost-button.png"] forState:UIControlStateNormal];
    _btWritePost.titleLabel.font = [UIFont systemFontOfSize:12.0f] ;
    [_btWritePost addTarget:self action:@selector(didSelectButtonWritePost:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btWritePost];
    
    //Live Yourself button
    UIButton * _btLive = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btLive.frame = CGRectMake( _btWritePost.frame.origin.x + _btWritePost.frame.size.width + shiftX, _btWritePost.frame.origin.y, (self.view.frame.size.width - (shiftX * 3.0f))/2.0f, searchheight);
    [_btLive setTitle:@"Live Yourself" forState:UIControlStateNormal];
    [_btLive setBackgroundImage:[UIImage imageNamed:@"live-button.png"] forState:UIControlStateNormal];
    _btLive.titleLabel.font = [UIFont systemFontOfSize:12.0f] ;
    [_btLive addTarget:self action:@selector(didSelectButtonFilters:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btLive];
    
    
    //created record live
    UIImageView * recIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7, 14, 14)];
    recIcon.contentMode = UIViewContentModeScaleAspectFit;
    recIcon.image = [UIImage imageNamed:@"record-icon.png"];//[self ResizeImage:[UIImage imageNamed:@"record-icon.png"] AspectFitNewSize:CGSizeMake(14, 14)];
    [_btLive addSubview:recIcon];
    
    
    //My Image Profile
    UIImageView * myImageProfile = [[UIImageView alloc] initWithFrame:CGRectMake( shiftX,_myImageBGProfile.frame.origin.y  + (myBGTimeLineHeight-myImageHeight)/2.0f, myImageHeight, myImageHeight)];
    myImageProfile.backgroundColor = [UIColor grayColor];
    myImageProfile.layer.cornerRadius = myImageProfile.frame.size.width/2.0f;
    myImageProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    myImageProfile.layer.borderWidth = 1.0f;
    [myImageProfile.layer setMasksToBounds:YES];
    myImageProfile.contentMode = UIViewContentModeScaleAspectFit;
    
    myImageProfile.image = [UIImage imageNamed:@"01-splash.png"];
    
    [self.view addSubview:myImageProfile];
    
    UITapGestureRecognizer * tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageProfile:)];
    
    myImageProfile.userInteractionEnabled = YES;
    [myImageProfile addGestureRecognizer:tapProfile];
    
    //add Segment Tab
    
    NSArray * subMenuAarray = [[NSArray alloc] initWithObjects:@"Posts",@"Followers",@"Following",@"Friends",@"Loves",@"Groups", nil];
    
    numoftab_seg = (int)[subMenuAarray count];
    
    float offsetX_seg = 0;//myImageProfile.frame.origin.x + myImageProfile.frame.size.width;
    float offsetY_seg = _myImageBGProfile.frame.origin.y + _myImageBGProfile.frame.size.height;
//    float seg_width = (self.view.frame.size.width - (myImageProfile.frame.origin.x + myImageProfile.frame.size.width) ) / (float)numoftab_seg;
    float seg_width = self.view.frame.size.width / (float)numoftab_seg;
    for (int i=0; i<numoftab_seg; i++) {//6 tab
        
        //Live Yourself button
        btSegmnetTab[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btSegmnetTab[i].frame = CGRectMake( offsetX_seg + seg_width*i, offsetY_seg, seg_width, searchheight);
        [btSegmnetTab[i] setTitle:subMenuAarray[i] forState:UIControlStateNormal];
        btSegmnetTab[i].titleLabel.font = [UIFont systemFontOfSize:10.0f];
        btSegmnetTab[i].titleLabel.minimumFontSize = 8.0f;
        btSegmnetTab[i].titleLabel.adjustsFontSizeToFitWidth = YES;
        [btSegmnetTab[i] setBackgroundColor:kBACKGROUNDMENUCOLOR];
        btSegmnetTab[i].contentEdgeInsets = UIEdgeInsetsMake(12, 0, 0, 0);
        [btSegmnetTab[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btSegmnetTab[i] addTarget:self action:@selector(didSelectSubMenu:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) {
            [btSegmnetTab[i] setBackgroundColor:kBACKGROUNDMENUSELECTCOLOR];
        }
//        if (i%2 == 0) {
//            [_btSegmnetTab setBackgroundColor:[UIColor orangeColor]];
//        }else{
//            [_btSegmnetTab setBackgroundColor:[UIColor blueColor]];
//        }
        btSegmnetTab[i].tag = i;
        
        [btSegmnetTab[i] addTarget:self action:@selector(didSelectButtonSegment:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btSegmnetTab[i]];
        
        
        lbSegmnetTab[i]=[[UILabel alloc]initWithFrame:CGRectMake(btSegmnetTab[i].frame.origin.x, btSegmnetTab[i].frame.origin.y-btSegmnetTab[i].frame.size.height*0.2f, btSegmnetTab[i].frame.size.width, btSegmnetTab[i].frame.size.height)];
        lbSegmnetTab[i].numberOfLines=1;
        lbSegmnetTab[i].font = [UIFont systemFontOfSize:12.0f];
        lbSegmnetTab[i].minimumFontSize = 8.0f;
        lbSegmnetTab[i].adjustsFontSizeToFitWidth = YES;
        lbSegmnetTab[i].textAlignment = NSTextAlignmentCenter;
        lbSegmnetTab[i].lineBreakMode=NSLineBreakByTruncatingTail;
        lbSegmnetTab[i].backgroundColor=[UIColor clearColor];
        lbSegmnetTab[i].text = @"0";
        [self.view addSubview:lbSegmnetTab[i]];
    }
    
    
    //set table view
    _tbPostView = [[UITableView alloc] initWithFrame:CGRectMake(offsetX, _btWritePost.frame.origin.y+_btWritePost.frame.size.height + shiftX, self.view.frame.size.width - (shiftX * 2.0f), self.view.frame.size.height - (_btWritePost.frame.origin.y + _btWritePost.frame.size.height + shiftX)  )];
    _tbPostView.dataSource = self;
    _tbPostView.delegate = self;
    _tbPostView.backgroundColor = [UIColor clearColor];
    _tbPostView.showsHorizontalScrollIndicator = NO;
    _tbPostView.showsVerticalScrollIndicator = NO;
    _tbPostView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbPostView.allowsSelection = NO;
    [_tbPostView registerClass:[PostTableViewCell class] forCellReuseIdentifier:PostTableViewCellIdentifier];
    
    [_tbPostView layer].cornerRadius = 5.0f;
    [[_tbPostView layer] setMasksToBounds:YES];
    
    originalFrameTablePost = _tbPostView.frame;
    
    [self.view addSubview:_tbPostView];
    
}

-(void)didSelectSubMenu:(UIButton *) button{
    
    for (int i=0;i<6;i++) {
        if (i == button.tag) {
            [btSegmnetTab[i] setBackgroundColor:kBACKGROUNDMENUSELECTCOLOR];
        }else{
            [btSegmnetTab[i] setBackgroundColor:kBACKGROUNDMENUCOLOR];
        }
    }
    
    NSLog(@"select button tag : %ld",(long)button.tag);
    
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


#pragma mark - TableDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataPostArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PostTableViewCell *cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PostTableViewCellIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        cell=[[PostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostTableViewCellIdentifier];
//        cell.delegate = self;
    }
    
    cell.delegate = self;
    
    // Load data
    NSDictionary *dataDict = _dataPostArr[indexPath.row];
    // Sample image
//    UIImage *image = [UIImage imageNamed:@"icon1.png"];
    [cell AdjustCellWithWidth:tableView.frame.size.width WithDataDict:dataDict];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    PostTableViewCell * cell = (PostTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    return [cell GetCellHeight] ;
    
    PostTableViewCell * cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostTableViewCellIdentifier];
    
     NSDictionary *dataDict = _dataPostArr[indexPath.row];
    [cell AdjustCellWithWidth:tableView.frame.size.width WithDataDict:dataDict];
     float cellheight = [cell GetCellHeight];

    return cellheight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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


-(void)RequestLoadTimelineDataUserID:(int ) userid WithToken:(NSString *) token  Page:(int) page Perpage:(int) perpage type:(NSString * ) type{
    
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
        
        //        NSLog(@"data: %@", responseObject);
        
        if ([responseObject objectForKey:@"posts"]) {
            NSArray * posts = [responseObject objectForKey:@"posts"];
            if ([posts count] >0) {
                
                
                for (NSDictionary * dt in posts) {
                    [_dataPostArr addObject:dt];
                }
                
                
                //refresh
                [_tbPostView reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error description]);
    }];
    
}

@end
