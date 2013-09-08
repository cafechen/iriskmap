//
//  DrawLine.m
//  RiskMap
//
//  Created by Steven on 13-9-5.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine

@synthesize from ;
@synthesize to;

- (id)initWithFrame:(CGRect)frame From: (CGPoint) thefrom To:(CGPoint) theto{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    self.from = thefrom ;
    self.to = theto ;
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"#### from.x %f from.y %f to.x %f to.y %f", from.x, from.y, to.x, to.y) ;
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, to.x - from.x, to.y - from.y);
    CGContextStrokePath(context);
}

@end
