//
//  AudioPlayViewController.h
//  VDOMAXCHAT
//
//  Created by shadow on 27/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioPlayViewController : UIViewController<AVAudioPlayerDelegate>
{
    BOOL playing;
}
@property (weak, nonatomic) IBOutlet UIButton *btPlay;
@property (retain, nonatomic) NSString * SoundPath;
@property (retain, nonatomic) AVAudioPlayer * audioPlayer;
- (IBAction)btActPlay:(id)sender;
- (IBAction)btActClose:(id)sender;

@end
