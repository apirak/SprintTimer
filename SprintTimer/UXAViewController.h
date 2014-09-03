//
//  UXAViewController.h
//  SprintTimer
//
//  Created by Apirak Panatkool on 8/27/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXATimePickerViewController.h"
#import "UXATimerView.h"

@interface UXAViewController : UIViewController <TimePickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, assign) IBOutlet UIButton *crazyButton;
@property (nonatomic, assign) IBOutlet UIButton *timerButton;
@property (nonatomic, assign) IBOutlet UIButton *totalTimeButton;
@property (nonatomic, retain) UIView *tabLineBarView;
@property (nonatomic, retain) UXATimerView *timerView;

@property (nonatomic, strong) UXATimePickerViewController *timePicker;
@property (nonatomic, strong) UIPopoverController *timePickerPopover;

-(IBAction)chooseTimeButtonTapped:(id)sender;

@end
