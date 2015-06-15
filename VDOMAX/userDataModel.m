//
//  PostDataModel.m
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "PostDataModel.h"

@implementation PostDataModel
//@synthesize postImageProfileURL;
//@synthesize postName;
//@synthesize postDescription;
//@synthesize postdate;
//@synthesize postLoveCount;
//@synthesize postCommentCount;
//@synthesize postShareCount;
//@synthesize postViewCount;
//@synthesize postThumbURL;
//@synthesize postMediaURL;
//@synthesize postIsLove;

+(id)PostCreateObjectWithDict:(NSDictionary *)dict{
    
    NSDictionary * author = [dict objectForKey:@"author"];
    NSString * avatarAuthorUrl = [NSString stringWithFormat:@"%@/%@",kIPIMAGE,[author objectForKey:@"avatar"]];
    NSString * namePost = [author objectForKey:@"name"];
    NSString * descPost =  ([[dict objectForKey:@"text"] isKindOfClass:[NSNull class]])?@"":[dict objectForKey:@"text"];
    NSString * timestamp = [dict objectForKey:@"timestamp"];
    
    //    int followcount =[[dict objectForKey:@"follow_count"] intValue];
    int viewcount =[[dict objectForKey:@"view"] intValue];
    int lovecount =[[dict objectForKey:@"love_count"] intValue];
    int commentcount =[[dict objectForKey:@"comment_count"] intValue];
    int sharecount =[[dict objectForKey:@"share_count"] intValue];
    
    BOOL islove = [[dict objectForKey:@"is_loved"] boolValue];
    int PostID = [[dict objectForKey:@"id"] intValue];
    
    NSString * urlThumb = @"";
    NSString * media_type = @"";
    NSString * mediaval = @"";
    
    if (![[dict objectForKey:@"media"] isKindOfClass:[NSNull class]]) {//or Photo << intpu
        NSDictionary * dictInfo = [dict objectForKey:@"media"];
        
        urlThumb = [NSString stringWithFormat:@"%@/%@.%@",kIPIMAGE,[dictInfo objectForKey:@"url"],[dictInfo objectForKey:@"extension"]];
        mediaval = urlThumb;
        media_type = @"photo";
        
    }else if (![[dict objectForKey:@"youtube"] isKindOfClass:[NSNull class]]) {//youtube << - input
        NSDictionary * dictInfo = [dict objectForKey:@"youtube"];
        //get thumb and show
        urlThumb = [dictInfo objectForKey:@"thumbnail"];
        mediaval = [dictInfo objectForKey:@"id"];
        media_type = @"youtube";
        
    }else if (![[dict objectForKey:@"clip"] isKindOfClass:[NSNull class]]) { //<<clip  << - input
        NSDictionary * dictInfo = [dict objectForKey:@"clip"];
        urlThumb =[dictInfo objectForKey:@"thumbnail"];
        media_type = @"clip";
        
        if (![[dictInfo objectForKey:@"extension"] isEqualToString:@""]) {
            mediaval = [NSString stringWithFormat:@"%@/%@_ori.%@",kIPIMAGE,[dictInfo objectForKey:@"url"],[dictInfo objectForKey:@"extension"]];
        }else{
            mediaval = [dictInfo objectForKey:@"url"];
        }
        
        
    }else if (![[dict objectForKey:@"soundcloud"] isKindOfClass:[NSNull class]]) {//or soundcloud <<- input
        NSDictionary * dictInfo = [dict objectForKey:@"soundcloud"];
        mediaval = [dictInfo objectForKey:@"uri"];
        media_type = @"soundcloud";
        
    }else{//text type
        media_type = @"text";
        mediaval = descPost;
    }
    
    PostDataModel * datamodel = [[PostDataModel alloc] init];
    
    datamodel.postImageProfileURL = avatarAuthorUrl;
    datamodel.postName = namePost;
    datamodel.postDescription = descPost;
    datamodel.postdate = timestamp;
    datamodel.postLoveCount = lovecount;
    datamodel.postCommentCount = commentcount;
    datamodel.postShareCount = sharecount;
    datamodel.postViewCount = viewcount;
    datamodel.postThumbURL = urlThumb;
    datamodel.postMediaType = media_type;
    datamodel.postIsLove = islove;
    datamodel.postID = PostID;
    datamodel.postMediaValueOrURL = mediaval;
    
    return  datamodel;
}

@end
