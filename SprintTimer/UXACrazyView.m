//
//  UXACrazyView.m
//  SprintTimer
//
//  Created by Apirak Panatkool on 9/9/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import "UXACrazyView.h"

@interface UXACrazyView(){
    BOOL _dragTimer;
    float _heightPerSecond;
    float _paperHeightPerSecond;
    int _handlerHeight;
    UILabel *_countdownLabel;
    
    int handleBarX;
    int handleBarY;
    int _paperX, _paperY;
    int _blockWidth, _blockHeight;
}
@end

@implementation UXACrazyView

@synthesize secondsBegin;

int hours, minutes, seconds;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
        self.secondsBegin = 300;
        
        _paperX = (UXA_CRAZY_PADDING+UXA_CRAZY_MARGIN);
        _paperY = (UXA_CRAZY_PADDING+UXA_CRAZY_MARGIN);
        
        _blockWidth = (UXA_CRAZY_PAPER_WIDTH - (UXA_CRAZY_PADDING*2) - (UXA_CRAZY_MARGIN*2))/4;
        _blockHeight = (UXA_CRAZY_PAPER_HEIGHT - (UXA_CRAZY_PADDING*2) - (UXA_CRAZY_MARGIN*2))/2;
        
        _handlerHeight = (_blockHeight*2);
        
        handleBarX = (UXA_CRAZY_WIDTH-(UXA_CRAZY_COUNTDOWN_WIDTH/2));
        handleBarY = (UXA_CRAZY_PADDING+UXA_CRAZY_MARGIN);
        
        _countdownLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(handleBarX, handleBarY , UXA_CRAZY_HANDLE_WIDTH, UXA_CRAZY_HANDLE_WIDTH) ];
        _countdownLabel.opaque = NO;
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        _countdownLabel.textColor = [UIColor redColor];
        _countdownLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(24.0)];
        _countdownLabel.text =  [NSString stringWithFormat:@"%02d:%02d", 5, 0];
        
        [self setCountDownPosition];
        [self addSubview:_countdownLabel];
    }
    return self;
}

#pragma mark - UIControl Position -

- (void)setCountDownPosition {
    CGRect frame = _countdownLabel.frame;
    
    CGPoint handleCenter = [self handleBeginPoint:_handlerHeight];

    frame.origin.x = handleCenter.x;
    frame.origin.y = handleCenter.y;
    _countdownLabel.frame = frame;
}


#pragma mark - Drawing Functions -

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();


    [self drawCountDownBar:context];
    [self drawPaper:context];
    [self drawTheHandle:context];
}

-(void) drawPaper:(CGContextRef)context{
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, (_paperX+_blockWidth), _paperY);
    CGContextAddLineToPoint(context, (_paperX+_blockWidth), (_paperY+_blockHeight*2));
    
    CGContextMoveToPoint(context, (_paperX+_blockWidth*2), _paperY);
    CGContextAddLineToPoint(context, (_paperX+_blockWidth*2), (_paperY+_blockHeight*2));
    
    CGContextMoveToPoint(context, (_paperX+_blockWidth*3), _paperY);
    CGContextAddLineToPoint(context, (_paperX+_blockWidth*3), (_paperY+_blockHeight*2));
    
    CGContextMoveToPoint(context, _paperX, (_paperY+_blockHeight));
    CGContextAddLineToPoint(context, (_paperX+_blockWidth*4), (_paperY+_blockHeight));
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
}

-(void) drawCountDownBar:(CGContextRef)context {
    [self drawCrazyRectangle:context number:1 height:_blockHeight-70];
    [self drawCrazyRectangle:context number:2 height:_blockHeight-50];
    [self drawCrazyRectangle:context number:3 height:(_blockHeight/2)];
    [self drawCrazyRectangle:context number:4 height:_blockHeight];
    [self drawCrazyRectangle:context number:5 height:_blockHeight-10];
    [self drawCrazyRectangle:context number:6 height:_blockHeight-50];
    [self drawCrazyRectangle:context number:7 height:_blockHeight-200];
    [self drawCrazyRectangle:context number:8 height:_blockHeight-10];
}

