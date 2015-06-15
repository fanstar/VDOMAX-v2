//
//  PostDataModel.h
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface PostDataModel : NSObject
@property (strong, nonatomic) NSString * postImageProfileURL;
@property (strong, nonatomic) NSString * postName;
@property (strong, nonatomic) NSString * postDescription;
@property (strong, nonatomic) NSString * postdate;
@property (assign, nonatomic) int postLoveCount;
@property (assign, nonatomic) int postCommentCount;
@property (assign, nonatomic) int postShareCount;
@property (assign, nonatomic) int postViewCount;
@property (strong, nonatomic) NSString * postThumbURL;
@property (strong, nonatomic) NSString * postMediaType;
@property (strong, nonatomic) NSString * postMediaURL;
@property (assign, nonatomic) BOOL postIsLove;
@property (assign, nonatomic) int postID;

//for internaldict
@property (strong, nonatomic) NSString * postMediaValueOrURL;

+(id)PostCreateObjectWithDict:(NSDictionary *) dict;


@end
