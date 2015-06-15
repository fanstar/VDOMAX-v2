//
//  PostDataModel.m
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "userChatModel.h"

@implementation userChatModel

+(id)userCreateObjectWithDict:(NSDictionary *)dict{
    
    NSString * avatarAuthorUrl = [NSString stringWithFormat:@"%@/%@",kIPIMAGE,[dict objectForKey:@"avatar"]];
    NSString * namePost = [dict objectForKey:@"username"];
    NSString * userDesc = [dict objectForKey:@"language"];
    int user_id = [[dict objectForKey:@"id"] intValue];
    BOOL is_Following = [[dict objectForKey:@"is_following"] boolValue];
       
    userChatModel * datamodel = [[userChatModel alloc] init];
    
    datamodel.avatarURL = avatarAuthorUrl;
    datamodel.userid = user_id;
    datamodel.userName = namePost;
    datamodel.userDesc = userDesc;
    datamodel.isFollowing = is_Following;
    
    return  datamodel;
}


/*
 {
 about = "";
 active = 1;
 avatar = "photos/2015/01/6oCCf_88845_fb60d93c210068b4a03cd16c0018d8dd.jpg";
 "avatar_id" = 88845;
 birthday = "<null>";
 cover = "photos/2015/01/64Ter_94385_35a4e28b82263cf441601c2cca9aa6cc.jpg";
 "cover_id" = 94385;
 "cover_position" = 157;
 email = "idolkorrio@gmail.com";
 "email_verification_key" = 48150dc85ae1fafb39a3f10be72c6728;
 "email_verified" = 1;
 gender = "<null>";
 id = 6;
 "is_following" = 1;
 language = thai;
 "last_logged" = 1428744789;
 name = korr;
 password = 039a726ac0aeec3dde33e45387a7d4ac;
 time = 1413297961;
 timestamp = "2015-04-11 09:33:09";
 timezone = "Pacific/Midway";
 type = user;
 username = korrio;
 verified = 0;
 }

 */


@end
