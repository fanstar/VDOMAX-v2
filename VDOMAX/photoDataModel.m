//
//  PostDataModel.m
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "userDataModel.h"

@implementation userDataModel

+(id)userCreateObjectWithDict:(NSDictionary *)dict{
    
    NSString * avatarAuthorUrl = [NSString stringWithFormat:@"%@/%@",kIPIMAGE,[dict objectForKey:@"avatar"]];
    NSString * coverAuthorUrl = [NSString stringWithFormat:@"%@/%@",kIPIMAGE,[dict objectForKey:@"cover"]];
    NSString * namePost = [dict objectForKey:@"name"];
    int user_id = [[dict objectForKey:@"id"] intValue];

    NSString * password = [dict objectForKey:@"password"];
    
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPTOKEN"];
    
    BOOL online = [[dict objectForKey:@"online"] boolValue];
    BOOL is_following = [[dict objectForKey:@"is_following"] boolValue];
       
    userDataModel * datamodel = [[userDataModel alloc] init];
    
    datamodel.avatarURL = avatarAuthorUrl;
    datamodel.coverURL = coverAuthorUrl;
    datamodel.userid = user_id;
    datamodel.userPassword = password;
    datamodel.userName = namePost;
    datamodel.userToken = token;
    datamodel.onlineStatus = online;
    datamodel.isFollowing = is_following;
    
    
    return  datamodel;
}

+(id)userCommentCreateObjectWithDict:(NSDictionary *)dict{
    
    NSString * avatarAuthorUrl = [NSString stringWithFormat:@"%@/%@",kIPIMAGE,[dict objectForKey:@"avatar"]];
    NSString * namePost = [dict objectForKey:@"name"];
    int user_id = [[dict objectForKey:@"id"] intValue];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPTOKEN"];
    
    
    userDataModel * datamodel = [[userDataModel alloc] init];
    
    datamodel.avatarURL = avatarAuthorUrl;
    datamodel.userid = user_id;
    datamodel.userName = namePost;
    datamodel.userToken = token;
    
    return  datamodel;

    
}

-(void)userSaveMyInfoDataDictToDefualt{
    
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:_avatarURL forKey:@"AVATARURL"];
    [userDef setObject:_coverURL forKey:@"COVERURL"];
    [userDef setObject:[NSString stringWithFormat:@"%d",_userid] forKey:@"USERID"];
    [userDef setObject:_userName forKey:@"USERNAME"];
    [userDef setObject:_userToken forKey:@"USERTOKEN"];
    [userDef setObject:_userPassword forKey:@"USERPASSWORD"];
    
    [userDef synchronize];
}

-(userDataModel * )userLoadMyInfoFromDefualt{
    
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    
    userDataModel * userModel = [[userDataModel alloc] init];
    
    NSString * checkToken =  [userDef objectForKey:@"USERTOKEN"];
    
    if ( !([checkToken isEqualToString:@""] || [checkToken isKindOfClass:[NSNull class]] )) {
        userModel.avatarURL =  [userDef objectForKey:@"AVATARURL"];
        userModel.coverURL = [userDef objectForKey:@"COVERURL"];
        userModel.userid = [[userDef objectForKey:@"USERID"] intValue];
        userModel.userName = [userDef objectForKey:@"USERNAME"];
        userModel.userToken =  [userDef objectForKey:@"USERTOKEN"];
        userModel.userPassword =  [userDef objectForKey:@"USERPASSWORD"];
        
        return userModel;
    }else{
        return nil;
    }
}

/*
 {
 "status": "1",
 "token": "eyJpdiI6IjBDV29BK0o3TTJJZnNQMldISE5RMHc9PSIsInZhbHVlIjoiMEFcL1h0OVp0eTVGV0ZDMEV0eW9cL1NjcVlaTmdwbmNzOFJEbXRVV285RVdINlZrdjZzd21PYVZORWpcL1J1K3hZTWVSMERyMm1QWWFsa29aZVVTK0FNMFNnanFEdXZpOEhwcElsV0I4Y3Z6MG5yYTcwS1NSTjNyWFArS3NzRkNycnpTRjhmNDZPR01ueGZRQURoeDJtSDhBPT0iLCJtYWMiOiJmZTgyNDk3NGYzYTgyZDhkOTIzMDNiZmM5MzY4NjhiYWJmMjZiM2YxMDE3YmQ3NDcxZTBkZmEyMThlMzFmNzFlIn0",
 "api_token": "75fb8cd04efb1ca890fde1e6ed26c083",
 "user": {
 "id": "6",
 "about": "",
 "active": "1",
 "avatar_id": "88845",
 "cover_id": "94385",
 "cover_position": "157",
 "email": "idolkorrio@gmail.com",
 "email_verification_key": "48150dc85ae1fafb39a3f10be72c6728",
 "email_verified": "1",
 "language": "thai",
 "last_logged": "1426764505",
 "name": "korr",
 "password": "039a726ac0aeec3dde33e45387a7d4ac",
 "time": "1413297961",
 "timestamp": "2015-03-19 18:28:22",
 "timezone": "Pacific\/Midway",
 "type": "user",
 "username": "korrio",
 "verified": "0",
 "birthday": null,
 "gender": null,
 "avatar": "photos\/2015\/01\/6oCCf_88845_fb60d93c210068b4a03cd16c0018d8dd.jpg",
 "cover": "photos\/2015\/01\/64Ter_94385_35a4e28b82263cf441601c2cca9aa6cc.jpg"
 }
 }
 */


@end
