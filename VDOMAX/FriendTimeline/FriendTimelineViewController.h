//
//  FirstViewController.h
//  VDOMAX
//
//  Created by fanstar on 1/13/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGActionSheet.h"
#import "PostTableViewCell.h"
#import "ShowImageViewController.h"
#import "AFNetworking.h"
#import "IGLDropDownMenu.h"

@interface MyTimelineViewController : UIViewController <UISearchDisplayDelegate,UITextFieldDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,PostTableCellDelegate,IGLDropDownMenuDelegate>{
    
    CGRect originalFrameTablePost;
    BOOL enableCallService;
    UILabel * lbSegmnetTab[6];
    UIButton * btSegmnetTab[6];
    
    CGPoint prevPoint;
    BOOL directionScrollDown;
    
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
@property (retain, nonatomic) UIImageView * myImageBGProfile;
@property (retain, nonatomic) UIImageView * myImageOverayBG;

@end

