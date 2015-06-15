//
//  FirstViewController.m
//  VDOMAX
//
//  Created by fanstar on 1/13/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

static NSString *PostTableViewCellIdentifier = @"PostTableViewCell";

@interface MainViewController (){
    AppDelegate * app;
}

@end



@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //load data test
    _dataPostArr = [NSMutableArray array];
    
    // Load sample data into the array
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    [_dataPostArr addObjectsFromArray:[NSArray arrayWithContentsOfFile:filePath]];
    
    app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [app.myTabbar setHiddenCustom:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars=NO;
//    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self AddMainUICustom];
    
    
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
    float myImageHeight = 60.0f;
    int numoftab_seg = 6;
    
    float searchheight = 30.0f;

    
    //search button
    _btMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    _btMenu.frame = CGRectMake(offsetX, 20, searchheight, searchheight);
    [_btMenu setTitle:@"se" forState:UIControlStateNormal];
    [_btMenu setBackgroundColor:[UIColor redColor]];
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
    [_btSearch setTitle:@"se" forState:UIControlStateNormal];
    [_btSearch setBackgroundColor:[UIColor redColor]];
    [_btSearch addTarget:self action:@selector(didSelectButtonSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btSearch];
    
    //filters button
    _btFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    float offsetx_filter = _tmpTextField.frame.origin.x + _tmpTextField.frame.size.width + shiftX;
    
    _btFilter.frame = CGRectMake( offsetx_filter, offsetY, self.view.frame.size.width - offsetx_filter-shiftX, searchheight);
    [_btFilter setTitle:@"filters" forState:UIControlStateNormal];
    [_btFilter setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:_btFilter];
    
    //Image BG Profile
    UIImageView * myImageBGProfile = [[UIImageView alloc] initWithFrame:CGRectMake( 0, offsetY + shiftX + searchheight, self.view.frame.size.width, myBGTimeLineHeight)];
    myImageBGProfile.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:myImageBGProfile];
    
    
    //Write Post button
    UIButton * _btWritePost = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btWritePost.frame = CGRectMake( offsetX,myImageBGProfile.frame.origin.y + myImageBGProfile.frame.size.height + shiftX +searchheight, (self.view.frame.size.width - (shiftX * 3.0f))/2.0f, searchheight);
    [_btWritePost setTitle:@"Write Post" forState:UIControlStateNormal];
    [_btWritePost setBackgroundColor:[UIColor redColor]];
    [_btWritePost addTarget:self action:@selector(didSelectButtonWritePost:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btWritePost];
    
    //Live Yourself button
    UIButton * _btLive = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btLive.frame = CGRectMake( _btWritePost.frame.origin.x + _btWritePost.frame.size.width + shiftX, _btWritePost.frame.origin.y, (self.view.frame.size.width - (shiftX * 3.0f))/2.0f, searchheight);
    [_btLive setTitle:@"Live Yourself" forState:UIControlStateNormal];
    [_btLive setBackgroundColor:[UIColor redColor]];
    [_btLive addTarget:self action:@selector(didSelectButtonFilters:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btLive];
    
    //My Image Profile
    UIImageView * myImageProfile = [[UIImageView alloc] initWithFrame:CGRectMake( shiftX, _btWritePost.frame.origin.y - ( shiftX +  myImageHeight), myImageHeight, myImageHeight)];
    myImageProfile.backgroundColor = [UIColor grayColor];
    myImageProfile.layer.cornerRadius = myImageProfile.frame.size.width/2.0f;
    myImageProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    myImageProfile.layer.borderWidth = 1.0f;
    [myImageProfile.layer setMasksToBounds:YES];
    
    [self.view addSubview:myImageProfile];
    
    UITapGestureRecognizer * tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageProfile:)];
    
    myImageProfile.userInteractionEnabled = YES;
    [myImageProfile addGestureRecognizer:tapProfile];
    
    //add Segment Tab
    
    float offsetX_seg = myImageProfile.frame.origin.x + myImageProfile.frame.size.width;
    float offsetY_seg = myImageBGProfile.frame.origin.y + myImageBGProfile.frame.size.height;
    float seg_width = (self.view.frame.size.width - (myImageProfile.frame.origin.x + myImageProfile.frame.size.width) ) / (float)numoftab_seg;
    for (int i=0; i<numoftab_seg; i++) {//6 tab
        
        //Live Yourself button
        UIButton * _btSegmnetTab = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _btSegmnetTab.frame = CGRectMake( offsetX_seg + seg_width*i, offsetY_seg, seg_width, searchheight);
        [_btSegmnetTab setTitle:@"title" forState:UIControlStateNormal];
        if (i%2 == 0) {
            [_btSegmnetTab setBackgroundColor:[UIColor orangeColor]];
        }else{
            [_btSegmnetTab setBackgroundColor:[UIColor blueColor]];
        }
        _btSegmnetTab.tag = i;
        
        [_btSegmnetTab addTarget:self action:@selector(didSelectButtonSegment:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_btSegmnetTab];
    }
    
    
    //set table view
    _tbPostView = [[UITableView alloc] initWithFrame:CGRectMake(offsetX, _btWritePost.frame.origin.y+_btWritePost.frame.size.height + shiftX, self.view.frame.size.width - (shiftX * 2.0f), self.view.frame.size.height - (_btWritePost.frame.origin.y + _btWritePost.frame.size.height + shiftX)  )];
    _tbPostView.dataSource = self;
    _tbPostView.delegate = self;
    _tbPostView.backgroundColor = [UIColor grayColor];
    _tbPostView.showsHorizontalScrollIndicator = NO;
    _tbPostView.showsVerticalScrollIndicator = NO;
    _tbPostView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbPostView.allowsSelection = NO;
    [_tbPostView registerClass:[PostTableViewCell class] forCellReuseIdentifier:PostTableViewCellIdentifier];
    
    originalFrameTablePost = _tbPostView.frame;
    
    [self.view addSubview:_tbPostView];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
//    _searcbar.hidden = NO;
//    [_searcbar becomeFirstResponder];
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
    UIImage *image = [UIImage imageNamed:@"icon1.png"];
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



@end
