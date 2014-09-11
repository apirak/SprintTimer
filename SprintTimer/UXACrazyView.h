//
//  UXACrazyView.h
//  SprintTimer
//
//  Created by Apirak Panatkool on 9/9/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UXA_CRAZY_WIDTH (1024)
#define UXA_CRAZY_HEIGHT (768-120)
#define UXA_CRAZY_PADDING 40
#define UXA_CRAZY_MARGIN 10

#define UXA_CRAZY_COUNTDOWN_WIDTH 200
#define UXA_CRAZY_COUNTDOWN_RADIUS (UXA_CRAZY_COUNTDOWN_WIDTH/2)
#define UXA_CRAZY_PAPER_WIDTH (UXA_CRAZY_WIDTH-UXA_CRAZY_COUNTDOWN_WIDTH)
#define UXA_CRAZY_PAPER_HEIGHT UXA_CRAZY_HEIGHT

#define UXA_CRAZY_HANDLE_WIDTH (UXA_CRAZY_PADDING*2)
#define UXA_CRAZY_HANDLE_RADIUS UXA_CRAZY_PADDING
#define TIMER_COUNT_DOWN 0.5

@interface UXACrazyView : UIControl

@property (nonatomic,assign) int secondsBegin;

-(void)updateSecondLeft:(int)secondLeft;

@end
