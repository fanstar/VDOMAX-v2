//
//  FirstViewController.m
//  VDOMAX
//
//  Created by fanstar on 1/13/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "TimelineViewController.h"
#import "AppDelegate.h"

//static NSString *PostTableViewCellIdentifier = @"PostTableViewCell";

@interface TimelineViewController (){
    AppDelegate * app;
}

@end



@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = kBACKGROUNDCOLOR;
    
    //load data test
//    _dataPostArr = [NSMutableArray array];
//    currentPage = 1;
//    currentNumPerpage = 20;
    
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
    
//    [self CreateButtonDone];
    
//    [self CallRefreshData];
}
//-(void)CreateButtonDone{
//    _btDone = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btDone.frame = CGRectMake(self.view.frame.size.width-60, 20, 60, 30);
//    [_btDone setTitle:@"Done" forState:UIControlStateNormal];
// 
//    [self Custombutton:_btDone];
//    _btDone.hidden = YES;
//    
//    [self.view addSubview:_btDone];
//}
//
//-(void)Custombutton:(UIButton *) bt{
//    [bt setBackgroundColor:[UIColor clearColor]];
//    //    bt.layer.cornerRadius = 2.0f;
//    bt.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.1].CGColor;
//    bt.layer.borderWidth = 1.0f;
//}
//
//-(void)didSelectDoneComment{
//    _btDone.hidden = YES;
//    [commentView.view removeFromSuperview];
//}

