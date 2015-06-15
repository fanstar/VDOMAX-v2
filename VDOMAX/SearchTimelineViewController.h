//
//  FirstViewController.h
//  VDOMAX
//
//  Created by fanstar on 1/13/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGActionSheet.h"
//#import "PostTableViewCell.h"
#import "ShowImageViewController.h"
#import "AFNetworking.h"
#import "IGLDropDownMenu.h"
//#import "FooterLoadmoreViewController.h"
#import "PostDataModel.h"
#import "CommentViewController.h"
#import "ShowImageViewController.h"
#import "PostTableViewController.h"
#import "LiveMySelfViewController.h"
#import "RRSendMessageViewController.h"


@interface TimelineViewController : UIViewController <UISearchDisplayDelegate,UITextFieldDelegate,UIActionSheetDelegate,PostTableCellDelegate,IGLDropDownMenuDelegate,PostTableViewDelegate>{
    
    CGRect originalFrameTablePost;
    
    CGPoint prevPoint;
    BOOL directionScrollDown;
    
//    BOOL enableCallService;
    
    int currentItemSelectIndex;
    
    IGLDropDownMenu * dropDown_Menu;
    BOOL showSearchKeyBoard;
    
    BOOL refreshData;
    
    int currentPage;
    int currentNumPerpage;
    NSString * current_typesearch;
    
//    FooterLoadmoreViewController * footerLoadmore;
//    BOOL enableLoadmore;
    
    CommentViewController * commentView;
    
}
//@property (retain, nonatomic) NSMutableArray * dataPostArr;
@property (retain, nonatomic) UISearchDisplayController * searchBarDisplayControl;
@property (retain, nonatomic) UISearchBar * searcbar;
@property (retain, nonatomic) UITextField * tmpTextField;
@property (retain, nonatomic) UIButton * btSearch;
//@property (retain, nonatomic) UIButton * btFilter;
@property (retain, nonatomic) UIButton * btMenu;
//@property (retain, nonatomic) UITableView * tbPostView;
@property (retain, nonatomic) PostTableViewController * tbPost;
@property (retain,nonatomic) UIButton * btDone;


//-(void)CallRefreshData;

@end

