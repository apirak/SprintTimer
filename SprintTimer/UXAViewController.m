//
//  UXAViewController.m
//  SprintTimer
//
//  Created by Apirak Panatkool on 8/27/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import "UXAViewController.h"
#import "UXATimerView.h"

@interface UXAViewController ()


@end

@implementation UXAViewController

@synthesize timerLabel;
@synthesize timerButton;
@synthesize crazyButton;
@synthesize totalTimeButton;
@synthesize tabLineBarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UXATimerView *timerView = [[UXATimerView alloc] initWithFrame:CGRectMake((1024-UXA_TIMER_SIZE)/2 ,120,UXA_TIMER_SIZE, UXA_TIMER_SIZE)];
    
    [timerView addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:timerView];
    
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
    [[totalTimeButton titleLabel] setFont:[UIFont fontWithName:@"Avenir Next" size:24]];
    [totalTimeButton setFrame:CGRectMake(890, 45, 113, 29)];
    [totalTimeButton setTitle:@"5 min" forState:UIControlStateNormal];
    [totalTimeButton addTarget:self action:@selector(selectTotalTime:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:totalTimeButton];
    
    
    tabLineBarView = [[UIView alloc] initWithFrame:CGRectMake(50, 80, 120, 6)];
    [tabLineBarView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    [self.view addSubview:tabLineBarView];
    
}

/** This function is called when Circular slider value changes **/
-(void)newValue:(UXATimerView*)timer{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    NSLog(@"Slider Value %d",timer.angle);
}

-(void)selectTimerType:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.tag == 1){
        [timerButton setBackgroundImage:[[UIImage imageNamed:@"Timer_button_selected.png"]
                                         stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [crazyButton setBackgroundImage:[[UIImage imageNamed:@"Crazy8_button.png"]
                                         stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [UIView beginAnimations:@"MoveView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [tabLineBarView setFrame:CGRectMake(50, 80, 120, 6)];
        [UIView commitAnimations];
        
    } else {
        [timerButton setBackgroundImage:[[UIImage imageNamed:@"Timer_button.png"]
                                         stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [crazyButton setBackgroundImage:[[UIImage imageNamed:@"Crazy8_button_selected.png"]
                                         stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [UIView beginAnimations:@"MoveView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [tabLineBarView setFrame:CGRectMake(196, 80, 120, 6)];
        [UIView commitAnimations];
    }
}

-(void)selectTotalTime:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
