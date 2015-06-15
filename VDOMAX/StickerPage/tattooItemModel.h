//
//  PostDataModel.h
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface tattooDataModel : NSObject
@property (assign, nonatomic) int tattooGroupID;
@property (strong, nonatomic) NSString * tattooGroupName;
@property (strong, nonatomic) NSString * tattooGroupDesc;
@property (strong, nonatomic) NSString * tattooGroupLogoURL;
@property (assign, nonatomic) int tattooGroupCatID;
@property (assign, nonatomic) int tattooGroupPrice;
@property (strong, nonatomic) NSString * tattooGroupUserIDCreate;
@property (strong, nonatomic) NSString * tattooGroupUserNameCreate;
@property (assign, nonatomic) int tattooDateLife;
@property (strong, nonatomic) NSArray * tattooImageDataSet;
//@property (assign, nonatomic) int postCount;
//@property (assign, nonatomic) int loveCount;
//@property (assign, nonatomic) int followingCount;
//@property (assign, nonatomic) int followerCount;

+(id)tattooCreateObjectWithDict:(NSDictionary *) dict;

@end
