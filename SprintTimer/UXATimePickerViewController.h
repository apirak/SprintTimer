//
//  UXATimePickerViewController.h
//  SprintTimer
//
//  Created by Apirak Panatkool on 9/2/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimePickerDelegate <NSObject>
@required
    -(void)selectedTime:(NSInteger *)newTime;
@end

@interface UXATimePickerViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *timeNames;
@property (nonatomic, weak) id<TimePickerDelegate> delegate;

@end