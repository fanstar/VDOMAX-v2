//
//  PostDataModel.m
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "groupChatDataModel.h"

@implementation groupChatDataModel

+(id)groupChatCreateObjectWithDict:(NSDictionary *)dict{
       
    groupChatDataModel * datamodel = [[groupChatDataModel alloc] init];
    datamodel.groupID = [[dict objectForKey:@"id"] intValue];
    datamodel.groupName = [dict objectForKey:@"name"];
    datamodel.groupAvatar = @"http://www.jpl.nasa.gov/spaceimages/images/mediumsize/PIA17011_ip.jpg";//[dict objectForKey:@"avatar"];
    datamodel.groupConverSationType = [dict objectForKey:@"conversationType"];
    datamodel.groupCreatedByUserID = [[dict objectForKey:@"createdBy"] intValue];
    datamodel.groupActiveflag = [[dict objectForKey:@"active"] boolValue];
    datamodel.groupChatDateString = @"long time ago";
    
    
    NSMutableArray * tmpUser = [[NSMutableArray alloc] init];
    NSArray * userMember = [dict objectForKey:@"conversationMembers"];
    for (NSDictionary * dt in userMember) {
        [tmpUser addObject:[userGroupChatDataModel userGroupChatCreateObjectWithDict:dt]];
    }
    
    datamodel.userGroupChats = tmpUser;
    
    return  datamodel;
}

//+(id)commentCreateObjectWithText:(NSString *) textcomment WithUserDataModel:(userDataModel *) userdata{
//    
//    
//    commentDataModel * datamodel = [[commentDataModel alloc] init];
//    
//    datamodel.text = textcomment;
//    datamodel.timestamp = @"2015-04-07 09:12:12";
//    datamodel.userComment = userdata;
//    datamodel.loveCount = 0;
//    
//    return  datamodel;
//
//}

/*
 {
 "id": 1581,
 "name": "Group001",
 "conversationType": "PRIVATE",
 "memberType": "GROUP",
 "createdBy": 1,
 "liveUserId": null,
 "active": true,
 "status": true,
 "deleteFlag": false,
 "timestamp": "2015-06-06T04:51:40.000Z",
 "avatar": null,
 "created_at": "2015-06-06T05:09:31.000Z",
 "updated_at": "2015-06-06T05:09:31.000Z",
 "conversationMembers": [
 {
 "id": 4723,
 "conversationId": 1581,
 "userId": 2,
 "activeFlag": false,
 "inviteFlag": true,
 "adminFlag": false,
 "canInviteFlag": true,
 "inviteAcceptFlag": false,
 "timestamp": "2015-06-06T04:51:40.000Z",
 "created_at": "2015-06-06T05:09:31.000Z",
 "updated_at": "2015-06-06T05:09:31.000Z",
 "conversation_id": 1581
 }
 ]
 },
 
 */

@end
