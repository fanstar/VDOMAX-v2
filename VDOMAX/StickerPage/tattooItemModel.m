//
//  PostDataModel.m
//  VDOMAX
//
//  Created by fanstar on 4/6/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "tattooDataModel.h"

@implementation tattooDataModel

+(id)tattooCreateObjectWithDict:(NSDictionary *)dict{
       
    tattooDataModel * datamodel = [[tattooDataModel alloc] init];
    
    datamodel.tattooGroupID = [[dict objectForKey:@"id"] intValue];
    datamodel.tattooGroupName = [dict objectForKey:@"name"];
    datamodel.tattooGroupDesc = [dict objectForKey:@"desc"];
    datamodel.tattooGroupLogoURL = [NSString stringWithFormat:@"%@/assets/items/tattoo/%@",kIPServiceAddress,[dict objectForKey:@"imgpath"]];
    datamodel.tattooGroupCatID = [[dict objectForKey:@"cat_id"] intValue];
    datamodel.tattooGroupPrice = [[dict objectForKey:@"price"] intValue];
    datamodel.tattooGroupUserIDCreate = [dict objectForKey:@"create_by_id"];
    datamodel.tattooGroupUserNameCreate = [dict objectForKey:@"create_by_name"];
    datamodel.tattooDateLife = [[dict objectForKey:@"day"] intValue];
    
    
    //item set
    NSArray * items = [dict objectForKey:@"itemset"];
    NSMutableArray * tmp = [[NSMutableArray alloc] init];
    
    for (NSString * imagename in items) {
        NSString * urlImage = [NSString stringWithFormat:@"%@/assets/items/tattoo/%@",kIPServiceAddress,imagename];
        [tmp addObject:urlImage];
    }
    
    datamodel.tattooImageDataSet = tmp;
    
    return  datamodel;
}


/*
 
 "1": {
 "id": "170",
 "name": "cnew",
 "desc": "cnew",
 "cat_id": "3",
 "category_name": "Tattoo",
 "price": "0",
 "imgpath": "169_1419146193_107-loo1.png",
 "create_by_id": "169",
 "owner": 0,
 "create_by_name": "fb_1762697865",
 "day": "0",
 "payperview_month": "0",
 "vote_name": "",
 "vote_point": "0",
 "vote_imgpath": "",
 "vote_order": "0",
 "sprite_name": "",
 "only_one_flag": "",
 "payperview_title": "",
 "quantity": "89",
 "count_tattoo": 8,
 "itemset": [
 "169_1419146193_107-loo1.png",
 "169_1419146193_201-dont follow.png",
 "169_1419146193_302-wha.png",
 "169_1419146193_403-ang.png",
 "169_1419146193_504-ngu.png",
 "169_1419146193_605-shi.png",
 "169_1419146193_706-are you.png",
 "169_1419146193_808-fun.png"
 ],
 "user_item": 0
 },
 
 */
@end
