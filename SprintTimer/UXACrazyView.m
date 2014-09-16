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
    int _paperHandlerHeight;
    int _paperAlertHeight;
    UILabel *_countdownLabel;
    
    int handleBarX;
    int handleBarY;
    int _paperX, _paperY;
    int _blockWidth, _blockHeight;
    int _linePadding;
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
        
        _linePadding = 20;
        
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
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, (_paperX+_blockWidth), _paperY);
    CGContextAddLineToPoint(context, (_paperX+_blockWidth), (_paperY+_blockHeight*2+(_linePadding*2)));
    
    CGContextMoveToPoint(context, (_paperX+_blockWidth*2), _paperY);
    CGContextAddLineToPoint(context, (_paperX+_blockWidth*2), (_paperY+_blockHeight*2+(_linePadding*2)));
    
    CGContextMoveToPoint(context, (_paperX+_blockWidth*3), _paperY);
    CGContextAddLineToPoint(context, (_paperX+_blockWidth*3), (_paperY+_blockHeight*2+(_linePadding*2)));
    
    CGContextMoveToPoint(context, _paperX, (_paperY+_blockHeight)+_linePadding);
    CGContextAddLineToPoint(context, (_paperX+_blockWidth*4), (_paperY+_blockHeight)+_linePadding);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
}

-(void) drawCountDownBar:(CGContextRef)context {
    for (int i = 1; i <= 8; i++)
    {
        int height = (_paperHandlerHeight > _blockHeight*(8-i)) ? (_paperHandlerHeight-(_blockHeight*(8-i))) : 0;
        [self drawCrazyRectangle:context number:i height:height];
    }
}

-(void) drawCrazyRectangle:(CGContextRef)context number:(int)barNumber height:(int)handlerHeight {
    int height = (handlerHeight < _blockHeight) ? handlerHeight : _blockHeight;
    
    if(height > _paperAlertHeight){
        CGContextSetRGBFillColor(context, 247.0/255.0, 134.0/255.0, 4.0/255.0, 1.0);
    } else {
        CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    }
    
    int linePosition = (barNumber < 5) ? 1 : 5;
    int lineHeightPosition = (barNumber < 5) ? 0 : _blockHeight;
    int linePaddingTop = (barNumber < 5) ? 0 : _linePadding*2;
    
    CGRect largeBar = CGRectMake(_paperX+_blockWidth*(barNumber-linePosition)+_linePadding,
                              _paperY+(_blockHeight-height)+lineHeightPosition+linePaddingTop,
                              _blockWidth-(_linePadding*2),
                              height);
    CGPathRef roundedRectPath = [self pathForRoundedRect:largeBar radius:5 onlyBottom:FALSE];
    CGContextAddPath(context, roundedRectPath);
    CGContextFillPath(context);

    if(height > _paperAlertHeight){
        CGRect smallBar = CGRectMake(_paperX+_blockWidth*(barNumber-linePosition)+_linePadding,
                                     _paperY+(_blockHeight-_paperAlertHeight)+lineHeightPosition+linePaddingTop,
                                     _blockWidth-(_linePadding*2),
                                     _paperAlertHeight);
        CGPathRef roundedBottomRectPath = [self pathForRoundedRect:smallBar radius:5 onlyBottom:FALSE];
        CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
        CGContextAddPath(context, roundedBottomRectPath);
        CGContextFillPath(context);
    }
}

-(void) drawTheHandle:(CGContextRef)context {
    CGContextSaveGState(context);
    
    CGPoint handleCenter = [self handleBeginPoint:_handlerHeight];

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(context, 8.0);
    CGContextMoveToPoint(context, handleBarX, handleBarY);
    CGContextAddLineToPoint(context, handleBarX, _paperY+(_blockHeight*2));
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 8.0);
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

#pragma mark - Drawing function -

- (CGPathRef) pathForRoundedRect:(CGRect)rect radius:(CGFloat)radius onlyBottom:(BOOL)onlyBottom
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
    if(onlyBottom){
        CGPathMoveToPoint(retPath, NULL, rect.origin.x, rect.origin.y);
        CGPathAddLineToPoint(retPath, NULL, outside_right, outside_top);
    } else {
        CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
        CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
        CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
    }
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
    if(!onlyBottom) {
        CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    }
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
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
    
    _paperHandlerHeight = _paperHeightPerSecond * secondLeft;
    _paperAlertHeight = _blockHeight/4;
    
    _countdownLabel.text =  [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    _handlerHeight = _heightPerSecond * secondLeft;
    
    [self setCountDownPosition];
    [self setNeedsDisplay];
}

#pragma mark - Math -

-(void)movehandle:(CGPoint)lastPoint{
    
    int secondLeft;
    
    if((lastPoint.y > UXA_CRAZY_HANDLE_RADIUS) && (lastPoint.y < UXA_CRAZY_HANDLE_RADIUS+(_blockHeight*2))) {
        _handlerHeight = (_blockHeight*2)-(lastPoint.y-UXA_CRAZY_HANDLE_RADIUS);
        secondLeft = (_handlerHeight/_heightPerSecond);
    } else {
        if(lastPoint.y > UXA_CRAZY_HANDLE_RADIUS) {
            lastPoint.y = UXA_CRAZY_HANDLE_RADIUS;
            secondLeft = 1;
        } else {
            lastPoint.y = UXA_CRAZY_HANDLE_RADIUS+(_blockHeight*2);
            secondLeft = secondsBegin;
        }
    }
    
    if (_delegate != nil) {
        [_delegate changeSecondLeft:secondLeft];
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
