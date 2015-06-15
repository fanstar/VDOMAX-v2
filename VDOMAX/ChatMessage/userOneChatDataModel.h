//
//  PostDataModel.h
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "userGroupChatDataModel.h"

@interface groupChatDataModel : NSObject
@property (assign, nonatomic) int groupID;
@property (strong, nonatomic) NSString * groupName;
@property (strong, nonatomic) NSString * groupAvatar;
@property (strong, nonatomic) NSString * groupConverSationType;
@property (assign, nonatomic) int groupCreatedByUserID;
@property (assign, nonatomic) BOOL groupActiveflag;
@property (strong, nonatomic) NSString * groupChatDateString;
@property (retain,nonatomic) NSArray * userGroupChats;


+(id)groupChatCreateObjectWithDict:(NSDictionary *) dict;

@end
