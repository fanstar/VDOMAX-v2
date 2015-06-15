//
//  RefillViewController.h
//  MaxCalling
//
//  Created by shadow on 22/7/57.
//  Copyright (c) พ.ศ. 2557 vdomax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

#define kNumItem 4

//#import "SKProductsRequest+blocks.h"
#import "EBPurchase.h"
#import "AFNetworking.h"


@interface RefillViewController : UIViewController<EBPurchaseDelegate>{
    
    
    UIImageView * imvItem[kNumItem];
    UITapGestureRecognizer * tap [kNumItem];
    UIButton * buyButton[kNumItem];
    
    
    
    BOOL canbuy;
    int CurrentBuyItem;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imvTemp;
@property (weak, nonatomic) IBOutlet UIButton *btTemp;
@property (retain, nonatomic) EBPurchase * ebproduct;
@property (weak, nonatomic) IBOutlet UIScrollView *uiscrollview;

@property (weak, nonatomic) IBOutlet UITextField *txtInputCardNumber;
@property (weak, nonatomic) IBOutlet UIButton *btActivate;


@end
