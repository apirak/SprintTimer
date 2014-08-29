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
    
    UXATimerView *timerView = [[UXATimerView alloc] initWithFrame:CGRectMake((1024-UXA_TIMER_SIZE)/2 ,120,UXA_TIMER_SIZE, UXA_TIMER_SIZE)];
    
    [timerView addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:timerView];

    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.imageView.frame=CGRectMake(0.0f, 0.0f, 50.0f, 44.0f);
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 35.0f, 50.0f, 44.0f)];
    [button addSubview:label];
    
    UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sampleButton setFrame:CGRectMake(0, 10, 200, 52)];
    [sampleButton setTitle:@"Button Title" forState:UIControlStateNormal];
    [sampleButton setBackgroundImage:[[UIImage imageNamed:@"crazy_icon_selected.png"]
                                      stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [sampleButton addTarget:self action:@selector(buttonPressed)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sampleButton];
    
}

/** This function is called when Circular slider value changes **/
-(void)newValue:(UXATimerView*)timer{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    NSLog(@"Slider Value %d",timer.angle);
}

-(void)buttonPressed {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
