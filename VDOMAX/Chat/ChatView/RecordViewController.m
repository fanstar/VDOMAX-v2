//
//  RecordViewController.m
//  VDOMAXCHAT
//
//  Created by shadow on 25/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController
@synthesize delegate;
@synthesize recorder;
@synthesize isRecording;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"tmpSound.wav"];
    
    NSURL * tempRecFile = [NSURL fileURLWithPath:soundFilePath];
    
//    NSDictionary *recSettings = [NSDictionary
//                                 dictionaryWithObjectsAndKeys:
//                                 [NSNumber numberWithInt:AVAudioQualityMin],
//                                 AVEncoderAudioQualityKey,
//                                 [NSNumber numberWithInt:16],
//                                 AVEncoderBitRateKey,
//                                 [NSNumber numberWithInt: 2],
//                                 AVNumberOfChannelsKey,
//                                 [NSNumber numberWithFloat:44100.0],
//                                 AVSampleRateKey,
//                                 nil];
    
//    NSDictionary *recSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
//                              [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,// kAudioFormatLinearPCM
//                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
//                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
//                              [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
//                              [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
//                              [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,nil];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt: 16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithBool: NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithBool: NO] forKey:AVLinearPCMIsFloatKey];
    [recordSetting setValue:[NSNumber numberWithInt: AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];

    
    
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:tempRecFile settings:recordSetting error:nil];
    [self.recorder setDelegate:self];
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
    
//    isNotRecording = YES;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btActStartRecord:(id)sender {
    
    if(!isRecording){
        isRecording = YES;
//        [self.btStartRecord setTitle:@"Stop Record"  forState:UIControlStateNormal];
        
        [self.btStartRecord setBackgroundImage:[UIImage imageNamed:@"recRecording.png"] forState:UIControlStateNormal];
//        recStateLabel.text = @"Recording";
        
//        [recorder setDelegate:self];
//        [recorder prepareToRecord];
        [recorder record];
        
    }
    else{
        isRecording = NO;
        [self.btStartRecord setBackgroundImage:[UIImage imageNamed:@"recNonRecord.png"] forState:UIControlStateNormal];
       // [self.btStartRecord setTitle:@"Start Record" forState:UIControlStateNormal];
//        playButton.hidden = NO;
//        recStateLabel.text = @"Not recording";
        [recorder stop];
    }
    
    
}

- (IBAction)btActSendRecord:(id)sender {
    
    if (isRecording) {
        isRecording = NO;
//        [self.btStartRecord setTitle:@"Start Record" forState:UIControlStateNormal];
        [self.btStartRecord setBackgroundImage:[UIImage imageNamed:@"recNonRecord.png"] forState:UIControlStateNormal];
        [recorder stop];
    }
    
    if(soundFilePath.length>0)[self.delegate DidSendRecordView:self FilePath:soundFilePath];
    
//    if([self exportAssetAsWaveFormat:self.recorder.url]){
//        NSLog(@"success");
//        
//        if(outPath.length>0)[self.delegate DidSendRecordView:self FilePath:outPath];
//        
//    }else{
//        NSLog(@"failed");
//    }
    
    //[self.delegate DidSendRecordView:self FileURL:self.recorder.url];
}

- (IBAction)btActCancel:(id)sender {
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    //[self.view removeFromSuperview];
    
    [self.delegate DidcancelRecordView];
    
}

/*
-(BOOL)exportAssetAsWaveFormat:(NSURL*)filePath
{
    NSError *error = nil ;
    
    NSDictionary *audioSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [ NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                  [ NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                  [ NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                  [ NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                  [ NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                  [ NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                                  [ NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                  [ NSData data], AVChannelLayoutKey, nil ];
    
    //NSString *audioFilePath = filePath;
    AVURLAsset * URLAsset = [[AVURLAsset alloc]  initWithURL:filePath options:nil];
    
    if (!URLAsset) return NO ;
    
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:URLAsset error:&error];
    if (error) return NO;
    
    NSArray *tracks = [URLAsset tracksWithMediaType:AVMediaTypeAudio];
    if (![tracks count]) return NO;
    
    AVAssetReaderAudioMixOutput *audioMixOutput = [AVAssetReaderAudioMixOutput
                                                   assetReaderAudioMixOutputWithAudioTracks:tracks
                                                   audioSettings :audioSetting];
    
    if (![assetReader canAddOutput:audioMixOutput]) return NO ;
    
    [assetReader addOutput :audioMixOutput];
    
    if (![assetReader startReading]) return NO;
    
    
    
    NSString *title = @"WavConverted";
    NSArray *docDirs = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [docDirs objectAtIndex: 0];
     outPath = [[docDir stringByAppendingPathComponent :title]
                         stringByAppendingPathExtension:@"wav" ];
    
    
    NSLog(@"outPath:%@",outPath);
    
    NSURL *outURL = [NSURL fileURLWithPath:outPath];
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:outURL
                                                          fileType:AVFileTypeWAVE
                                                             error:&error];
    if (error) return NO;
    
    AVAssetWriterInput *assetWriterInput = [ AVAssetWriterInput assetWriterInputWithMediaType :AVMediaTypeAudio
                                                                                outputSettings:audioSetting];
    assetWriterInput. expectsMediaDataInRealTime = NO;
    
    if (![assetWriter canAddInput:assetWriterInput]) return NO ;
    
    [assetWriter addInput :assetWriterInput];
    
    if (![assetWriter startWriting]) return NO;
    
    
//    [assetReader retain];
//    [assetWriter retain];
    
    [assetWriter startSessionAtSourceTime:kCMTimeZero ];
    
    dispatch_queue_t queue = dispatch_queue_create( "assetWriterQueue", NULL );
    
    [assetWriterInput requestMediaDataWhenReadyOnQueue:queue usingBlock:^{
        
        NSLog(@"start");
        
        while (1)
        {
            if ([assetWriterInput isReadyForMoreMediaData]) {
                
                CMSampleBufferRef sampleBuffer = [audioMixOutput copyNextSampleBuffer];
                
                if (sampleBuffer) {
                    [assetWriterInput appendSampleBuffer :sampleBuffer];
                    CFRelease(sampleBuffer);
                } else {
                    [assetWriterInput markAsFinished];
                    break;
                }
            }
        }
        
        [assetWriter finishWriting];
//        [assetReader release ];
//        [assetWriter release ];
        
        NSLog(@"finish");
        
        
//        [self.delegate DidSendRecordView:self FilePath:outPath];
        
        
    }];
    
    //dispatch_release(queue);
    
    [self.delegate DidSendRecordView:self FilePath:outPath];
    
}
*/

@end
