//
//  RoundProgressControlLayer.m
//  libeqbeats
//
//  Created by Tyrone Trevorrow on 1-06-13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "RoundProgressControlLayer.h"
#import "motion_headers.h"

@implementation RoundProgressControlLayer
@dynamic progress;

static UIColor *kUnfinishedColor = nil;
static UIColor *kFinishedColor = nil;

+ (void) initialize
{
    kUnfinishedColor = [UIColor colorWithRed: 184.0/255.0 green:52.0/255.0 blue:139.0/255.0 alpha:1];
    kFinishedColor = [UIColor colorWithRed: 65.0/255.0 green:52.0/255.0 blue:184.0/255.0 alpha:1];
}

+ (BOOL) needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString: @"progress"]) {
        NSLog(@"!");
        return YES;
    } else {
        return [super needsDisplayForKey: key];
    }
}

- (id<CAAction>) actionForKey:(NSString *)event
{
    if ([event isEqualToString: @"progress"]) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath: event];
        anim.fromValue = [self.presentationLayer valueForKey: event];
        
        return anim;
    }
    return [super actionForKey: event];
}

- (void) drawInContext:(CGContextRef)ctx
{
    [super drawInContext: ctx];
    [self drawArcsInContext: ctx];
    [self drawStopInContext: ctx];
}

- (void) drawArcsInContext:(CGContextRef)ctx
{
    CGRect rect = self.bounds;
    CGFloat progress = [[self presentationLayer] progress];
    CGFloat angle = (progress * M_PI * 2) - M_PI_2;
    
    CGContextSetFillColorWithColor(ctx, kUnfinishedColor.CGColor);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    CGPathAddArc(path, NULL, center.x, center.y, rect.size.width/2.0, -M_PI_2, angle, NO);
    CGPathAddLineToPoint(path, NULL, center.x, center.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    path = nil;
    CGContextSetFillColorWithColor(ctx, kFinishedColor.CGColor);
    CGContextFillPath(ctx);
}

- (void) drawStopInContext: (CGContextRef) ctx
{
    CGRect rect = self.bounds;
    rect = CGRectInset(rect, rect.size.width/3.0, rect.size.height/3.0);
    rect = CGRectMake(roundf(rect.origin.x), roundf(rect.origin.y), roundf(rect.size.width), roundf(rect.size.height));
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, rect);
}

@end
