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
    int _radius;
    int _center_x;
    int _center_y;
    BOOL _dragTimer;
    UILabel *_countdownLabel;
    
    UIColor *_clockColor;
    UIColor *_clock2Color;
    UIColor *_paperColor;
    UIColor *_guideColor;
}
@end

@implementation UXATimerView

@synthesize secondsBegin;

int hours, minutes, seconds;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
        self.secondsBegin = 300;

        _clockColor  = [UIColor colorWithRed:224.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        _clock2Color = [UIColor colorWithRed:247.0/255.0 green:134.0/255.0 blue:4.0/255.0 alpha:1];
        _paperColor  = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        _guideColor  = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        
        _radius = self.frame.size.width/2 - UXA_TIMERVIEW_PADDING - UXA_TIMERVIEW_MARGIN;
        _center_x = self.frame.size.width/2;
        _center_y = self.frame.size.height/2;
        self.angle = 89;
        
        _countdownLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(_center_x, _center_y , UXA_HANDLE_WIDTH, UXA_HANDLE_WIDTH) ];
        _countdownLabel.opaque = NO;
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        _countdownLabel.textColor = _clockColor;
        _countdownLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(24.0)];
        _countdownLabel.text =  [NSString stringWithFormat:@"%02d:%02d", 5, 0];
        
        [self setCountDownPosition];
        [self addSubview:_countdownLabel];
    }
    return self;
}

#pragma mark - UIControl Override -

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    _dragTimer = true;
    
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    _dragTimer = true;
    
    CGPoint lastPoint = [touch locationInView:self];
    [self movehandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    _dragTimer = false;
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
    
    [self drawTheCircle:context];
    [self drawTheHandle:context];
}

-(void) drawTheCircle:(CGContextRef)context{
    CGContextSetFillColorWithColor(context, [_clockColor CGColor]);
    CGContextMoveToPoint(context, _center_x, _center_y);
    int angle = self.angle != 90 ? self.angle : 89;
    CGContextAddArc(context, _center_x, _center_y, _radius,  ToRad(-90), ToRad(-angle), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

-(void) drawTheHandle:(CGContextRef)context{

    CGContextSaveGState(context);
    CGPoint handleCenter =  [self pointFromAngle: self.angle];
    
    if (_dragTimer == true) {
        [[UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:1]set];
    } else {
        [[UIColor colorWithWhite:1.0 alpha:1]set];
    }

    CGContextFillEllipseInRect(context, CGRectMake(handleCenter.x, handleCenter.y, UXA_HANDLE_WIDTH, UXA_HANDLE_WIDTH));
    
    CGContextRestoreGState(context);
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddEllipseInRect(context, CGRectMake(handleCenter.x, handleCenter.y, UXA_HANDLE_WIDTH, UXA_HANDLE_WIDTH));
    [_clockColor set];
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - Timer Countdown -

- (void)updateSecondLeft:(float)secondLeft; {
    
    hours = secondLeft / 3600;
    minutes = ((int)secondLeft % 3600) / 60;
    seconds = ((int)secondLeft % 3600) % 60;
    
    _countdownLabel.text =  [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    self.angle = AngleFromTime(self.secondsBegin, secondLeft);
    
    [self setCountDownPosition];
    [self setNeedsDisplay];
}


#pragma mark - Math -

-(void)movehandle:(CGPoint)lastPoint{
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    float angleFloat = floor(currentAngle);
    self.angle = 360.0 - angleFloat;
    
    if (_delegate != nil) {
        [_delegate changeSecondLeft:TimeFromAngle(self.secondsBegin, self.angle)];
    }
    
    [self setCountDownPosition];
    [self setNeedsDisplay];
}

-(CGPoint)pointFromAngle:(int)angleInt{
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - UXA_HANDLE_WIDTH/2, self.frame.size.height/2 - UXA_HANDLE_WIDTH/2);
    
    CGPoint result;
    result.y = round(centerPoint.y + _radius * sin(ToRad(-angleInt)));
    result.x = round(centerPoint.x + _radius * cos(ToRad(-angleInt)));
    
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

static inline float AngleFromTime(float begin, float left){
    float rediusPerSecond = 360.0 / begin ;
    float rediusLeft = left * rediusPerSecond;
    return (float)rediusLeft+90;
}

static inline int TimeFromAngle(float begin, float angle){
    float rediusPerSecond = 360.0 / (float)begin ;
    float countAngle = angle > 90 ? angle-90 : 270+angle;
    float time = countAngle / rediusPerSecond;
    return (int)time;
}

@end
