//
//  UXAViewController.h
//  SprintTimer
//
//  Created by Apirak Panatkool on 8/27/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UXATimePickerViewController.h"
#import "UXATimerView.h"
#import "UXACrazyView.h"

#define TIMER_INTERVAL 0.03f

//#define DEFAULT_VIEW @"CRAZY"

@interface UXAViewController : UIViewController <AVAudioPlayerDelegate, TimePickerDelegate, TimeViewerDelegate, CrazyViewerDelegate>

@property (nonatomic, strong) AVAudioPlayer *timeoutSound;
@property (nonatomic, strong) AVAudioPlayer *almostSound;
@property (nonatomic, strong) AVAudioPlayer *nextSound;

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UIButton *crazyButton;
@property (nonatomic, strong) UIButton *timerButton;
@property (nonatomic, strong) UIButton *totalTimeButton;

@property (nonatomic, strong) UIView *tabLineBarView;
@property (nonatomic, strong) UXATimerView *timerView;
@property (nonatomic, strong) UXACrazyView *crazyView;

@property (nonatomic, assign) float secondsBegin;
@property (nonatomic, assign) float secondsLeft;

@property (nonatomic, strong) UXATimePickerViewController *timePicker;
@property (nonatomic, strong) UIPopoverController *timePickerPopover;

-(IBAction)chooseTimeButtonTapped:(id)sender;

@end
