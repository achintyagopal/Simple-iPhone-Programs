//
//  DrawSquare.m
//  UsingCrop
//
//  Created by Achintya Gopal on 3/23/15.
//  Copyright (c) 2015 Achintya Gopal. All rights reserved.
//

#import "DrawSquare.h"
#import "Square.h"

@interface DrawSquare ()

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@end

@implementation DrawSquare

- (instancetype)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    //
    //if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
       // self.multipleTouchEnabled = YES;
    //}
    
    return self;
}

- (void)strokeLine:(Square *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 2;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    //[bp addLineToPoint:line.end];
    [bp addLineToPoint:CGPointMake(line.end.x,line.begin.y)];
    [bp addLineToPoint:line.end];
    [bp addLineToPoint:CGPointMake(line.begin.x,line.end.y)];
    [bp addLineToPoint:line.begin];
    double a[2];
    a[0] = 5.0;
    a[1] = 5.0;
    [bp setLineDash:a count:2 phase:0.0];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect
{

    // Draw finished lines in black
    [[UIColor blackColor] set];
    for (Square *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        Square *line = [[Square alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Square *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Square *line = self.linesInProgress[key];
        self.finishedLines[0] = line;
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

@end
