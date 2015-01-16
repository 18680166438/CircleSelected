//
//  MDCircle.h
//  ArcDemo
//
//  Created by sfwan on 14-12-21.
//  Copyright (c) 2014年 MIDUO. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kRotationDegrees 180

@class CDCircle, CDCircleThumb, CDCircleOverlayView;
@protocol CDCircleDelegate <NSObject>
@required
-(void) circle: (CDCircle *) circle didMoveToSegment:(NSInteger) segment thumb: (CDCircleThumb *) thumb;
-(BOOL) circle: (CDCircle *)circle Move:(CGFloat) ration;

@end
@protocol CDCircleDataSource <NSObject>
-(UIImage *) circle: (CDCircle *) circle iconForThumbAtRow: (NSInteger) row;

@end

@class CDCircleGestureRecognizer;
@interface CDCircle : UIView
-(id)initWithFrame:(CGRect)frame Data:(NSArray *)data fillColors:(NSArray *)fillColors ringWidth:(CGFloat)ringWidth;
@property (nonatomic, assign) CGFloat ringWidth;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) UIBezierPath *circle;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) BOOL inertiaeffect;
@property (nonatomic, strong) CDCircleGestureRecognizer *recognizer;
@property (assign) int numberOfSegments;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) CDCircleOverlayView *overlayView;
@property (nonatomic, assign) BOOL overlay;

@property (nonatomic, strong) id <CDCircleDelegate> delegate;
@property (nonatomic, strong) id <CDCircleDataSource> dataSource;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *circleColor;


-(CDCircleThumb *)circleLocationAtTheCurrentThumb;
-(NSInteger)circleSearchCurrentThumb;
-(CDCircleThumb *)circleLocationAtIndex:(NSInteger)index;
//-(NSInteger)isOverTheBorder;
-(NSInteger)isOverTheBorder;

@end

