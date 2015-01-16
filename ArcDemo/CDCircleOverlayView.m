/*
 Copyright (C) <2012> <Wojciech Czelalski/CzekalskiDev>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#define kCDBorderAroundButton 3
#define degreesToRadians(x) (M_PI * x / 180.0)
#import "CDCircleOverlayView.h"
#import "CDCircle.h"

#import <QuartzCore/QuartzCore.h>

@implementation CDCircleOverlayView
@synthesize circle, controlPoint, buttonCenter, overlayThumb;
- (id)initWithCircle:(CDCircle *)cicle
{
    CGRect frame = cicle.frame;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.circle = cicle;
        self.circle.overlayView = self;
        self.controlPoint = CGPointMake(circle.center.x, circle.center.y+circle.frame.size.height/2);
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
//    CGFloat x = rect.size.width/2.0;
//    CGFloat y = rect.size.height/2.0;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    CGContextMoveToPoint(context, x, y);
//    CGContextAddLineToPoint(context, x, 2*y);
//    CGContextStrokePath(context);
}

-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

-(void) setCenter:(CGPoint)center {
    [super setCenter:center];
    [self.circle setCenter:buttonCenter];
}

@end
