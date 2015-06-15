//
//  RefillViewController.m
//  MaxCalling
//
//  Created by shadow on 22/7/57.
//  Copyright (c) พ.ศ. 2557 vdomax. All rights reserved.
//

#import "RefillViewController.h"
#import "AppDelegate.h"

@interface RefillViewController (){
    AppDelegate * app;
    NSUserDefaults * userDef;
}

@end

@implementation RefillViewController
@synthesize ebproduct;

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
    // Do any additional setup after loading the view.
    app = [[UIApplication sharedApplication] delegate];
    userDef = [NSUserDefaults standardUserDefaults];
    
    //hiden in this version
    self.btActivate.hidden = YES;
    self.txtInputCardNumber.hidden = YES;
    
    [self SetUpScrollview];
    
    
    ebproduct = [[EBPurchase alloc] init];
    ebproduct.delegate = self;
//    if ([ebproduct requestProduct:[NSSet setWithObjects:SUB_PRODUCT_ID1, nil]])
//    {
//        canbuy = YES;
//        
//    }
    
    
    [self customNavBar];
}

-(void) viewWillAppear:(BOOL)animated
{
    //buyButton.enabled = NO; // Only enable after populated with IAP price.
    
    // Request In-App Purchase product info and availability.
    // NSSet * productidentifylist = [[NSSet alloc] initWithObjects:SUB_PRODUCT_ID,SUB_PRODUCT_ID2,nil];
    if (![ebproduct requestProduct:[[NSSet alloc] initWithObjects:SUB_PRODUCT_ID1,SUB_PRODUCT_ID2,SUB_PRODUCT_ID3,SUB_PRODUCT_ID4,nil]])
    {
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
        
        // [buyButton setTitle:@"Purchase Disabled in Settings" forState:UIControlStateNormal];
    }else{
        canbuy = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)customNavBar{
    
    //custom left bt
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setFrame:CGRectMake(0,0,23,23)];
    lButton.showsTouchWhenHighlighted = YES;
    [lButton setBackgroundImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    [lButton addTarget:self action:@selector(MenuClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftbutton = [[UIBarButtonItem alloc] initWithCustomView:lButton];
    
    // UIBarButtonItem * rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(EditChat)];
    
    self.navigationItem.leftBarButtonItem = leftbutton;
    
}


-(void)MenuClick{
    [app.container toggleLeftSideMenuCompletion:nil];
}


-(void)SetUpScrollview{
    
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:self.uiscrollview.frame];
    
    float shiftx = 10.0f;
    scroll.contentSize = CGSizeMake(self.imvTemp.frame.origin.x+(self.imvTemp.frame.size.width + shiftx) * kNumItem, self.uiscrollview.frame.size.height);
    scroll.scrollEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.userInteractionEnabled = YES;
    
    
    CGRect tmpRect = self.imvTemp.frame;
    CGPoint btCenter = self.btTemp.center;
    
    NSArray * price = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f",kValue_ID1],
                       [NSString stringWithFormat:@"%.2f",kValue_ID2],
                       [NSString stringWithFormat:@"%.2f",kValue_ID3],
                       [NSString stringWithFormat:@"%.2f",kValue_ID4],
                       nil];
    
    
    for (int i=0; i<kNumItem; i++) {
        
        CGRect rect = CGRectMake(tmpRect.origin.x+(tmpRect.size.width)*i + shiftx*i, tmpRect.origin.y, tmpRect.size.width, tmpRect.size.height);
        
        imvItem[i] = [[UIImageView alloc] initWithFrame:rect];
        imvItem[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"card%d.png",i]];
        
        imvItem[i].userInteractionEnabled = NO;
        imvItem[i].alpha = 0.4f;
        
        tap[i] = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelected:)];
        tap[i].numberOfTapsRequired = 1;
        
        
        [imvItem[i] addGestureRecognizer:tap[i]];
        
        
        buyButton[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton[i].frame = self.btTemp.frame;
        [buyButton[i] setTitle:[NSString stringWithFormat:@"Buy: $%@",price[i]] forState:UIControlStateNormal];
        [buyButton[i] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [buyButton[i] setFont:[UIFont systemFontOfSize:10.0f]];
        
        buyButton[i].center = CGPointMake(imvItem[i].center.x, btCenter.y);
//        [buyButton[i] setImage:[UIImage imageNamed:@"buy-button.png"] forState:UIControlStateNormal];
        [buyButton[i] addTarget:self action:@selector(btSelected:) forControlEvents:UIControlEventTouchUpInside];
        buyButton[i].tag = i;
        buyButton[i].alpha = 0.4f;
        buyButton[i] .enabled = NO;
        
        [self Custombutton:buyButton[i]];
        
        [scroll addSubview:imvItem[i]];
        [scroll addSubview:buyButton[i]];
        
    }
    
    
    
    [self.view addSubview:scroll];
    
    //hidden temp frame
    self.btTemp.hidden = YES;
    self.imvTemp.hidden = YES;
    
    
}

