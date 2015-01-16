/*
 Copyright (C) <2012> <Wojciech Czelalski/CzekalskiDev>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "Common.h"
@implementation Common
void drawLinearGradient(CGContextRef context, CGPathRef path, CFArrayRef colors, CGGradientPosition position, CGFloat locations[], CGRect rect) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGPoint startPoint;
    CGPoint endPoint;
    
    
        
    switch (position) {
        case CGGradientPositionHorizontal:
            startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
             endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
            
            break;
            
        case CGGradientPositionVertical:
            startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
            endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
            break;
}
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

CGRect rectFor1PxStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, 
                      rect.size.width - 1, rect.size.height - 1);
}

+(CGFloat)rationWithPoint:(CGPoint)p2 center:(CGPoint)center radius:(CGFloat)raidus{
    CGFloat rat = 0;
    CGFloat dx = ABS(p2.x - center.x);
    //    NSLog(@"dx %f",dx);
    if (p2.y >= center.y && p2.x > center.x) {// 右下角
        rat = asinf(dx/raidus);
    } else if (p2.y < center.y && p2.x > center.x) {//右上角
        rat = M_PI - asinf(dx/raidus);
    } else if (p2.y < center.y && p2.x <= center.x) {// 左上角
        rat = M_PI + asinf(dx/raidus);
    } else { // 左下角
        rat = 2* M_PI - asinf(dx/raidus);
        if (ABS(rat - 2 * M_PI) <= 0.01) {
            rat = 0;
        }
    }
    return rat;
}

@end
