//
//  FirstViewController.h
//  VDOMAX
//
//  Created by fanstar on 1/13/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGActionSheet.h"
#import "VideoTableViewCell.h"
#import "ShowImageViewController.h"
#import "VideoFullViewController.h"
#import "AFNetworking.h"
#import "Global.h"
#import "IGLDropDownMenu.h"

@interface VideoViewController : UIViewController <UISearchDisplayDelegate,UITextFieldDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,VideoViewCellDelegate,IGLDropDownMenuDelegate>{
    
    CGRect originalFrameTablePost;
    
    CGPoint prevPoint;
    BOOL directionScrollDown;
    
    
    VideoFullViewController * videofullVC;
    
    NSMutableArray *_dataPostArr;
    BOOL enableCallService;
    
    int currentItemSelectIndex;
    
    IGLDropDownMenu * dropDownMenu;
    
    BOOL showSearchKeyBoard;
}
@property (retain, nonatomic) NSMutableArray * dataPostArr;
@property (retain, nonatomic) UISearchDisplayController * searchBarDisplayControl;
@property (retain, nonatomic) UISearchBar * searcbar;
@property (retain, nonatomic) UITextField * tmpTextField;
@property (retain, nonatomic) UIButton * btSearch;
@property (retain, nonatomic) UIButton * btFilter;
@property (retain, nonatomic) UIButton * btMenu;
@property (retain, nonatomic) UITableView * tbPostView;
@end

