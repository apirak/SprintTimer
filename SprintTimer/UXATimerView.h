//
//  UXATimerView.h
//  SprintTimer
//
//  Created by Apirak Panatkool on 8/27/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UXA_TIMER_SIZE 600

#define TB_SAFEAREA_PADDING 40
#define UXA_HANDLE_WIDTH TB_SAFEAREA_PADDING*2

@interface UXATimerView : UIControl
    @property (nonatomic,assign) int angle;
    -(void)updateCounter:(NSTimer *)theTimer;
    -(void)countdownTimer;
@end
