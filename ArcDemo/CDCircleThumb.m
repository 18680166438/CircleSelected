//
//  MDCircleThumb.m
//  ArcDemo
//
//  Created by sfwan on 14-12-21.
//  Copyright (c) 2014年 MIDUO. All rights reserved.
//

#import "CDCircleThumb.h"


@implementation CDCircleThumb{
    CAShapeLayer *_bigCircleLayer;
    CAShapeLayer *_smallCircleLayer;
    CGFloat _shortRadius;
    CGFloat _longRadius;
    CGFloat _rate;
    
    CGPoint _bStartPoint;
    CGPoint _bEndPoint;
    
    CGPoint _sStartPoint;
    CGPoint _sEndPoint;
    
    UIColor *_fillColor;
    UIColor *_strokeColor;
}

-(id) initWithShortCircleRadius:(CGFloat)shortRadius longRadius:(CGFloat)longRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor rate:(CGFloat)rate{
    CGRect frame = CGRectMake(0, 0, longRadius*2, longRadius*2);
    self = [super initWithFrame:frame];
    if (self) {
        _shortRadius = shortRadius;
        _longRadius = longRadius;
        _rate = rate;
        _fillColor = fillColor;
        _strokeColor = strokeColor;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(CGPoint)center{
    return CGPointMake(_longRadius, _longRadius);
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGPoint center = self.center;
    CGFloat angle = _rate * 360;
    self.angle = angle;
    CGFloat clockwiseStartAngle = degreesToRadians(0);;
    
    CGFloat clockwiseEndAngle = degreesToRadians(angle);
    
    self.arc = [UIBezierPath bezierPathWithArcCenter: center radius:_longRadius startAngle:clockwiseStartAngle endAngle:clockwiseEndAngle clockwise:YES];
    CGPoint f = _arc.currentPoint;
    self.strartPoint = f;
    CGFloat nonClockwiseStartAngle = clockwiseEndAngle;
    CGFloat nonClockwiseEndAngle = clockwiseStartAngle;
    [_arc addArcWithCenter:center radius:_shortRadius startAngle:nonClockwiseStartAngle endAngle:nonClockwiseEndAngle clockwise:NO];
    
    CGPoint e = _arc.currentPoint;
    self.endPoint = e;
    
    [_arc closePath];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    [_fillColor set];
    [_arc fill];
//    [_arc stroke];
    CGFloat r = degreesToRadians(angle/2);
    CGFloat x = _longRadius * cosf(r);
    CGFloat y = _longRadius * sinf(r);
    CGPoint p = CGPointMake(center.x+x, center.y+y);

    self.centerPoint = p;
}

-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

@end
