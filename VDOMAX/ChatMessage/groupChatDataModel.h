//
//  PostDataModel.h
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "userDataModel.h"

@interface commentDataModel : NSObject
@property (strong, nonatomic) NSString * text;
@property (strong, nonatomic) NSString * timestamp;
@property (strong, nonatomic) userDataModel * userComment;
@property (assign) int loveCount;

+(id)commentCreateObjectWithDict:(NSDictionary *) dict;
+(id)commentCreateObjectWithText:(NSString *) textcomment WithUserDataModel:(userDataModel *) userdata;

@end