-(void) drawCrazyRectangle:(CGContextRef)context number:(int)barNumber height:(int)height {
    if (barNumber < 5) {
        [self drawRectangle:context Rect:CGRectMake(_paperX+_blockWidth*(barNumber-1), _paperY+(_blockHeight-height), _blockWidth, height)];
    } else {
        [self drawRectangle:context Rect:CGRectMake(_paperX+_blockWidth*(barNumber-5), _paperY+(_blockHeight-height)+_blockHeight, _blockWidth, height)];
    }
}

-(void) drawRectangle:(CGContextRef)context Rect:(CGRect)rectangle {

    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextFillRect(context, rectangle);
}

-(void) drawTheHandle:(CGContextRef)context {
    CGContextSaveGState(context);
    
    CGPoint handleCenter = [self handleBeginPoint:_handlerHeight];
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 4.0);
    CGContextMoveToPoint(context, handleBarX, handleBarY+(_blockHeight*2-_handlerHeight));
    CGContextAddLineToPoint(context, handleBarX, _paperY+(_blockHeight*2));
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
    
    if (_dragTimer == true) {
        [[UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:1]set];
    } else {
        [[UIColor colorWithWhite:1.0 alpha:1]set];
    }
    
    CGContextFillEllipseInRect(context, CGRectMake(handleCenter.x, handleCenter.y, UXA_CRAZY_HANDLE_WIDTH, UXA_CRAZY_HANDLE_WIDTH));
    
    CGContextRestoreGState(context);
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddEllipseInRect(context, CGRectMake(handleCenter.x, handleCenter.y, UXA_CRAZY_HANDLE_WIDTH, UXA_CRAZY_HANDLE_WIDTH));
    [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]set];
    CGContextDrawPath(context, kCGPathStroke);

}

#pragma mark - UIControl Override -

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
//    CGPoint touchPoint = [touch locationInView:self];
    
    [super beginTrackingWithTouch:touch withEvent:event];
    _dragTimer = true;
    
    NSLog(@"begin Tracking");
    
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

#pragma mark - Timer Countdown -

- (void)updateSecondLeft:(int)secondLeft; {
    
    hours = secondLeft / 3600;
    minutes = (secondLeft % 3600) / 60;
    seconds = (secondLeft % 3600) % 60;
    
    _heightPerSecond = ((float)(_blockHeight*2)/(float)self.secondsBegin);
    _paperHeightPerSecond = ((float)(_blockHeight*8)/(float)self.secondsBegin);
    
    _countdownLabel.text =  [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    _handlerHeight = _heightPerSecond * secondLeft;
    
    [self setCountDownPosition];
    [self setNeedsDisplay];
}

#pragma mark - Math -

-(void)movehandle:(CGPoint)lastPoint{
    if((lastPoint.y > UXA_CRAZY_HANDLE_RADIUS) && (lastPoint.y < UXA_CRAZY_HANDLE_RADIUS+(_blockHeight*2))) {
        _handlerHeight = (_blockHeight*2)-(lastPoint.y-UXA_CRAZY_HANDLE_RADIUS);
    } else {
        if(lastPoint.y > UXA_CRAZY_HANDLE_RADIUS) {
            lastPoint.y = UXA_CRAZY_HANDLE_RADIUS;
        } else {
            lastPoint.y = UXA_CRAZY_HANDLE_RADIUS+(_blockHeight*2);
        }
        
    }
    
    if (_delegate != nil) {
        [_delegate changeSecondLeft:(_handlerHeight/_heightPerSecond)];
    }
    
    [self setCountDownPosition];
    [self setNeedsDisplay];
}

-(CGPoint)handleBeginPoint:(int)handlerHeight {
    CGPoint result;
    result.y = round(handleBarY-UXA_CRAZY_HANDLE_RADIUS+(_blockHeight*2-handlerHeight));
    result.x = round(handleBarX-UXA_CRAZY_HANDLE_RADIUS);
    
    return result;
}

@end
