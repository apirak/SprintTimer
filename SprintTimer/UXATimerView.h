//
//  UXATimerView.h
//  SprintTimer
//
//  Created by Apirak Panatkool on 8/27/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define UXA_TIMERVIEW_WIDTH (768-120)
#define UXA_TIMERVIEW_PADDING 40
#define UXA_TIMERVIEW_MARGIN 5
#define UXA_HANDLE_WIDTH (UXA_TIMERVIEW_PADDING*2)
#define TIMER_COUNT_DOWN 0.5


@interface UXATimerView : UIControl <AVAudioPlayerDelegate>

@property (nonatomic,assign) int angle;
@property (nonatomic,assign) int secondsBegin;
@property (nonatomic,assign) int secondsLeft;
@property (strong, nonatomic)  AVAudioPlayer *audioPlayer;

-(void)updateTotalTime:(int)totalTime;
-(void)updateCounter;
-(void)countdownTimer;

@end
