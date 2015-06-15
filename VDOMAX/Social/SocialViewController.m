//
//  ViewController.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "ChannelViewController.h"
#import "AppDelegate.h"
#import "CollectionViewCell.h"
#import "HeaderView.h"
#import "FooterView.h"

static NSString *cellIdentifier = @"TestCell";
static NSString *headerViewIdentifier = @"Test Header View";
static NSString *footerViewIdentifier = @"Test Footer View";

@interface ChannelViewController ()<ChannelCellDelegate>{
    AppDelegate * app;
}
@property (nonatomic, strong) NSMutableArray *cellSizes;
@end

@implementation ChannelViewController

#pragma mark -
#pragma mark Setup

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)CreateCollectionViewWithRect:(CGRect )  rect{
    //[super loadView];
    
    int numperrow = 2;
    float shiftX = 5.0f;
    
    _dataPostArr = [[NSMutableArray alloc] init];
    
    float itemWidth = ((self.view.frame.size.width) - ((float)(numperrow+1))*shiftX) / (float)numperrow;
    
//    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    PSUICollectionViewFlowLayout *collectionViewFlowLayout = [[PSUICollectionViewFlowLayout alloc] init];
    
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionViewFlowLayout setItemSize:CGSizeMake(itemWidth, itemWidth)];
    [collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(rect.size.width, 30)];
    [collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(rect.size.width, 10)];
    [collectionViewFlowLayout setMinimumInteritemSpacing:5];
    [collectionViewFlowLayout setMinimumLineSpacing:5];
    [collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
//    _collectionView = [[PSUICollectionView alloc] initWithFrame:CGRectMake(floorf((CGRectGetWidth(self.view.bounds)-500)/2), 0, 500, CGRectGetHeight(self.view.bounds)) collectionViewLayout:collectionViewFlowLayout];
    _collectionView = [[PSUICollectionView alloc] initWithFrame:rect collectionViewLayout:collectionViewFlowLayout];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [_collectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    [_collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
    
    [self.view addSubview:_collectionView];
    
    [self RequestLoadDataChannelWithToken:kToken];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBACKGROUNDCOLOR;
    
    app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
//    data = @[
//             @[@"One", @"Two", @"Three"],
//             @[@"Four", @"Five", @"Six"],
//             @[],
//             @[@"Seven"],
//             ];
    
    
    [self AddMainUICustom];
    
    [self CreateDropdownPopularList];
}


#pragma mark -
#pragma mark PSUICollectionView stuff

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return [_dataPostArr count];
}


- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[_dataPostArr objectAtIndex:section] count];
}


- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
//    UILabel *label = (UILabel *)[cell viewWithTag:123];
//    label.text  = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSDictionary * dict = [[_dataPostArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [cell CellSetUpdataForDataDict:dict];
    
    
    return cell;
}

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    
    if ([kind isEqualToString:PSTCollectionElementKindSectionHeader]) {
        identifier = headerViewIdentifier;
        
        PSUICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        
        // TODO Setup view
        
        HeaderView * vHeader = (HeaderView *)supplementaryView;
        vHeader.titlename.text = [NSString stringWithFormat:@"  %@",@"A"];
        return (PSUICollectionReusableView *)vHeader;
        
        
    }
    
    else if ([kind isEqualToString:PSTCollectionElementKindSectionFooter]) {
        identifier = footerViewIdentifier;
        
        PSUICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        
        // TODO Setup view
        
        return supplementaryView;
        
        
    }
    return nil;
}


#pragma mark - ChannelCellDelegate
-(void) ChannelDidSelectCellThumbWithData:(NSDictionary *)data{
    
    //show full page
    
    
    fullChannelVC = [[ChannelFullViewController alloc] init];
    fullChannelVC.dict = data;
//    [self.view addSubview:fullChannelVC.view];
    [app.window.rootViewController presentViewController:fullChannelVC animated:YES completion:nil];
    
}

-(void)AddMainUICustom{
    
    float offsetY= 20;
    float shiftX =  5.0f;
    float offsetX = shiftX;
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
    
    
    CGRect rect = CGRectMake(offsetX, _tmpTextField.frame.origin.y+_tmpTextField.frame.size.height + shiftX, self.view.frame.size.width - (shiftX * 2.0f), self.view.frame.size.height - (_tmpTextField.frame.origin.y + _tmpTextField.frame.size.height + shiftX)  );
    [self CreateCollectionViewWithRect:rect];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    //    _searcbar.hidden = NO;
    //    [_searcbar becomeFirstResponder];
}

#pragma mar - Private Method

-(void)didSelectButtonMenu:(id) sender{
    
    [app.sideBar show];
    
}

-(void)didSelectButtonFilters:(id) sender{
    
}

-(void)didSelectButtonSearch:(id) sender{
    
}



#pragma mark - TableView Scroll Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    NSLog(@"begin drag");
    prevPoint = scrollView.contentOffset;
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
//        dropDownMenu.menuButton.bgView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0f].CGColor;
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





-(void)RequestLoadDataChannelWithToken:(NSString *) token{
    
    enableCallService = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * urlString = [NSString stringWithFormat:@"%@",@"http://api.vdomax.com/live/history/3"];//@"http://server-a.vdomax.com:8080/record/?user=manaw_liverpool"
    //http://api.vdomax.com/live/history/3
    NSString* encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    
    //header param
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-Auth-Token"];
    
    //    //body param
    //    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",page],@"page",
    //                             [NSString stringWithFormat:@"%d",perpage],@"per_page",
    //                             [NSString stringWithFormat:@"%@",type],@"type",
    //                             nil];
    
    
    [manager GET:encodedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"data: %@", responseObject);
        
        NSArray * tmpData = [responseObject objectForKey:@"history"];
        
        if ([tmpData count] >0 ) {
            
            NSMutableArray * tmp = [[NSMutableArray alloc] init];
            
            for (NSDictionary * dt in tmpData) {
                [tmp addObject:dt];
            }
            
            [_dataPostArr addObject:tmp];
            
            //refresh
            [_collectionView reloadData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error description]);
    }];
    
}

@end
