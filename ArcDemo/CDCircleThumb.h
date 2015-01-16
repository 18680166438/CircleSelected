//
//  MDCircleThumb.h
//  ArcDemo
//
//  Created by sfwan on 14-12-21.
//  Copyright (c) 2014年 MIDUO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
//#define degreesToRadians(x) (M_PI * (x) / 180.0)
//#define radiansToDegrees(x) ((x) / M_PI * 180)
@interface CDCircleThumb : UIView

@property (assign, readonly) CGFloat sRadius;
@property (assign, readonly) CGFloat lRadius;
@property (assign, readonly) CGFloat yydifference;
@property (nonatomic, strong) UIBezierPath *arc;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, strong) NSMutableArray * colorsLocations;
@property (assign) BOOL gradientFill;
@property (nonatomic, strong) NSArray *gradientColors;
@property (nonatomic, strong) UIColor *arcColor;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGPoint strartPoint;
@property (nonatomic, assign) CGPoint endPoint;
-(id) initWithShortCircleRadius:(CGFloat)shortRadius longRadius:(CGFloat)longRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor rate:(CGFloat)rate;
@end
