//
//  RecordViewController.h
//  VDOMAXCHAT
//
//  Created by shadow on 25/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class RecordViewController;
@protocol RecordViewDelegate <NSObject>

-(void)DidcancelRecordView;
-(void)DidSendRecordView:(RecordViewController *) recorderview FilePath:(NSString *) filepart;

@end

@interface RecordViewController : UIViewController<AVAudioRecorderDelegate>
{
    NSString *outPath;
    NSString *soundFilePath;
}
@property(assign, nonatomic) id<RecordViewDelegate>delegate;
@property(retain, nonatomic) AVAudioRecorder * recorder;
@property(assign, nonatomic) BOOL isRecording;
@property (weak, nonatomic) IBOutlet UIButton *btStartRecord;


- (IBAction)btActStartRecord:(id)sender;
- (IBAction)btActSendRecord:(id)sender;
- (IBAction)btActCancel:(id)sender;

@end
