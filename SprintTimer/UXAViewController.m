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
@synthesize audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timerView = [[UXATimerView alloc] initWithFrame:CGRectMake((1024-UXA_TIMERVIEW_WIDTH)/2 ,100, UXA_TIMERVIEW_WIDTH, UXA_TIMERVIEW_WIDTH)];
    
    [timerView addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [timerView setDelegate:self];
    [self.view addSubview:timerView];
    
    
    crazyView = [[UXACrazyView alloc] initWithFrame:CGRectMake((1024-UXA_CRAZY_WIDTH)/2 ,100, UXA_CRAZY_WIDTH, UXA_CRAZY_HEIGHT)];
    [crazyView setHidden:TRUE];
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
    [[totalTimeButton titleLabel] setFont:[UIFont fontWithName:@"Avenir Next" size:36]];
    [totalTimeButton setFrame:CGRectMake(800, 45, 200, 29)];
    [totalTimeButton setTitle:@"5 min" forState:UIControlStateNormal];
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
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/bell.caf", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:soundFileURL
                        error:&error];
    
    [[AVAudioSession sharedInstance] setDelegate: self];
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    if (setCategoryError) {
        NSLog(@"Error setting category! %@", setCategoryError);
    }
    
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        [self.audioPlayer setNumberOfLoops:0];
        [self.audioPlayer setVolume: 1];
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
    }
    
    [self countdownTimer];
    
    [self setTimerName:@"Timer_button.png" Crazy8Name:@"Crazy8_button_selected.png" BarXPoition:196 TimerViewHidden:YES];
    
}

- (void)updateCounter {
    if(self.secondsLeft > 0 ){
        self.secondsLeft -- ;
        
        [timerView updateSecondLeft:self.secondsLeft];
        
        if(self.secondsLeft == 0){
            [self.audioPlayer play];
        }
    }
    else{
        self.secondsLeft = 0;
    }
}


-(void)countdownTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
}


/** This function is called when Circular slider value changes **/
-(void)newValue:(UXATimerView*)timer{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    NSLog(@"Slider Value %d",timer.angle);
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
        [_timePickerPopover presentPopoverFromRect:CGRectMake(890, 45, 113, 29) inView:self.view
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
    int runningTime = self.secondsBegin - self.secondsLeft;
    self.secondsBegin = totalTime;
    
    if(runningTime < self.secondsBegin && self.secondsLeft > 0){
        self.secondsLeft = self.secondsBegin - runningTime;
    } else {
        self.secondsLeft = self.secondsBegin;
    }
    
    [timerView setSecondsBegin:self.secondsBegin];
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

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Play successfully");
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Player Decode Error Did Occour");
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"Player Begin Interruption");
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    NSLog(@"Audio Player End Interruption");
}

@end
