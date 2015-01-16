/*
 Copyright (C) <2012> <Wojciech Czelalski/CzekalskiDev>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#define deceleration_multiplier 30.0f

#import <QuartzCore/QuartzCore.h>
#import "CDCircleGestureRecognizer.h"
#import "CDCircle.h"
#import "CDCircleThumb.h"
#import <AudioToolbox/AudioServices.h>
#import "CDCircleOverlayView.h"
#import "Common.h"


@implementation CDCircleGestureRecognizer

@synthesize rotation = rotation_, controlPoint;
@synthesize ended;
@synthesize currentThumb;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CDCircle *view = (CDCircle *) [self view];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:view];
    
   // Fail when more than 1 finger detected.
   if ([[event touchesForGestureRecognizer:self] count] > 1 || ([view.path containsPoint:point] == YES )) {
      [self setState:UIGestureRecognizerStateFailed];
   }

    CGPoint center = CGPointMake(view.radius, view.radius);
    CGFloat dis = sqrt((center.x-point.x) * (center.x-point.x) + (center.y-point.y) * (center.y-point.y));
//    if (dis > view.radius) {
//        [self setState:UIGestureRecognizerStateFailed];
//    }
    self.ended = NO;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   if ([self state] == UIGestureRecognizerStatePossible) {
      [self setState:UIGestureRecognizerStateBegan];
   } else {
      [self setState:UIGestureRecognizerStateChanged];
   }

   // We can look at any touch object since we know we 
   // have only 1. If there were more than 1 then 
   // touchesBegan:withEvent: would have failed the recognizer.
   UITouch *touch = [touches anyObject];

   // To rotate with one finger, we simulate a second finger.
   // The second figure is on the opposite side of the virtual
   // circle that represents the rotation gesture.

    CDCircle *view = (CDCircle *) [self view];
    
    CGPoint center = CGPointMake(CGRectGetMidX([view bounds]), CGRectGetMidY([view bounds]));
    CGPoint currentTouchPoint = [touch locationInView:view];
    CGPoint previousTouchPoint = [touch previousLocationInView:view];
    if (![self isSuccessPoint:currentTouchPoint p2:previousTouchPoint]) {
        NSLog(@"         ");
        return;
    }
    previousTouchDate = [NSDate date];
    CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
   [self setRotation:angleInRadians];

    currentTransformAngle = atan2f(view.transform.b, view.transform.a);
}

-(BOOL)isSuccessPoint:(CGPoint)p1 p2:(CGPoint)p2{
    CGFloat dx = ABS(p1.x-p2.x);
    CGFloat dy = ABS(p1.y-p2.y);
    if (dx <= self.rate && dy <= self.rate) {
        return YES;
    }
    return NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   // Perform final check to make sure a tap was not misinterpreted.
   if ([self state] == UIGestureRecognizerStateChanged) {
    
       
       CDCircle *view = (CDCircle *) [self view];
       CGFloat flipintime;
       CGFloat angle = 0;
       if (view.inertiaeffect == YES) {
           CGFloat angleInRadians = atan2f(view.transform.b, view.transform.a) - currentTransformAngle;
           double time = [[NSDate date] timeIntervalSinceDate:previousTouchDate];
           double velocity = angleInRadians/time;
           CGFloat a = deceleration_multiplier;
           
            flipintime = fabs(velocity)/a; 
           
           
           
            angle = (velocity*flipintime)-(a*flipintime*flipintime/2);
           
           if (angle>M_PI/2 || (angle<0 && angle<-1*M_PI/2)) {
               if (angle<0) {
                   angle =-1 * M_PI/2.1f;
               }    
               else { angle = M_PI/2.1f; }
               
               flipintime = 1/(-1*(a/2*velocity/angle));
           }

       }
       
       [UIView animateWithDuration:flipintime delay:0.f options:UIViewAnimationCurveEaseOut animations:^{
           [view setTransform:CGAffineTransformRotate(view.transform,angle)];

       } completion:^(BOOL finished) {
           CDCircleThumb *thumb  = nil;
//           if ([view isOverTheBorder] == -1) {
//               NSInteger index = [view isOverTheBorder];
//               thumb = [view circleLocationAtIndex:index];
//           } else {
//               [view circleLocationAtIndex:thumb.tag];
//           }
           NSInteger isOver = [self isOver];
           if (isOver) {
               if (self.director == kTurnDirectorRight) {// 顺时针
                   thumb = [view circleLocationAtIndex:0];
               } else if (self.director == kTurnDirectorLeft){
                   thumb = [view circleLocationAtIndex:view.thumbs.count-1];
               } else {
                   thumb = [view circleLocationAtIndex:self.currentThumb.tag];
               }
           } else {
               thumb  = [view circleLocationAtTheCurrentThumb];
           }
//           NSInteger index = 0;
//           for (int i = 0; i < view.thumbs.count; i++) {
//               CDCircleThumb *thumb = view.thumbs[i];
//               CGPoint p1 = [thumb convertPoint:thumb.strartPoint toView:nil];
//               CDCircleThumb *t2 = nil;
//               if (i < view.thumbs.count -1) {
//                   t2 = view.thumbs[i+1];
//               } else {
//                   t2 = view.thumbs[0];
//               }
//               
//               CGPoint p2 = [t2 convertPoint:t2.strartPoint toView:nil];
//
//               CGFloat d = ABS(p1.x-p2.x);
//               CGFloat x = MIN(p1.x, p2.x);
//               CGFloat y = MAX(p1.y, p2.y);
//               CGRect rect1 = CGRectMake(x, y, d, 101);
//               CGPoint cp = view.overlayView.controlPoint;
//               if (CGRectContainsPoint(rect1, cp)) {
//                   index = i+1;
//                   if (index == view.thumbs.count) {
//                       index = 0;
//                   }
//               }
//           }
//           NSLog(@"%d",cout);
           
           
//           NSMutableArray *distances = [NSMutableArray array];
//           for (int i = 0; i < view.thumbs.count; i++) {
//               CDCircleThumb *thumb = view.thumbs[i];
//               CGPoint point1 = [thumb convertPoint:thumb.centerPoint toView:nil];
//               CGPoint point2 = view.overlayView.controlPoint;
//               CGFloat distance = sqrt((point1.x - point2.x)*(point1.x - point2.x)+(point1.y - point2.y)*(point1.y - point2.y));
//               [distances addObject:[NSNumber numberWithFloat:distance]];
//           }
//           
//           NSInteger index = 0;
//           CGFloat min = [distances[0] floatValue];
//           for (int i = 0; i < distances.count; i++) {
//               CGFloat dis = [distances[i] floatValue];
//               if (dis < min) {
//                   min = dis;
//                   index = i;
//               }
//           }

//           CDCircleThumb *thumb = view.thumbs[index];
//           CGFloat deltaAngle= degreesToRadians(-thumb.angle/2) + atan2(thumb.transform.a, thumb.transform.b);
           
//            [UIView animateWithDuration:0.2f animations:^{
////                [view setTransform:CGAffineTransformRotate(current, deltaAngle)];
//                [view setTransform:CGAffineTransformMakeRotation(deltaAngle)];
//            }];

            self.currentThumb = thumb;
            //Delegate method
            [view.delegate circle:view didMoveToSegment:thumb.tag thumb:thumb];
            self.ended = YES;
;
       }];


       currentTransformAngle = 0;
       
       
              
     [self setState:UIGestureRecognizerStateEnded];  
       
   } else {
      [self setState:UIGestureRecognizerStateFailed];
   }
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self setState:UIGestureRecognizerStateFailed];
}
@end
