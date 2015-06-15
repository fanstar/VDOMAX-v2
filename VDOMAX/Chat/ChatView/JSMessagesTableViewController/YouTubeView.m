//
//  YouTubeView.m
//  VDOMAXCHAT
//
//  Created by shadow on 24/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import "YouTubeView.h"

@implementation YouTubeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (YouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame mimeSubType:(NSString *)mimeType
{
    NSString *strMimeType;
    
    if([mimeType length]>0)
    {
        strMimeType = mimeType;
    }
    
    else
    {
        strMimeType =@"x-shockwave-flash"; //@"x-shockwave-mp4";
    }
    
    if (self = [super init])
    {
        // Create webview with requested frame size
        self = (YouTubeView *)[[UIWebView alloc] initWithFrame:frame];
        
        // HTML to embed YouTube video
        
//        NSString *youTubeVideoHTML = @"<html><head>\
//        <body style=\"margin:0\">\
//        <embed id=\"yt\" src=\"%@\" type=\"application/%@\" \
//        width=\"%0.0f\" height=\"%0.0f\"></embed>\
//        </body></html>";
        
//        NSMutableString *youTubeVideoHTML = [NSMutableString string];
//        [youTubeVideoHTML appendString:@"<html><head>"];
//        [youTubeVideoHTML appendString:@"<style type=\"text/css\">"];
//        [youTubeVideoHTML appendString:@"body {"];
//        [youTubeVideoHTML appendString:@"background-color: transparent;"];
//        [youTubeVideoHTML appendString:@"color: white;"];
//        [youTubeVideoHTML appendString:@"}"];
//        [youTubeVideoHTML appendString:@"</style>"];
//        [youTubeVideoHTML appendString:@"</head><body style=\"margin:0\">"];
//        [youTubeVideoHTML appendFormat:@"<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\"", urlString];
//        [youTubeVideoHTML appendFormat:@"width=\"%0.0f\" height=\"%0.0f\"></embed>", self.frame.size.width, self.frame.size.height];
//        [youTubeVideoHTML appendString:@"</body></html>"];
        
        // Populate HTML with the URL and requested frame size
//        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString,strMimeType, frame.size.width, frame.size.height];
        
//        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, frame.size.width, frame.size.height];
        
        
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        
        
        // Load the html into the webview
        //[self loadHTMLString:html baseURL:nil];
    }
    
    return self;
    
}

@end
