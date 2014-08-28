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
    float _rediusPerSecond;
    UILabel *_countdownLabel;
    NSTimer *_timer;
}
@end

@implementation UXATimerView

int hours, minutes, seconds;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
        self.secondsBegin = 60*5;
        _rediusPerSecond = 360.0 / (float)self.secondsBegin ;

        self.secondsLeft = self.secondsBegin;
        [self countdownTimer];
        
        _radius = self.frame.size.width/2 - TB_SAFEAREA_PADDING;
        _center_x = self.frame.size.width/2;
        _center_y = self.frame.size.height/2;
        self.angle = 89;
        
        _countdownLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(_center_x, _center_y , UXA_HANDLE_WIDTH, UXA_HANDLE_WIDTH) ];
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
    
    [self drawTheCircle:context];
    [self drawTheHandle:context];
}

-(void) drawTheCircle:(CGContextRef)context{
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextMoveToPoint(context, _center_x, _center_y);
    int angle = self.angle != 90 ? self.angle : 89;
    CGContextAddArc(context, _center_x, _center_y, _radius,  ToRad(-90), ToRad(-angle), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
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
    if(self.secondsLeft > 0 ){
        self.secondsLeft -- ;
        hours = self.secondsLeft / 3600;
        minutes = (self.secondsLeft % 3600) / 60;
        seconds = (self.secondsLeft % 3600) % 60;

        _countdownLabel.text =  [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        self.angle = AngleFromTime(self.secondsBegin, self.secondsLeft);
        
        [self setCountDownPosition];
        [self setNeedsDisplay];
    }
    else{
        self.secondsLeft = self.secondsBegin;
    }
}

-(void)countdownTimer{
    self.secondsLeft = hours = minutes = seconds = 0;

    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}


#pragma mark - Math -

-(void)movehandle:(CGPoint)lastPoint{
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    int angleInt = floor(currentAngle);
    self.angle = 360 - angleInt;
    self.secondsLeft = TimeFromAngle(self.secondsBegin, self.angle);
    
    [self setCountDownPosition];
    [self setNeedsDisplay];
}

-(CGPoint)pointFromAngle:(int)angleInt{
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - UXA_HANDLE_WIDTH/2, self.frame.size.height/2 - UXA_HANDLE_WIDTH/2);
    
    CGPoint result;
    result.y = round(centerPoint.y + _radius * sin(ToRad(-angleInt))) ;
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

static inline int AngleFromTime(int begin, int left){
    float rediusPerSecond = 360.0 / (float)begin ;
    float rediusLeft = left * rediusPerSecond;
    return (int)rediusLeft+90;
}

static inline int TimeFromAngle(int begin, int angle){
    float rediusPerSecond = 360.0 / (float)begin ;
    float countAngle = angle > 90 ? angle-90 : 270+angle;
    float time = countAngle / rediusPerSecond;
    return (int)time;
}

@end
