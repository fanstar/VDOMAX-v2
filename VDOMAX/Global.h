//
//  Global.h
//  MaxCalling
//
//  Created by shadow on 23/7/57.
//  Copyright (c) พ.ศ. 2557 vdomax. All rights reserved.
//

//iPhone
#define IS_IPHONE_SIMULATOR ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"] )
#define IS_IPHONE_DEVICE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPHONE (IS_IPHONE_SIMULATOR || IS_IPHONE_DEVICE)

#define IS_IPOD_SIMULATOR ( [[[UIDevice currentDevice] model] isEqualToString:@"iPod touch Simulator"] )
#define IS_IPOD_DEVICE   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_IPOD (IS_IPOD_SIMULATOR || IS_IPOD_DEVICE)

//size
#define IS_HEIGHT_GTE_4 [[UIScreen mainScreen ] bounds].size.height < 568.0f
#define IS_HEIGHT_GTE_5 ([[UIScreen mainScreen ] bounds].size.height >= 568.0f && [[UIScreen mainScreen ] bounds].size.height < 667.0f)
#define IS_HEIGHT_GTE_6 ([[UIScreen mainScreen ] bounds].size.height >= 667.0f && [[UIScreen mainScreen ] bounds].size.height < 736.0f)
#define IS_HEIGHT_GTE_6Plus [[UIScreen mainScreen ] bounds].size.height >= 736.0f

//iPhone4
#define IS_IPOD_4 ( IS_IPOD && IS_HEIGHT_GTE_4 )
#define IS_IPHONE_4 ( IS_IPHONE && IS_HEIGHT_GTE_4 )
#define IS_DEVICE_MODEL_4 ( IS_IPHONE_4 || IS_IPOD_4 )

//iPhone5
#define IS_IPOD_5 ( IS_IPOD && IS_HEIGHT_GTE_5 )
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_5 )
#define IS_DEVICE_MODEL_5 ( IS_IPHONE_5 || IS_IPOD_5 )

//iPhone6
#define IS_IPOD_6 ( IS_IPOD && IS_HEIGHT_GTE_6 )
#define IS_IPHONE_6 ( IS_IPHONE && IS_HEIGHT_GTE_6 )
#define IS_DEVICE_MODEL_6 ( IS_IPHONE_6 || IS_IPOD_6 )

//iPhone6Plus
#define IS_IPOD_6Plus ( IS_IPOD && IS_HEIGHT_GTE_6Plus )
#define IS_IPHONE_6Plus ( IS_IPHONE && IS_HEIGHT_GTE_6Plus )
#define IS_DEVICE_MODEL_6Plus ( IS_IPHONE_6Plus || IS_IPOD_6Plus )



//iPad

#define IS_IPAD_SIMULATOR ( [[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"] )
#define IS_IPAD_DEVICE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] )
#define IS_DEVICE_MODEL_IPAD (IS_IPAD_SIMULATOR || IS_IPAD_DEVICE)
//#define IS_IPAD_DEVICE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IS_OS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kGoogleAPI_KEY @"AIzaSyAeM1Sf1WciaKswEfurBl6-ifmYeV4DIo0"//@"AIzaSyBM6jKPQ54UVextFGeqotINhig7Qq8R3WU"

#define BLUE_COLOR [UIColor colorWithRed:64.0f/255.0f green:184.0f/255.0f blue:234.0f/255.0f alpha:1.0f]

#define kShadowOffsetY (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0f : 2.0f)
#define kShadowBlur (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0f : 5.0f)
#define kStrokeSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0f : 3.0f)

#define kadUnitID @"ca-app-pub-4926130832565195/8751243066"
#define kadUnitID_Intertitail @"ca-app-pub-4926130832565195/2704709463"

#define kIP @"http://www.bizvizard.com"
#define kIPIMAGE @"http://www.bizvizard.com/amwriter/ImageBG"
#define kIPIMAGENEWS @"http://www.bizvizard.com/amwriter/promote"
#define kIPIMAGE_iQuotes @"http://www.bizvizard.com/iquotes/service/upload/amwriter"
#define kIPIMAGE_iQuotes_Avatar @"http://www.bizvizard.com/iquotes/service/upload/useravatar"
#define kFacebookPage @"https://www.facebook.com/AmWriterApp"

//#define kIPIMAGESHAREPATH @"http://www.bizvizard.com/amwriter/imageshare"

#define kBannerHeight (50.0f/320.0f)*self.view.frame.size.width
#define kBannerHeightiPad 90.0f
#define kBanneriAdHeight 50.0f
#define kBanneriAdHeightiPad 66.0f

#define kGetBannerHeight (IS_DEVICE_MODEL_IPAD?kBannerHeightiPad:kBannerHeight)

#define kIPHONE_SIZE CGRectMake(0,0,320,480)

#define kNumItemPerRow_iPhone 3
#define kNumItemPerRow_iPad 4
#define kNumQuerySize 5 // size data : max row display

