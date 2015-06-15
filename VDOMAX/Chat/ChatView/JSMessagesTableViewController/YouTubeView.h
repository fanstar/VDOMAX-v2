//
//  YouTubeView.h
//  VDOMAXCHAT
//
//  Created by shadow on 24/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeView : UIWebView
- (YouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame  mimeSubType:(NSString *)mimeType;
@end
