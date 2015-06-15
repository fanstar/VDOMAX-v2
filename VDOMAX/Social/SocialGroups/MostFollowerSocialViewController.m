//
//  FreindCollectionViewController.m
//  VDOMAX
//
//  Created by fanstar on 4/11/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "NewestSocialViewController.h"
#import "AppDelegate.h"
#import "SocialHeaderView.h"
#import "SocialFooterView.h"

#define _allowAppearance    NO
#define _bakgroundColor     kBACKGROUNDCOLOR//[UIColor whiteColor]//[UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define _tintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define _hairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:150/255.0 alpha:1.0]

static NSString *cellIdentifier = @"TestCell";
static NSString *headerViewIdentifier = @"Test Header View";
static NSString *footerViewIdentifier = @"Test Footer View";



@interface NewestSocialViewController (){
    AppDelegate * app;
}

@end

@implementation NewestSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kBACKGROUNDCOLOR;
    
    _dataPostArr = [[NSMutableArray alloc] init];
    
    app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    currentPage = 1;
    
    [self CreateCollectionViewWithRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 
    [self SetODRefreshHeaderAndFooterViewLoadMore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)CreateCollectionViewWithRect:(CGRect )  rect{
    //[super loadView];
    
    int numperrow = 3;
    float shiftX = 5.0f;
    
    if (IS_DEVICE_MODEL_IPAD) {
        numperrow = 5;
    }else if(IS_HEIGHT_GTE_6 || IS_HEIGHT_GTE_6Plus){
        numperrow = 4;
    }
    
    _dataPostArr = [[NSMutableArray alloc] init];
    
    float itemWidth = ((self.view.frame.size.width) - ((float)(numperrow+1))*shiftX) / (float)numperrow;
    
    //    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    PSUICollectionViewFlowLayout *collectionViewFlowLayout = [[PSUICollectionViewFlowLayout alloc] init];
    
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionViewFlowLayout setItemSize:CGSizeMake(itemWidth, 1.7*itemWidth)];
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
    
    [_collectionView registerClass:[SocialCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [_collectionView registerClass:[SocialHeaderView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    [_collectionView registerClass:[SocialFooterView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_collectionView];
    
    //create footer
    footerLoadmore = [[FooterLoadmoreViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    
    [self RequestLoadDataNewesSocialPage:currentPage];
    
}



-(void)SetODRefreshHeaderAndFooterViewLoadMore{
    
    //Custome Load More
    refreshControl = [[ODRefreshControl alloc] initInScrollView:_collectionView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshContr
{
    if (enableCallService)return;
    
    [refreshControl beginRefreshing];
    refreshData = YES;
    
    currentPage = 1;
    
    [self RequestLoadDataNewesSocialPage:currentPage];
    
}



#pragma mark -
#pragma mark PSUICollectionView stuff

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataPostArr count];
}


- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SocialCollectionViewCell *cell = (SocialCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.current_indexPath = [indexPath copy];
    //    UILabel *label = (UILabel *)[cell viewWithTag:123];
    //    label.text  = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    userDataModel * user_data = [_dataPostArr objectAtIndex:indexPath.row];
    
    [cell CellSetUpdataForUserData:user_data];
    
    //check load more
    if (enableLoadmore && [_dataPostArr count]-1 == indexPath.row) {
        currentPage++;
        [self RequestLoadDataNewesSocialPage:currentPage];
    }
    
    
    return cell;
}

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    
    if ([kind isEqualToString:PSTCollectionElementKindSectionHeader]) {
        identifier = headerViewIdentifier;
        
        PSUICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        
        // TODO Setup view
        
//        SocialHeaderView * vHeader = (SocialHeaderView *)supplementaryView;
//        vHeader.titlename.text = [NSString stringWithFormat:@"  %@",@"A"];
//        return (PSUICollectionReusableView *)vHeader;
        
        return supplementaryView;
        
    }
    
    else if ([kind isEqualToString:PSTCollectionElementKindSectionFooter]) {
        identifier = footerViewIdentifier;
        
        PSUICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        
        // TODO Setup view
        for(UIView * v in supplementaryView.subviews) {
            if ([v isKindOfClass:[FooterLoadmoreViewController class]]) {
                [v removeFromSuperview];
            }
        }
        
        if (footerLoadmore) {
            [supplementaryView addSubview:footerLoadmore];
        }else{
            footerLoadmore = [[FooterLoadmoreViewController alloc] initWithFrame:supplementaryView.frame];
            [supplementaryView addSubview:footerLoadmore];
        }
        
        
        return supplementaryView;
        
        
    }
    return nil;
}




#pragma mark - SocialCellDelegate
-(void) SocialDidSelectCellImageWithUserData:(userDataModel *)user_data{
    

    
    PersonTimelineViewController * personTimeline = [[PersonTimelineViewController alloc] initWithNibName:@"PersonTimelineViewController" bundle:nil];
    personTimeline.changeMenuToBackNavigation = YES;
    personTimeline.userData = user_data;
    
    
    [app AppPushViewContoller:personTimeline];
    
}

-(void)SocialDidSelectFollowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(void)RequestLoadDataNewesSocialPage:(int) page{
    
    enableCallService = YES;
    [footerLoadmore StartActivity];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * urlString = [NSString stringWithFormat:@"%@/search/social?sort=N&page=%d",kIPAPIVDOMAX,page];
    NSString* encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    
    [manager GET:encodedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"data: %@", responseObject);
        enableCallService = NO;
        [refreshControl endRefreshing];
        [footerLoadmore StopActivity];
        
        BOOL status = [[responseObject objectForKey:@"status"] boolValue];
        
        if (status) {
            NSArray * tmpData = [responseObject objectForKey:@"users"];
            
            if ([tmpData count] >0 ) {
                
                enableLoadmore = YES;
                
                if (refreshData) {
                    refreshData = NO;
                    
                    [_dataPostArr removeAllObjects];
                    _dataPostArr = [[NSMutableArray alloc] init];
                }
                
                //            NSMutableArray * tmp = [[NSMutableArray alloc] init];
                
                for (NSDictionary * dt in tmpData) {
                    userDataModel * user_data = [userDataModel userCreateObjectWithDict:dt];
                    [_dataPostArr addObject:user_data];
                }
                
                //            [_dataPostArr addObject:tmp];
                
                //refresh
                [_collectionView reloadData];
                
            }else{
                enableLoadmore = NO;
            }
        }else{
            NSLog(@"Requsest succuss status: 0");
            enableLoadmore = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        
        enableCallService = NO;
        enableLoadmore = NO;
        [refreshControl endRefreshing];
        [footerLoadmore StopActivity];
        
        NSError* err;
        NSDictionary * jsonErr = [NSJSONSerialization
                                  JSONObjectWithData:operation.responseData
                                  
                                  options:kNilOptions
                                  error:&err];
        //        NSLog(@"json: %@", json);
        
        if ([[jsonErr objectForKey:@"status"] intValue] == 0) {
            [app AppCallLogout];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Message" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}
@end
