//
//  MDCircle.m
//  ArcDemo
//
//  Created by sfwan on 14-12-21.
//  Copyright (c) 2014年 MIDUO. All rights reserved.
//

#import "CDCircle.h"
#import "CDCircleThumb.h"
#import "CDCircleGestureRecognizer.h"
#import "CDCircleThumb.h"
#import "CDCircleOverlayView.h"

@implementation CDCircle{
    NSArray *_data;
    NSMutableArray *_thumbs;
    NSArray *_fillColors;
    NSInteger lastIndex;
    
    NSDate *setDirectorDate;
}

-(id)initWithFrame:(CGRect)frame Data:(NSArray *)data fillColors:(NSArray *)fillColors ringWidth:(CGFloat)ringWidth{
    self = [super initWithFrame:frame];
    if (self) {
        _data = data;
        _ringWidth = ringWidth;
        _fillColors = fillColors;
        [self createThumbs];
        self.recognizer = [[CDCircleGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        self.recognizer.rate = 20;
        [self addGestureRecognizer:self.recognizer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)createThumbs{
    _thumbs = [NSMutableArray array];
    
    for (int i = 0; i < _data.count; i++) {
        
        CGFloat width = MIN(self.frame.size.width, self.frame.size.height);
        CGFloat lRadius = width/2;
        self.radius = width/2;
        CGFloat sRadius = lRadius - self.ringWidth;
        CGFloat rate = [_data[i] floatValue];
        
        UIColor *fillColor = [UIColor redColor];
        if (_fillColors.count == _data.count) {
            fillColor = _fillColors[i];
        }
        
        CDCircleThumb *thumb = [[CDCircleThumb alloc] initWithShortCircleRadius:sRadius longRadius:lRadius fillColor:fillColor strokeColor:nil rate:rate];
        [_thumbs addObject:thumb];
    }
}

-(void)drawRect:(CGRect)rect{
    
    CGRect rect1 = CGRectMake(0, 0, CGRectGetHeight(rect) - (2*_ringWidth), CGRectGetWidth(rect) - (2*_ringWidth));
    rect1.origin.x = rect.size.width / 2  - rect1.size.width / 2;
    rect1.origin.y = rect.size.height / 2  - rect1.size.height / 2;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState (ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeCopy);
    
    [self.circleColor setFill];
    _circle = [UIBezierPath bezierPathWithOvalInRect:rect];
    [_circle closePath];
    [_circle fill];
    
    
    _path = [UIBezierPath bezierPathWithOvalInRect:rect1];
    [self.circleColor setFill];
    [_path fill];
    CGContextRestoreGState(ctx);
    
    
    //Drawing Thumbs
//    CGFloat fNumberOfSegments = _data.count;
    
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat totalRotation = 0;//kRotationDegrees;
    CGFloat deltaAngle = 0.0;
    
    
    for (int i = 0; i < _data.count; i++) {
        CDCircleThumb * thumb = [_thumbs objectAtIndex:i];
        thumb.tag = i;
        thumb.layer.position = centerPoint;
        thumb.layer.position = centerPoint;
        [self addSubview:thumb];
        
        if (i==0) {
            CGFloat rate = [_data[0] floatValue];
            CGFloat angle = rate * 360;
//            thumb.transform = CGAffineTransformMakeRotation(degreesToRadians(totalRotation));
//            NSLog(@"%f", radiansToDegrees(atan2(thumb.transform.a, thumb.transform.b)));
            deltaAngle= degreesToRadians(-angle/2) + atan2(thumb.transform.a, thumb.transform.b);
            self.recognizer.currentThumb = thumb;
        }
    }
    
    for (int i = 1; i < _data.count; i++) {
        
        CGFloat rate = [_data[i-1] floatValue];
        CGFloat angle = rate * 360;//108 72 108 72
        CGFloat perSectionDegrees = angle + totalRotation;
        
        CDCircleThumb * thumb = [_thumbs objectAtIndex:i];
        thumb.tag = i;
        
        [thumb setTransform:CGAffineTransformMakeRotation(degreesToRadians(perSectionDegrees))];
         
        totalRotation += angle;
    }
    [self setTransform:CGAffineTransformRotate(self.transform,deltaAngle)];
}


-(void) tapped: (CDCircleGestureRecognizer *) arecognizer{
    if (arecognizer.ended == NO) {
        CGPoint point = [arecognizer locationInView:self];
        NSLog(@"%f", [arecognizer rotation]);
        if ([_path containsPoint:point] == NO) {
            if ([arecognizer rotation]<0) {
                if (setDirectorDate == nil || [[NSDate date] timeIntervalSinceDate:setDirectorDate] > 1) {
                    setDirectorDate = [NSDate date];
                    arecognizer.director = kTurnDirectorLeft;
                }
                
            } else {
                if (setDirectorDate == nil || [[NSDate date] timeIntervalSinceDate:setDirectorDate] > 0.5) {
                    setDirectorDate = [NSDate date];
                    arecognizer.director = kTurnDirectorRight;
                }
            }
            
            // 设置滑动时的控制变量(设置滑动的幅度)
            NSInteger index = [self circleSearchCurrentThumb];
            if (index == 0 && self.recognizer.director == kTurnDirectorRight) {
                self.recognizer.rate = 2;
            } else if (index == _thumbs.count -1 && self.recognizer.director == kTurnDirectorLeft) {
                self.recognizer.rate = 2;
            } else {
                self.recognizer.rate = 10;
            }
            
//            NSInteger isOver = [self isOverTheBorder];
//            if (isOver == 0) {
//                // 无越界
//            } else if(isOver == -1){
//                // 逆时针越界
////                NSLog(@"逆时针越界");
//                return;
//            } else if (isOver == 1) {
//                // 顺时针越界
////                NSLog(@"顺时针越界");
//                return;
//            }
            
//            CDCircleThumb *thumb = self.thumbs[0];
//            CGFloat deltaAngle= atan2(self.transform.a, self.transform.b);
//            NSLog(@"ff  %f", radiansToDegrees(deltaAngle));
//            if (radiansToDegrees(deltaAngle) < 0 && radiansToDegrees(deltaAngle) > -5) {
//                return;
//            }
            if ([self.delegate respondsToSelector:@selector(circle:Move:)]) {
                BOOL move = [self.delegate circle:self Move:[arecognizer rotation]];
                if (move) {
                    [self setTransform:CGAffineTransformRotate([self transform], [arecognizer rotation])];
                    self.recognizer.isOver = NO;
                } else {
                    self.recognizer.isOver = YES;
                }
            }
        }
    }
}

-(CDCircleThumb *)circleLocationAtIndex:(NSInteger)index{
    CDCircle *view = self;
    
    CDCircleThumb *thumb = view.thumbs[index];
    CGFloat deltaAngle= degreesToRadians(-thumb.angle/2) + atan2(thumb.transform.a, thumb.transform.b);
    [UIView animateWithDuration:0.35 animations:^{
        view.transform = CGAffineTransformMakeRotation( deltaAngle);
    }];
    self.recognizer.currentThumb = thumb;
    return thumb;
}

-(CDCircleThumb *)circleLocationAtTheCurrentThumb
{
    NSInteger index = [self circleSearchCurrentThumb];
    CDCircleThumb *thumb = [self circleLocationAtIndex:index];
    return thumb;
}



-(NSInteger)circleSearchCurrentThumb{
    CDCircle *view = self;
    NSInteger index = 0;
    for (int i = 0; i < view.thumbs.count; i++) {
        CDCircleThumb *thumb = view.thumbs[i];
        CGPoint p1 = [thumb convertPoint:thumb.strartPoint toView:nil];
        CDCircleThumb *t2 = nil;
        if (i < view.thumbs.count -1) {
            t2 = view.thumbs[i+1];
        } else {
            t2 = view.thumbs[0];
        }
        
        CGPoint p2 = [t2 convertPoint:t2.strartPoint toView:nil];
        
        CGFloat d = ABS(p1.x-p2.x);
        CGFloat x = MIN(p1.x, p2.x);
        CGFloat y = MAX(p1.y, p2.y);
        CGRect rect1 = CGRectMake(x, y, d, _radius/2);
        CGPoint cp = view.overlayView.controlPoint;
        if (CGRectContainsPoint(rect1, cp)) {
            index = i+1;
            if (index >= self.thumbs.count) {
                index = 0;
            }
            break;
        }
    }
    NSLog(@"%ld", index);
    return index;
}

-(NSInteger)isOverTheBorder{
//    CDCircle *view = self;
//    NSInteger lastIndex = 0;
    NSInteger index = [self circleSearchCurrentThumb];
    if (lastIndex != index) {
        
    }
    if (lastIndex > index) {
        if (index == 0 && lastIndex == _thumbs.count-1) {
            lastIndex = index;
            return -1;//逆时针越界
        }
        lastIndex = index;
        return 0;
    } else {
        if (index == _thumbs.count-1 && lastIndex == 0) {
            lastIndex = index;
            return 1;// 顺时针越界
        }
        lastIndex = index;
        return 0;
    }
    
}

@end
