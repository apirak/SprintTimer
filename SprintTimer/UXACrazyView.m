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
}
@end

@implementation UXACrazyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

#pragma mark - Drawing Functions -

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawPaper:context];
    [self drawCountDownBar:context];
    [self drawTheHandle:context];
}

-(void) drawPaper:(CGContextRef)context{
    
    int paperX = (UXA_CRAZY_PADDING+UXA_CRAZY_MARGIN);
    int paperY = (UXA_CRAZY_PADDING+UXA_CRAZY_MARGIN);
    
    int blockWidth = (UXA_CRAZY_PAPER_WIDTH - (UXA_CRAZY_PADDING*2) - (UXA_CRAZY_MARGIN*2))/4;
    int blockHeight = (UXA_CRAZY_PAPER_HEIGHT - (UXA_CRAZY_PADDING*2) - (UXA_CRAZY_MARGIN*2))/2;
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, (paperX+blockWidth), paperY);
    CGContextAddLineToPoint(context, (paperX+blockWidth), (paperY+blockHeight*2));
    
    CGContextMoveToPoint(context, (paperX+blockWidth*2), paperY);
    CGContextAddLineToPoint(context, (paperX+blockWidth*2), (paperY+blockHeight*2));
    
    CGContextMoveToPoint(context, (paperX+blockWidth*3), paperY);
    CGContextAddLineToPoint(context, (paperX+blockWidth*3), (paperY+blockHeight*2));
    
    CGContextMoveToPoint(context, paperX, (paperY+blockHeight));
    CGContextAddLineToPoint(context, (paperX+blockWidth*4), (paperY+blockHeight));
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
}

-(void) drawCountDownBar:(CGContextRef)context {
    
}

-(void) drawTheHandle:(CGContextRef)context {
    CGContextSaveGState(context);
    CGPoint handleCenter =  [self pointFromSecondLeft];
    
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

#pragma mark - Math -

-(CGPoint)pointFromSecondLeft {
    CGPoint result;
    result.y = round(200);
    result.x = round(200);
    
    return result;
}

@end