//-(void)CallRefreshData{
//    
//    
//    
////    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
////    int userid = [[userDef objectForKey:@"USERID"] intValue];
//    
////    if (app.userData.userid > 0) {
////        if (![app ValidNSStringIsNull:app.userData.userToken]) {
////            [self RequestLoadTimelineDataUserID:app.userData.userid WithToken:app.userData.userToken Page:currentPage Perpage:currentNumPerpage type:@""];
////        }else{
//////            NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
//////            NSString * token = [userDef objectForKey:@"APPTOKEN"];
////            if ([app ValidNSStringIsNull:app.userData.userToken]) {
////                [self RequestLoadTimelineDataUserID:app.userData.userid WithToken:app.userData.userToken Page:currentPage Perpage:currentNumPerpage type:@""];
////            }
////        }
////    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [app.myTabbar setHiddenCustom:YES];
}
#pragma mark - IGLDropDownMenuDelegate

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    if (index >=0 && index != currentItemSelectIndex) {
        
        currentItemSelectIndex = (int)index;
        
//        IGLDropDownItem *item_ = dropDownMenu.dropDownItems[index];
        current_typesearch = @"";
        
        if (index == 0) {//all
            current_typesearch = @"";
        }else if (index == 1) {//text
            current_typesearch = @"";
        }else if (index == 2) {//camera
            current_typesearch = @"photo";
        }else if (index == 3) {//video
            current_typesearch = @"clip";
        }else if (index == 4) {//youtube
            current_typesearch = @"youtube";
        }else if (index == 5) {//music
            current_typesearch = @"soundcloud";
        }else if (index == 6) {//place
            current_typesearch = @"";
        }
        
        //reset
        currentPage = 1;
        refreshData = YES;

        [app showMainHud];
//        [self RequestLoadTimelineDataUserID:app.userData.userid WithToken:app.userData.userToken Page:currentPage Perpage:currentNumPerpage type:current_typesearch];
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
    
    dropDown_Menu = [[IGLDropDownMenu alloc] init];
    dropDown_Menu.dropDownItems = dropdownItems;
    dropDown_Menu.paddingLeft = 0;
    //    [self.dropDownMenu setFrame:CGRectMake(60, 100, 200, 45)];
    [dropDown_Menu setFrame:CGRectMake(self.view.frame.size.width-85, 20, 80, 58)];
    dropDown_Menu.delegate = self;
    dropDown_Menu.type = IGLDropDownMenuTypeStack;
    dropDown_Menu.gutterY = 0;
    
    [dropDown_Menu reloadView];
    
    [self.view addSubview:dropDown_Menu];
    
    dropDown_Menu.menuButton.textLabel.text = @"ALL";
    dropDown_Menu.menuButton.iconImageView.image = [UIImage imageNamed:@"all-icon.png"];
    dropDown_Menu.menuButton.bgView.backgroundColor = [UIColor clearColor];
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


#pragma mark - self method

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
   
    
//    _searchBarDisplayControl = [[UISearchDisplayController alloc] initWithSearchBar:_searcbar contentsController:self];
//    _searchBarDisplayControl.delegate = self;
//    [self.view addSubview:_searcbar];
    
    
    
    
    //search button
    _btSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    _btSearch.frame = CGRectMake(_tmpTextField.frame.origin.x + _tmpTextField.frame.size.width - searchheight, offsetY, searchheight, searchheight);
//    [_btSearch setTitle:@"se" forState:UIControlStateNormal];
    [_btSearch setBackgroundImage:[UIImage imageNamed:@"search-icon.png"] forState:UIControlStateNormal];
//    [_btSearch setBackgroundColor:[UIColor redColor]];
    [_btSearch addTarget:self action:@selector(didSelectButtonSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btSearch];
    
    //filters button
//    _btFilter = [UIButton buttonWithType:UIButtonTypeCustom];
//    float offsetx_filter = _tmpTextField.frame.origin.x + _tmpTextField.frame.size.width + shiftX;
    
//    _btFilter.frame = CGRectMake( offsetx_filter, offsetY, self.view.frame.size.width - offsetx_filter-shiftX, searchheight);
////    [_btFilter setTitle:@"filters" forState:UIControlStateNormal];
//    [_btFilter setBackgroundImage:[UIImage imageNamed:@"btFilter.png"] forState:UIControlStateNormal];
////    [_btFilter setBackgroundColor:[UIColor redColor]];
//    
//    [self.view addSubview:_btFilter];
    
    //Write Post button
    UIButton * _btWritePost = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btWritePost.frame = CGRectMake( offsetX,offsetY + shiftX + searchheight, (self.view.frame.size.width - (shiftX * 3.0f))/2.0f, searchheight);
    [_btWritePost setTitle:@"Write Post" forState:UIControlStateNormal];
    [_btWritePost setBackgroundImage:[UIImage imageNamed:@"writepost-button.png"] forState:UIControlStateNormal];
    _btWritePost.titleLabel.font = [UIFont systemFontOfSize:12.0f] ;
//    [_btWritePost setBackgroundColor:[UIColor redColor]];
    [_btWritePost addTarget:self action:@selector(didSelectButtonWritePost:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btWritePost];
    
    //Live Yourself button
    UIButton * _btLive = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btLive.frame = CGRectMake( _btWritePost.frame.origin.x + _btWritePost.frame.size.width + shiftX, _btWritePost.frame.origin.y, (self.view.frame.size.width - (shiftX * 3.0f))/2.0f, searchheight);
    [_btLive setTitle:@"Live Yourself" forState:UIControlStateNormal];
    [_btLive setBackgroundImage:[UIImage imageNamed:@"live-button.png"] forState:UIControlStateNormal];
    _btLive.titleLabel.font = [UIFont systemFontOfSize:12.0f] ;
//    [_btLive setBackgroundColor:[UIColor redColor]];
    [_btLive addTarget:self action:@selector(didSelectButtonLive:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btLive];
    
    UIImageView * recIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7, 14, 14)];
    recIcon.contentMode = UIViewContentModeScaleAspectFit;
    recIcon.image = [UIImage imageNamed:@"record-icon.png"];//[self ResizeImage:[UIImage imageNamed:@"record-icon.png"] AspectFitNewSize:CGSizeMake(14, 14)];
    [_btLive addSubview:recIcon];
    
    
    CGRect tbRect = CGRectMake(0, _btWritePost.frame.origin.y+_btWritePost.frame.size.height + shiftX, self.view.frame.size.width , self.view.frame.size.height - (_btWritePost.frame.origin.y + _btWritePost.frame.size.height + shiftX)  );
    
    NSString * urlString = [NSString stringWithFormat:@"%@/1.0/posts/home_timeline/%d",kIPAPIVDOMAX,app.userData.userid];
    
    _tbPost = [[PostTableViewController alloc] init];
    _tbPost.delegate = self;
    _tbPost.navigationToMyTimeline = YES; //enable navigate to my profile first time
    _tbPost.typesearch = @"";//all
    _tbPost.urlStringSearch = urlString;
    _tbPost.userData_currentCall = app.userData;
    _tbPost.view.frame = tbRect;
    
    [self.view addSubview:_tbPost.view];
    
    //set table view
//    _tbPostView = [[UITableView alloc] initWithFrame:CGRectMake(offsetX, _btWritePost.frame.origin.y+_btWritePost.frame.size.height + shiftX, self.view.frame.size.width - (shiftX * 2.0f), self.view.frame.size.height - (_btWritePost.frame.origin.y + _btWritePost.frame.size.height + shiftX)  )];
//    _tbPostView.dataSource = self;
//    _tbPostView.delegate = self;
//    _tbPostView.backgroundColor = [UIColor clearColor];//kCELLCOLOR;
//    _tbPostView.showsHorizontalScrollIndicator = NO;
//    _tbPostView.showsVerticalScrollIndicator = NO;
//    _tbPostView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tbPostView.allowsSelection = NO;
////    [_tbPostView registerClass:[PostTableViewCell class] forCellReuseIdentifier:PostTableViewCellIdentifier];
//    
//    [_tbPostView layer].cornerRadius = 5.0f;
//    [[_tbPostView layer] setMasksToBounds:YES];
    
    
//    originalFrameTablePost = _tbPostView.frame;
//    
//    [self.view addSubview:_tbPostView];
//    
//    footerLoadmore = [[FooterLoadmoreViewController alloc] initWithFrame:CGRectMake(0, 0, _tbPostView.frame.size.width, 55)];
//    [footerLoadmore layer].cornerRadius = 5.0f;
//    [[footerLoadmore layer] setMasksToBounds:YES];
//    
//    _tbPostView.tableFooterView = footerLoadmore;
}

#pragma mark - PostTableDelegate
-(void)PostTableViewScrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self checkHideKeyBoard];
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
    
    [self newMessagePost];
    
}

