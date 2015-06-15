//
//  PostDataModel.h
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface userDataModel : NSObject
@property (strong, nonatomic) NSString * avatarURL;
@property (strong, nonatomic) NSString * coverURL;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * userToken;
@property (assign, nonatomic) int userid;
//@property (assign, nonatomic) int postCount;
//@property (assign, nonatomic) int loveCount;
//@property (assign, nonatomic) int followingCount;
//@property (assign, nonatomic) int followerCount;

+(id)userCreateObjectWithDict:(NSDictionary *) dict;

-(void)userSaveMyInfoDataDictToDefualt;
-(userDataModel * )userLoadMyInfoFromDefualt;

@end