-(void)Custombutton:(UIButton *) bt{
    [bt setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
    bt.layer.cornerRadius = 5.0f;
    bt.layer.borderColor = [UIColor redColor].CGColor;
    bt.layer.borderWidth = 1.0f;
}

-(void)tapSelected:(UITapGestureRecognizer *) tabrec{
    
    if (tabrec == tap[0]) {
        [self BuyItemIndex:0];
        CurrentBuyItem = 0;
    }else if (tabrec == tap[1]) {
        [self BuyItemIndex:1];
         CurrentBuyItem = 1;
    }else if (tabrec == tap[2]) {
        [self BuyItemIndex:2];
         CurrentBuyItem = 2;
    }else if (tabrec == tap[3]) {
        [self BuyItemIndex:3];
         CurrentBuyItem = 3;
    }
    
}

-(void)btSelected:(id ) sender{
//    NSLog(@"bt tag: %d", [sender tag]);
    
    if(canbuy)[self BuyItemIndex:[sender tag]];
}

-(void)BuyItemIndex:(int ) index{
    
    
//    NSString * identifierIDBuy = @"";
    
//    if (index == 0 ) {
//        identifierIDBuy = @"com.bizvizard.iMaker.item0001";
//    }else if (index == 1 ) {
//        identifierIDBuy = @"com.biz.item2_puchases";
//    }else if (index == 2 ) {
//        identifierIDBuy = @"com.biz.item3_puchases";
//    }else if (index == 3 ) {
//        identifierIDBuy = @"com.biz.item4_puchases";
//    }
    
     CurrentBuyItem = index;
    
    if ([ebproduct.productsArr objectAtIndex:index]) {
        
        if (![ebproduct purchaseProduct:[ebproduct.productsArr objectAtIndex:index]])
        {
            // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
            UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [settingsAlert show];
            //[settingsAlert release];
        }
        
        
    }
    
//    [SKProductsRequest requestWithProductIdentifiers:[NSSet setWithObjects:identifiers, nil] withBlocks:^(SKProductsResponse *response, NSError *error) {
//        
//         NSLog(@"error: %@",response);
//        
//        if (error) {
//            
//        }
//        else{
//            
//            NSLog(@"error: %@",[error description]);
//        }
//    }];
}




#pragma mark -
#pragma mark EBPurchaseDelegate Methods

//-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
//    
//    if ([response.products count]> CurrentBuyItem) {
//        
//        ebproduct.validProduct = [response.products objectAtIndex:CurrentBuyItem];
//
//        
//        if (ebproduct.validProduct) {
//            NSLog(@"products: %@",ebproduct.validProduct);
//        }else{
//            UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [unavailAlert show];
//        }
//        
//        
//    }
//    
//}

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
//    NSLog(@"ViewController requestedProduct");
//    NSLog(@"productId :%@",productId);
    
    if (productPrice != nil)
    {
        
        if ([productId isEqualToString:SUB_PRODUCT_ID1]) {
            
            imvItem[0].userInteractionEnabled = YES;
            imvItem[0].alpha = 1.0f;
            buyButton[0].enabled = YES;
            buyButton[0].alpha = 1.0f;
            
           // validProduct[0] = ebp.validProduct;
            
        }else if([productId isEqualToString:SUB_PRODUCT_ID2]){
            imvItem[1].userInteractionEnabled = YES;
            imvItem[1].alpha = 1.0f;
            buyButton[1].enabled = YES;
            buyButton[1].alpha = 1.0f;
            //validProduct[1] = [ebp.validProduct copy];
            
        }else if([productId isEqualToString:SUB_PRODUCT_ID3]){
            imvItem[2].userInteractionEnabled = YES;
            imvItem[2].alpha = 1.0f;
            buyButton[2].enabled = YES;
            buyButton[2].alpha = 1.0f;
            //validProduct[2] = [ebp.validProduct copy];
            
        }else if([productId isEqualToString:SUB_PRODUCT_ID4]){
            imvItem[3].userInteractionEnabled = YES;
            imvItem[3].alpha = 1.0f;
            buyButton[3].enabled = YES;
            buyButton[3].alpha = 1.0f;
            //validProduct[3] = [ebp.validProduct copy];
            
        }
        
        
    } else {
        // Product is NOT available in the App Store, so notify user.
        
        //        buyButton.enabled = NO; // Ensure buy button stays disabled.
        //        [buyButton setTitle:@"Buy Game Levels Pack" forState:UIControlStateNormal];
        
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
//        [unavailAlert release];
    }
}

-(void) successfulPurchase:(EBPurchase*)ebp restored:(bool)isRestore identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    //    NSLog(@"ViewController successfulPurchase");
    //
//    NSLog(@"Buy success for productId:%@",productId);
    
    //call topup value
    int topupVal = 0;
    if ([productId isEqualToString:SUB_PRODUCT_ID1]) {
        topupVal = kValue_ID1;
    }else if ([productId isEqualToString:SUB_PRODUCT_ID2]) {
        topupVal = kValue_ID2;
    }else if ([productId isEqualToString:SUB_PRODUCT_ID3]) {
        topupVal = kValue_ID3;
    }else if ([productId isEqualToString:SUB_PRODUCT_ID4]) {
        topupVal = kValue_ID4;
    }
    
    
    app.pendingTopupAmout = app.pendingTopupAmout += topupVal;
    [userDef setFloat:app.pendingTopupAmout forKey:@"PENDINGTOPUPAMOUNT"];
    [userDef synchronize];
    
    if(app.pendingTopupAmout>0){
        //call sevice topup
        
        [app requestTopupAmount:app.pendingTopupAmout];
    }
    
}

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    
//    [self.uiProgress stopAnimating];
//    self.uiProgress.hidden = YES;
    //[self.uiProgress hidesWhenStopped];
    
//    PressFlag = NO; // turn on bt
    
    //    NSLog(@"ViewController failedPurchase");
    
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
//    [failedAlert release];
}


-(void)failedTransactionAndRemovePaymentState{
    NSLog(@"failedTransactionAndRemovePaymentState");
    
//    [self.uiProgress stopAnimating];
//    self.uiProgress.hidden = YES;
}




@end