-(void)didSelectButtonLive:(id) sender{
    
    LiveMySelfViewController * livemyself = [[LiveMySelfViewController alloc] initWithNibName:@"LiveMySelfViewController" bundle:nil];
    livemyself.urlStreaming = @"rtmp://150.107.31.6:1935/live/yutjung";
    
    [app AppPushViewContoller:livemyself];
    
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

- (void) newMessagePost {
    RRSendMessageViewController *controller = [[RRSendMessageViewController alloc] init];
    controller.numberPhoto = 5;
    controller.numberOfVideo = 1;
    
    [controller presentController:self blockCompletion:^(RRMessageModel *model, BOOL isCancel) {
        if (isCancel == true) {
//            self.message.text = @"";
        }
        else {
//            self.message.text = model.text;
        }
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
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
    
    [actionSheet showInView:[app AppGetMainRootViewController].view animated:YES];
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


/*

#pragma mark - TableDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataPostArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostTableViewCell *cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PostTableViewCellIdentifier];
    if(cell==nil){
        NSArray * cellArray = [[NSBundle mainBundle] loadNibNamed:PostTableViewCellIdentifier owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        
    }
    
    PostDataModel * dtModel =  _dataPostArr[indexPath.row];
    NSLog(@"User at:%@",dtModel.userData.avatarURL);
    cell.delegate = self;
    cell.currentIndexPath = [indexPath copy];
    cell.datapost = dtModel;
    [cell updateCellWithDataModel:dtModel];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSDictionary * dict = _dataPostArr[indexPath.row];
//     NSString * textDesc =  ([[dict objectForKey:@"text"] isKindOfClass:[NSNull class]])?@"":[dict objectForKey:@"text"];
    PostDataModel * dtModel =  _dataPostArr[indexPath.row];

    if ([dtModel.postDescription isEqualToString:@""]) {
        if ([dtModel.postMediaType isEqualToString:@"text"]) {
            return 100;
        }else{
            if (IS_DEVICE_MODEL_6Plus) {
                return 418;
            }else if(IS_DEVICE_MODEL_6){
                return 393;
            }
            else{//ip4,ip5
                return 358;
            }
        }
    }else{
        if ([dtModel.postMediaType isEqualToString:@"text"]) {
            return 180;
        }else{
            if(IS_DEVICE_MODEL_6Plus){
                return 468;
            }else if(IS_DEVICE_MODEL_6){
                return 428;
            }else{//ip4,ip5
                return 395;
            }

        }
        
    }
}

//-(BOOL )CheckTextOnlyForDict:(NSDictionary *) dict{
//    
//    if (![[dict objectForKey:@"media"] isKindOfClass:[NSNull class]]) {//or Photo << intpu
//        return NO;
//        
//    }else if (![[dict objectForKey:@"youtube"] isKindOfClass:[NSNull class]]) {//youtube << - input
//        return NO;
//        
//    }else if (![[dict objectForKey:@"clip"] isKindOfClass:[NSNull class]]) { //<<clip  << - input
//        return NO;
//        
//    }else if (![[dict objectForKey:@"soundcloud"] isKindOfClass:[NSNull class]]) {//or soundcloud <<- input
//        return NO;
//        
//    }
//
//    return YES;
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >=[_dataPostArr count]-1 && enableLoadmore && indexPath.row>=currentNumPerpage-1) {
        
        currentPage++;
        [self RequestLoadTimelineDataUserID:app.userData.userid WithToken:app.userData.userToken Page:currentPage Perpage:currentNumPerpage type:current_typesearch];
    }
}

#pragma mark - PostTableCellDelegate

-(void)didSelectCommentFromPostCell:(PostTableViewCell *)cell{
    
//    _btDone.hidden = NO;
    
        commentView = [[CommentViewController alloc] init];
        commentView.enableDoneButton = YES;
        commentView.dataModelHeader = cell.datapost;
        commentView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        commentView.view.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:commentView.view];
    
    
}

-(void)didSelectImageProfilePostCell:(PostTableViewCell *)cell withUserData:(userDataModel *)userdata{

    PersonTimelineViewController * friendTimelineView = [[PersonTimelineViewController alloc] init];
//    friendTimelineView.flagIsMyTimeline = (userdata.userid == app.userData.userid)?YES:NO;
    friendTimelineView.userData = userdata;
    friendTimelineView.changeMenuToBackNavigation = YES;
    
    
    [app AppPushViewContoller:friendTimelineView];
}


-(void)CellNeedRefreshDataAtIndexPath:(NSIndexPath *)indexPath withDataPostModel:(PostDataModel *)postdata{
    
    [_dataPostArr replaceObjectAtIndex:indexPath.row withObject:postdata];
    
}

-(void)didSelectImageProfilePostCell:(PostTableViewCell *)cell{
    
}

-(void)didSelectImagePostCell:(PostTableViewCell *)cell{
    PostDataModel * dtPostMedel = [_dataPostArr objectAtIndex:cell.currentIndexPath.row];
    
    if ([dtPostMedel.postMediaType isEqualToString:@"text"]) {
        
    }else if ([dtPostMedel.postMediaType isEqualToString:@"clip"]) {
        [self PresentClipURL:dtPostMedel.postMediaValueOrURL];
    }else if ([dtPostMedel.postMediaType isEqualToString:@"photo"]) {
        [self PresentPhotoWithPhotoURL:dtPostMedel.postMediaValueOrURL];
    }else if ([dtPostMedel.postMediaType isEqualToString:@"youtube"]) {
        [self PresentVideoID:dtPostMedel.postMediaValueOrURL];
    }else if ([dtPostMedel.postMediaType isEqualToString:@"soundcloud"]) {
        [self PresentClipURL:dtPostMedel.postMediaValueOrURL];
    }
}
*/
//-(void)didSelectImagePostCell:(PostTableViewCell *)cell withDataDict:(NSDictionary *)dict{
//    
//    /*
//    NSString * media_type = [dict objectForKey:@"media_type"];
//    
//    NSString * urlThumb = @"";
//    
//    if (![[dict objectForKey:@"media"] isKindOfClass:[NSNull class]]) {//or Photo << intpu
//        NSDictionary * dictInfo = [dict objectForKey:@"media"];
//
//        [self PresntPhotoWithDict:dict];
//        
//    }else if (![[dict objectForKey:@"youtube"] isKindOfClass:[NSNull class]]) {//youtube << - input
//        NSDictionary * dictInfo = [dict objectForKey:@"youtube"];
//        
//        NSString * videoIdentify = [dictInfo objectForKey:@"id"];
//        
//        [self PresentVideoID:videoIdentify];
//        
//    }else if (![[dict objectForKey:@"clip"] isKindOfClass:[NSNull class]]) { //<<clip  << - input
//        NSDictionary * dictInfo = [dict objectForKey:@"clip"];
//        NSString * urlVideo = @"";
//        
//        if (![[dictInfo objectForKey:@"extension"] isEqualToString:@""]) {
//            urlVideo = [NSString stringWithFormat:@"%@/%@_ori.%@",kIPIMAGE,[dictInfo objectForKey:@"url"],[dictInfo objectForKey:@"extension"]];
//        }else{
//            urlVideo = [dictInfo objectForKey:@"url"];
//        }
//        
//        
//        [self PresentClipURL:[NSURL URLWithString:urlVideo]];
//        
//        
//    }else if (![[dict objectForKey:@"soundcloud"] isKindOfClass:[NSNull class]]) {//or soundcloud <<- input
//        NSDictionary * dictInfo = [dict objectForKey:@"soundcloud"];
//        
//        NSString * soundUrl = [dictInfo objectForKey:@"uri"];
////        NSString * soundTitle = [dictInfo objectForKey:@"title"];
//        
//        [self PresentClipURL:[NSURL URLWithString:soundUrl]];
//        
//    }
//    */
//    
//    
//}

/*
-(void)PresentClipURL:(NSString *) url{
    app.playerVC = [[XCDYouTubeVideoPlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
    //    app.playerVC.moviePlayer.backgroundPlaybackEnabled = (app)?app.playBackground : YES;
//    app.playerVC.preferredVideoQualities =  (app)?app.preferredVideoQualities_default : nil;
    [self presentMoviePlayerViewControllerAnimated:app.playerVC];
}

-(void)PresentVideoID:(NSString *) videoid{
    app.playerVC = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoid];
    //    app.playerVC.moviePlayer.backgroundPlaybackEnabled = (app)?app.playBackground : YES;
    app.playerVC.preferredVideoQualities =  (app)?app.preferredVideoQualities_default : nil;
    [self presentMoviePlayerViewControllerAnimated:app.playerVC];
}

//-(void)PresntPhotoWithDict:(NSDictionary *) dict{
-(void)PresentPhotoWithPhotoURL:(NSString *) photourl{
    ShowImageViewController *showImageController = [[ShowImageViewController alloc] init];
    showImageController.urlPhoto = photourl;
    //    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:showImageController];
    
    if (IS_OS8_OR_LATER) {
        showImageController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        showImageController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }else{
        showImageController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [self presentViewController:showImageController animated:YES completion:nil];

}

#pragma mark - TableView Scroll Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
//    NSLog(@"begin drag");
    prevPoint = scrollView.contentOffset;
    
    [self checkHideKeyBoard];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
//    NSLog(@"end drag");
    
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
    
    
//    NSLog(@"end Decelerating");
    
    if (app) {
        if (!app.hideTabbarFlag && !directionScrollDown) {
            [app.myTabbar setHiddenCustom:YES];
        }
    }
}





-(void)RequestLoadTimelineDataUserID:(int ) userid WithToken:(NSString *) token  Page:(int) page Perpage:(int) perpage type:(NSString * ) type{
    
    
    _tbPostView.tableFooterView = footerLoadmore;
    [footerLoadmore StartActivity];
    
    
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
        
        if(app.mainHUD.isShowProgressing){
            [app hidMainHud];
        }
        
//        NSLog(@"data: %@", responseObject);

        [self PrepareDataArray:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(app.mainHUD.isShowProgressing){
            [app hidMainHud];
        }
        NSLog(@"Error: %@", [error description]);
        [self ShowLoadDataErrorMessage:@"Connection error!"];
    }];
    
}


-(void)PrepareDataArray:(NSDictionary *) responseObject{
    
    if ([[responseObject objectForKey:@"status"] boolValue]) {
        NSArray * posts = [responseObject objectForKey:@"posts"];
        if ([posts count] >0) {
            
            if ([posts count] == currentNumPerpage) {
                enableLoadmore = YES;
                [footerLoadmore StopActivity];
                _tbPostView.tableFooterView = nil;
            }else{
                enableLoadmore = NO;
                [footerLoadmore StopActivity];
                _tbPostView.tableFooterView = nil;
            }
            
            if (refreshData) {
                refreshData = NO;
                [_dataPostArr removeAllObjects];
                _dataPostArr = [[NSMutableArray alloc] init];
            }
            
            
            for (NSDictionary * dt in posts) {
                PostDataModel * dtPostModel = [PostDataModel PostCreateObjectWithDict:dt];
                [_dataPostArr addObject:dtPostModel];
            }
            
            
            //refresh
            [_tbPostView reloadData];
        }else{
            enableLoadmore = NO;
            [footerLoadmore StopActivity];
            _tbPostView.tableFooterView = nil;
            
            if (refreshData) {
                refreshData = NO;
                [_dataPostArr removeAllObjects];
                _dataPostArr = [[NSMutableArray alloc] init];
            }
            //refresh
            [_tbPostView reloadData];
            
        }
        
    }else{
        
        NSString * messageerror = [responseObject objectForKey:@"message"];
        [self ShowLoadDataErrorMessage:messageerror];
    }

    
}


-(void)ShowLoadDataErrorMessage:(NSString *) errormessage{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Timeline Alert" message:errormessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
    enableLoadmore = NO;
    [footerLoadmore StopActivity];
    _tbPostView.tableFooterView = nil;
    
    if (refreshData) {
        refreshData = NO;
        [_dataPostArr removeAllObjects];
        _dataPostArr = [[NSMutableArray alloc] init];
    }
    //refresh
    [_tbPostView reloadData];
    
}


*/
@end
