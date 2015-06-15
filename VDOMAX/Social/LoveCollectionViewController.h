//
//  FollowerCollectionViewController.h
//  VDOMAX
//
//  Created by fanstar on 4/11/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
#import "SocialCollectionViewCell.h"
#import "FooterLoadmoreViewController.h"

@interface FollowerCollectionViewController : UIViewController<PSUICollectionViewDataSource, PSUICollectionViewDelegate,SocialCellDelegate>{
    
    NSMutableArray * dataPostArr;
    int currentPage;
    int currentNumPerpage;
    FooterLoadmoreViewController * footerLoadmore;
    BOOL enableLoadmore;
    BOOL refreshData;
    
}
@property (strong, nonatomic) PSUICollectionView *collectionView;
@end
