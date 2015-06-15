//
//  AudioPlayViewController.m
//  VDOMAXCHAT
//
//  Created by shadow on 27/4/57.
//  Copyright (c) พ.ศ. 2557 biz. All rights reserved.
//

#import "AudioPlayViewController.h"

@interface AudioPlayViewController ()

@end

@implementation AudioPlayViewController
@synthesize SoundPath;
@synthesize audioPlayer;

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
    
    /*
    if (SoundPath.length >0) {
        NSURL * url = [NSURL URLWithString:self.SoundPath];
        
        
        if ([[url scheme] isEqualToString:@"http"] ||
            [[url scheme] isEqualToString:@"https"]
            ) {
            
            //NSString *strURlString =@"http://203.151.162.3/voice/df272e8735cc8378dde025acdbaaa828.wav";
            
            //NSLog(@"%@",strURlString);
            
            self.SoundPath =[self.SoundPath stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            
//            NSLog(@"sound url ==%@",self.SoundPath);
            
            NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.SoundPath]];
            NSError *error;
            
            audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
                        audioPlayer.numberOfLoops = 0;
            audioPlayer.delegate = self;
            //            audioPlayer.volume = 10.0f;
                        [audioPlayer prepareToPlay];
            
            //            if (audioPlayer == nil)
            //                NSLog(@"%@", [error description]);
            //            else
            //[audioPlayer play];
            
        
        }
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR MESSAGE" message:@"please check your audio path" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    */
    
    
//    self.view.opaque = NO;
//    self.view.alpha = 0.5f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btActPlay:(id)sender {
    
    if (self.SoundPath.length > 0){
        
            NSURL * url = [NSURL URLWithString:self.SoundPath];
            
            
            if ([[url scheme] isEqualToString:@"http"] ||
                [[url scheme] isEqualToString:@"https"]
                ) {
                
                //NSString *strURlString =@"http://203.151.162.3/voice/df272e8735cc8378dde025acdbaaa828.wav";
                
                //NSLog(@"%@",strURlString);
                
                self.SoundPath =[self.SoundPath stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                
                //            NSLog(@"sound url ==%@",self.SoundPath);
                
                NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.SoundPath]];
                NSError *error;
                
                audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.delegate = self;
                //            audioPlayer.volume = 10.0f;
                [audioPlayer prepareToPlay];
                
                //            if (audioPlayer == nil)
                //                NSLog(@"%@", [error description]);
                //            else
                //[audioPlayer play];
                
                if (playing) {
                    
                    playing = NO;
                    
                    if (audioPlayer == nil){
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ALERT MESSAGE" message:@"not found sound" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                    }
                    else
                        [audioPlayer stop];
                    
                    [self.btPlay setBackgroundImage:[UIImage imageNamed:@"soundStop.png"] forState:UIControlStateNormal];
                    
                    //        [self.btPlay setTitle:@"Play" forState:UIControlStateNormal];
                }else{
                    
                    playing = YES;
                    
                    if (audioPlayer == nil){
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ALERT MESSAGE" message:@"not found sound" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                    }
                    else
                        [audioPlayer play];
                    
                    [self.btPlay setBackgroundImage:[UIImage imageNamed:@"soundPlay.png"] forState:UIControlStateNormal];
                    //        [self.btPlay setTitle:@"Stop" forState:UIControlStateNormal];
                }

            }
        
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ALERT MESSAGE" message:@"not found sound path" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
}

- (IBAction)btActClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //[self.btPlay setTitle:@"Play" forState:UIControlStateNormal];
    [self.btPlay setBackgroundImage:[UIImage imageNamed:@"soundStop.png"] forState:UIControlStateNormal];
    playing = NO;
}


@end
