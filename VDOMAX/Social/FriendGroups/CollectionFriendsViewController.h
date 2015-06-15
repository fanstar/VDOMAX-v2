//
//  FreindCollectionViewController.h
//  VDOMAX
//
//  Created by fanstar on 4/11/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
#import "SocialCollectionViewCell.h"
#import "FooterLoadmoreViewController.h"
#import "userDataModel.h"
#import "ODRefreshControl.h"

typedef NS_ENUM(NSUInteger, SocialType) {
    SocialTypeNewest,
    SocialTypeMostFollower,
    SocialTypeAlphabet,
};

@interface CollectionSocialViewController : UIViewController<PSUICollectionViewDataSource, PSUICollectionViewDelegate,SocialCellDelegate>{
    
    int currentPage;
    FooterLoadmoreViewController * footerLoadmore;
    BOOL enableLoadmore;
    BOOL refreshData;
    
    ODRefreshControl * refreshControl;
    BOOL enableCallService;
    
}
@property (strong, nonatomic) PSUICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray * dataPostArr;
@property (assign) SocialType socialtype;
@end
