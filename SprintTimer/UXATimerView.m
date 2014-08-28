//
//  UXATimerView.m
//  SprintTimer
//
//  Created by Apirak Panatkool on 8/27/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import "UXATimerView.h"

/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@interface UXATimerView(){
    int radius;
    int center_x;
    int center_y;
    UILabel *_countdownLabel;
    NSTimer *_timer;
}
@end

@implementation UXATimerView

int hours, minutes, seconds;
int secondsLeft;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;

        secondsLeft = 125;
        [self countdownTimer];
        
        radius = self.frame.size.width/2 - TB_SAFEAREA_PADDING;
        center_x = self.frame.size.width/2;
        center_y = self.frame.size.height/2;
        self.angle = 0;
        
        _countdownLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(center_x, center_y , UXA_HANDLE_WIDTH, UXA_HANDLE_WIDTH) ];
        _countdownLabel.opaque = NO;
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        _countdownLabel.textColor = [UIColor redColor];
        _countdownLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(24.0)];
        _countdownLabel.text =  [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        [self setCountDownPosition];
        [self addSubview:_countdownLabel];
        
    }
    return self;
}

#pragma mark - UIControl Override -

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    [self movehandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}

#pragma mark - UIControl Position -

- (void)setCountDownPosition {
    CGRect frame = _countdownLabel.frame;
    CGPoint point = [self pointFromAngle: self.angle];
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    _countdownLabel.frame = frame;
}

#pragma mark - Drawing Functions -

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextMoveToPoint(context, center_x, center_y);
    CGContextAddArc(context, center_x, center_y, radius,  ToRad(-90), ToRad(-self.angle), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    [self drawTheHandle:context];
}

-(void) drawTheHandle:(CGContextRef)context{
    
    CGContextSaveGState(context);
    CGPoint handleCenter =  [self pointFromAngle: self.angle];
    
    [[UIColor colorWithWhite:1.0 alpha:1]set];
    CGContextFillEllipseInRect(context, CGRectMake(handleCenter.x, handleCenter.y, UXA_HANDLE_WIDTH, UXA_HANDLE_WIDTH));
    
    CGContextRestoreGState(context);
    
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, CGRectMake(handleCenter.x, handleCenter.y, UXA_HANDLE_WIDTH, UXA_HANDLE_WIDTH));
    [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]set];
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - Timer Countdown -

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;

        _countdownLabel.text =  [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else{
        secondsLeft = 125;
    }
}

-(void)countdownTimer{
    
    secondsLeft = hours = minutes = seconds = 0;

    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}


#pragma mark - Math -

-(void)movehandle:(CGPoint)lastPoint{
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    int angleInt = floor(currentAngle);
    self.angle = 360 - angleInt;
    
    [self setCountDownPosition];
    [self setNeedsDisplay];
}

-(CGPoint)pointFromAngle:(int)angleInt{
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - UXA_HANDLE_WIDTH/2, self.frame.size.height/2 - UXA_HANDLE_WIDTH/2);
    
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt)));
    
    return result;
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

@end
