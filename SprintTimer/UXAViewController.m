//
//  UXAViewController.m
//  SprintTimer
//
//  Created by Apirak Panatkool on 8/27/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import "UXAViewController.h"

@interface UXAViewController (){
    NSTimer *_timer;
}
@end

@implementation UXAViewController

@synthesize timerLabel;
@synthesize timerButton;
@synthesize crazyButton;
@synthesize totalTimeButton;
@synthesize tabLineBarView;
@synthesize timerView;
@synthesize crazyView;
@synthesize secondsLeft;
@synthesize secondsBegin;
@synthesize timeoutSound;
@synthesize almostSound;
@synthesize nextSound;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    timerView = [[UXATimerView alloc] initWithFrame:CGRectMake((1024-UXA_TIMERVIEW_WIDTH)/2 ,90, UXA_TIMERVIEW_WIDTH, UXA_TIMERVIEW_WIDTH)];
    [timerView addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [timerView setDelegate:self];
    [self.view addSubview:timerView];
    
    
    crazyView = [[UXACrazyView alloc] initWithFrame:CGRectMake((1024-UXA_CRAZY_WIDTH)/2 ,100, UXA_CRAZY_WIDTH, UXA_CRAZY_HEIGHT)];
    [crazyView setHidden:TRUE];
    [crazyView setDelegate:self];
    [self.view addSubview:crazyView];
    
    timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timerButton setTag:1];
    [timerButton setFrame:CGRectMake(62, 45, 97, 33)];
    [timerButton setBackgroundImage:[[UIImage imageNamed:@"Timer_button_selected.png"]
                                      stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [timerButton addTarget:self action:@selector(selectTimerType:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timerButton];
    
    
    crazyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crazyButton setTag:2];
    [crazyButton setFrame:CGRectMake(200, 45, 114, 33)];
    [crazyButton setBackgroundImage:[[UIImage imageNamed:@"Crazy8_button.png"]
                                     stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [crazyButton addTarget:self action:@selector(selectTimerType:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crazyButton];
    
    
    totalTimeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [totalTimeButton setTitleColor:[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[totalTimeButton titleLabel] setFont:[UIFont fontWithName:@"Avenir Next" size:35]];
    [totalTimeButton setFrame:CGRectMake(780, 53, 200, 30)];
    [totalTimeButton setTitle:@"5 Min" forState:UIControlStateNormal];
    [totalTimeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [totalTimeButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [totalTimeButton addTarget:self action:@selector(chooseTimeButtonTapped:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:totalTimeButton];
    
    
    tabLineBarView = [[UIView alloc] initWithFrame:CGRectMake(50, 80, 120, 6)];
    [tabLineBarView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    [self.view addSubview:tabLineBarView];
    
    self.secondsBegin = 60*5;
    self.secondsLeft = self.secondsBegin;
    
    NSString *endSoundFilePath = [NSString stringWithFormat:@"%@/bell.caf", [[NSBundle mainBundle] resourcePath]];
    NSURL *endSoundFileURL = [NSURL fileURLWithPath:endSoundFilePath];
    NSError *endSoundError;
    self.timeoutSound = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:endSoundFileURL
                        error:&endSoundError];

    if (endSoundError) {
        NSLog(@"Error in audioPlayer: %@",
              [endSoundError localizedDescription]);
    } else {
        [self.timeoutSound setNumberOfLoops:0];
        [self.timeoutSound setVolume: 1];
        self.timeoutSound.delegate = self;
        [self.timeoutSound prepareToPlay];
    }
    
    NSString *almostSoundFilePath = [NSString stringWithFormat:@"%@/long_bell.caf", [[NSBundle mainBundle] resourcePath]];
    NSURL *almostSoundFileURL = [NSURL fileURLWithPath:almostSoundFilePath];
    NSError *almostSoundError;
    self.almostSound = [[AVAudioPlayer alloc]
                      initWithContentsOfURL:almostSoundFileURL
                      error:&almostSoundError];
    
    if (almostSoundError) {
        NSLog(@"Error in audioPlayer: %@",
              [almostSoundError localizedDescription]);
    } else {
        [self.almostSound setNumberOfLoops:0];
        [self.almostSound setVolume: 1];
        self.almostSound.delegate = self;
        [self.almostSound prepareToPlay];
    }
    
    NSString *nextSoundFilePath = [NSString stringWithFormat:@"%@/short_bell.caf", [[NSBundle mainBundle] resourcePath]];
    NSURL *nextSoundFileURL = [NSURL fileURLWithPath:nextSoundFilePath];
    NSError *nextSoundError;
    self.nextSound = [[AVAudioPlayer alloc]
                      initWithContentsOfURL:nextSoundFileURL
                      error:&nextSoundError];

    if (nextSoundError) {
        NSLog(@"Error in audioPlayer: %@",
        [nextSoundError localizedDescription]);
    } else {
        [self.nextSound setNumberOfLoops:0];
        [self.nextSound setVolume: 1];
        self.nextSound.delegate = self;
        [self.nextSound prepareToPlay];
    }

    [AVAudioSession sharedInstance];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(sessionDidInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
    [center addObserver:self selector:@selector(sessionRouteDidChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [self countdownTimer];
    
//    [self setTimerName:@"Timer_button.png" Crazy8Name:@"Crazy8_button_selected.png" BarXPoition:196 TimerViewHidden:YES];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)updateCounter {
    if(self.secondsLeft > 0 ){
        self.secondsLeft = self.secondsLeft - TIMER_INTERVAL;
        [timerView updateSecondLeft:self.secondsLeft];
        [crazyView updateSecondLeft:self.secondsLeft];
        

        if(self.secondsLeft <= 0){
            [self.timeoutSound play];
        }
        if(timerView.hidden == YES) {
            float timeBox = self.secondsBegin/8;
            float warningTimerBox = timeBox/4;
            for (float i = 1; i <= 7; i = i + 1.0)
            {
                if (self.secondsLeft > ((timeBox*i)-TIMER_INTERVAL) && self.secondsLeft < (timeBox*i)) {
                    [self.nextSound play];
                }
                if (self.secondsLeft > ((timeBox*i)+warningTimerBox-TIMER_INTERVAL) && self.secondsLeft < (timeBox*i)+warningTimerBox) {
                    [self.almostSound play];
                }
            }
        }
    } else {
        self.secondsLeft = 0;
    }
}


-(void)countdownTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
}


/** This function is called when Circular slider value changes **/
-(void)newValue:(UXATimerView*)timer{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
//    NSLog(@"Slider Value %d",timer.angle);
}

-(void)selectTimerType:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.tag == 1){
        [self setTimerName:@"Timer_button_selected.png" Crazy8Name:@"Crazy8_button.png" BarXPoition:50 TimerViewHidden:NO];
    } else {
        [self setTimerName:@"Timer_button.png" Crazy8Name:@"Crazy8_button_selected.png" BarXPoition:196 TimerViewHidden:YES];
    }
}

-(void)setTimerName:(NSString*)timerName Crazy8Name:(NSString*)crazy8Name BarXPoition:(NSInteger)barXPosition TimerViewHidden:(BOOL)timerViewHidden {
    [timerButton setBackgroundImage:[[UIImage imageNamed:timerName]
                                     stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [crazyButton setBackgroundImage:[[UIImage imageNamed:crazy8Name]
                                     stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5f];
    [tabLineBarView setFrame:CGRectMake(barXPosition, 80, 120, 6)];
    [UIView commitAnimations];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    if(timerViewHidden){
        [timerView setHidden:YES];
        [crazyView setHidden:NO];
    } else {
        [timerView setHidden:NO];
        [crazyView setHidden:YES];
    }
}

-(IBAction)chooseTimeButtonTapped:(id)sender {
    if (_timePicker == nil) {
        _timePicker = [[UXATimePickerViewController alloc] initWithStyle:UITableViewStylePlain];
        _timePicker.delegate = self;
    }

    if (_timePickerPopover == nil) {
        _timePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_timePicker];
        [_timePickerPopover presentPopoverFromRect:CGRectMake(880, 55, 113, 29) inView:self.view
          permittedArrowDirections:UIPopoverArrowDirectionAny
                          animated:YES];
    }
    else {
        [_timePickerPopover dismissPopoverAnimated:YES];
        _timePickerPopover = nil;
    }
}

#pragma mark - TimePickerDelegate method

-(void)selectedTime:(NSInteger)newTime withLabel:(NSString *)selectedLabel {
    int intNewTimer = (int)newTime;
    [self updateTotalTime:intNewTimer];
    
    [totalTimeButton setTitle:selectedLabel forState:UIControlStateNormal];
    
    if (_timePickerPopover) {
        [_timePickerPopover dismissPopoverAnimated:YES];
        _timePickerPopover = nil;
    }
}

-(void)updateTotalTime:(int)totalTime {
    float runningTime = self.secondsBegin - self.secondsLeft;
    self.secondsBegin = totalTime;
    
    if(runningTime < self.secondsBegin && self.secondsLeft > 0){
        self.secondsLeft = self.secondsBegin - runningTime;
    } else {
        self.secondsLeft = self.secondsBegin;
    }
    
    [timerView setSecondsBegin:self.secondsBegin];
    [crazyView setSecondsBegin:self.secondsBegin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TimeViewerDelegate method

-(void)changeSecondLeft:(NSInteger)secondLeft {
    self.secondsLeft = secondLeft;
}

#pragma mark -- Play Alarm --

//-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//    NSLog(@"Play successfully");
//}
//
//-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
//    NSLog(@"Player Decode Error Did Occour");
//}
//
//-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
//    NSLog(@"Player Begin Interruption");
//}
//
//-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
//    NSLog(@"Audio Player End Interruption");
//}

- (void)sessionDidInterrupt:(NSNotification *)notification
{
    switch ([notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue]) {
        case AVAudioSessionInterruptionTypeBegan:
            NSLog(@"Interruption began");
            break;
        case AVAudioSessionInterruptionTypeEnded:
        default:
            NSLog(@"Interruption ended");
            break;
    }
}

- (void)sessionRouteDidChange:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
