//
//  PointView.m
//  ArcDemo
//
//  Created by sfwan on 14-12-24.
//  Copyright (c) 2014年 MIDUO. All rights reserved.
//

#import "PointView.h"
#define kArrowWidth         7
#define kArrowHeight        5

@implementation PointView
{
    UIColor *_strokeColor;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_strokeColor == nil) {
        _strokeColor = [UIColor orangeColor];
    }
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
    CGContextSetLineWidth(context, 2);
    
    CGContextMoveToPoint(context, 0, kArrowHeight);
    CGContextAddLineToPoint(context, (rect.size.width-kArrowWidth)/2, kArrowHeight);
    CGContextAddLineToPoint(context, rect.size.width/2, 0);
    CGContextAddLineToPoint(context, rect.size.width/2 + kArrowWidth/2, kArrowHeight);
    CGContextAddLineToPoint(context, rect.size.width, kArrowHeight);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, 0, kArrowHeight);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return NO;
}

@end
