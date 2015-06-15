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

@interface TimelineViewController : UIViewController <UISearchDisplayDelegate,UITextFieldDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,PostTableCellDelegate>{
    
    CGRect originalFrameTablePost;
    
    CGPoint prevPoint;
    BOOL directionScrollDown;
    
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

