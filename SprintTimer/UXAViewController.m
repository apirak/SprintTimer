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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [timerLabel setText:@"suerman"];
    
    
    UXATimerView *timerView = [[UXATimerView alloc] initWithFrame:CGRectMake((1024-UXA_TIMER_SIZE)/2 ,120,UXA_TIMER_SIZE, UXA_TIMER_SIZE)];
    
    [timerView addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:timerView];

}

/** This function is called when Circular slider value changes **/
-(void)newValue:(UXATimerView*)timer{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    NSLog(@"Slider Value %d",timer.angle);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
