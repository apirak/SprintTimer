//
//  UXATimerView.h
//  SprintTimer
//
//  Created by Apirak Panatkool on 8/27/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UXA_TIMERVIEW_WIDTH (768-120)
#define UXA_TIMERVIEW_PADDING 40
#define UXA_TIMERVIEW_MARGIN 5
#define UXA_HANDLE_WIDTH (UXA_TIMERVIEW_PADDING*2)
#define TIMER_COUNT_DOWN 0.5

@protocol TimeViewerDelegate <NSObject>
@required
-(void)changeSecondLeft:(NSInteger)secondLeft;
@end

@interface UXATimerView : UIControl 


@property (nonatomic,assign) float angle;
@property (nonatomic,assign) float secondsBegin;
@property (nonatomic, weak) id<TimeViewerDelegate> delegate;

-(void)updateSecondLeft:(float)secondLeft;


@end
