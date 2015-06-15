//
//  Copyright (c) 2013-2014 Cédric Luthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCDYouTubeKit.h"

@interface PlayerEventLogger : NSObject

@property (nonatomic, assign, getter = isEnabled) BOOL enabled; // defaults to `YES`

@end
