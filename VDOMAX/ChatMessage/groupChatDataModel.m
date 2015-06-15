//
//  PostDataModel.m
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "commentDataModel.h"

@implementation commentDataModel

+(id)commentCreateObjectWithDict:(NSDictionary *)dict{
    
    NSString * textComment = [dict objectForKey:@"text"];
    NSString * TimeStampComment = [dict objectForKey:@"timestamp"];
    NSDictionary * userDict = [dict objectForKey:@"user"];
    userDataModel * user_Comment = [userDataModel userCommentCreateObjectWithDict:userDict];
    
    int lvCount = [[dict objectForKey:@"love_count"] intValue];
       
    commentDataModel * datamodel = [[commentDataModel alloc] init];
    
    datamodel.text = textComment;
    datamodel.timestamp = TimeStampComment;
    datamodel.userComment = user_Comment;
    datamodel.loveCount = lvCount;
    
    return  datamodel;
}

+(id)commentCreateObjectWithText:(NSString *) textcomment WithUserDataModel:(userDataModel *) userdata{
    
    
    commentDataModel * datamodel = [[commentDataModel alloc] init];
    
    datamodel.text = textcomment;
    datamodel.timestamp = @"2015-04-07 09:12:12";
    datamodel.userComment = userdata;
    datamodel.loveCount = 0;
    
    return  datamodel;

}
/*
 
 "comment_count": 3,
 "comment": [
 {
 "id": "218405",
 "text": ":tt0504::tt0504::tt0504::tt0504:สวัสดี",
 "emoticonized": "<img src=\"https:\/\/www.vdomax.com\/themes\/vdomax1.1\/emoticons\/tt05%2Ftt0504.png\" class=\"emoticon_original\"><img src=\"https:\/\/www.vdomax.com\/themes\/vdomax1.1\/emoticons\/tt05%2Ftt0504.png\" class=\"emoticon_original\"><img src=\"https:\/\/www.vdomax.com\/themes\/vdomax1.1\/emoticons\/tt05%2Ftt0504.png\" class=\"emoticon_original\"><img src=\"https:\/\/www.vdomax.com\/themes\/vdomax1.1\/emoticons\/tt05%2Ftt0504.png\" class=\"emoticon_original\">สวัสดี",
 "timestamp": "2015-04-07 09:12:12",
 "user": {
 "id": "3082",
 "name": "PopMax",
 "avatar_id": "95144",
 "avatar": "photos\/2015\/01\/PvFoS_95144_8d6283cba348a1dd89d530003c3ac39f.png"
 },
 "love_count": 0,
 "love": [ ]
 },
 
 */

@end
