//
//  ViewController.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
#import "ChannelFullViewController.h"
#import "AFNetworking.h"
#import "IGLDropDownMenu.h"
#import "Global.h"


@interface ChannelViewController : UIViewController <PSUICollectionViewDataSource, PSUICollectionViewDelegate,UITextFieldDelegate,IGLDropDownMenuDelegate>{
   
    
    CGPoint prevPoint;
    BOOL directionScrollDown;
    
    ChannelFullViewController * fullChannelVC;
    
    NSMutableArray *_dataPostArr;
    BOOL enableCallService;
    
    int currentItemSelectIndex;
    IGLDropDownMenu * dropDownMenu;
    
    BOOL showSearchKeyBoard;
    
}
@property (strong, nonatomic) PSUICollectionView *collectionView;
@property (retain, nonatomic) UITextField * tmpTextField;
@property (retain, nonatomic) UIButton * btSearch;
@property (retain, nonatomic) UIButton * btFilter;
@property (retain, nonatomic) UIButton * btMenu;

@end
