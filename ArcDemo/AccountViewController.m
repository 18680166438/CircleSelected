//
//  ViewController.m
//  ArcDemo
//
//  Created by sfwan on 14-12-21.
//  Copyright (c) 2014年 MIDUO. All rights reserved.
//

#import "AccountViewController.h"
#import "CDCircleThumb.h"
#import "CDCircle.h"
#import "CDCircleOverlayView.h"
#import "MDJCTableView.h"
#import "CDCircleGestureRecognizer.h"
#import "AccountTableViewCell.h"
#import "PointView.h"


#define kRowHeight           44

@interface AccountViewController ()<CDCircleDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CDCircle *circle;
@end

@implementation AccountViewController
{
    UITableView *_tableView;
    BOOL _startDrag;
    NSArray *_data;
    CGFloat _lastRotation;
    
    NSMutableArray *rotations;
    
    NSInteger _isLocation;
    
    CGFloat _lastY;
    NSInteger _lastIndex;
    NSMutableArray *colors;
    NSMutableArray *_tableData;
}

-(void)createData{
    _tableData = [NSMutableArray array];
    //    _data = @[@0.4,@0.3,@0.2,@0.1];
    _data = @[@0.3,@0.25,@0.2,@0.15,@0.1];
    //    _data = @[@0.4, @0.3,@0.3];
    //    _data = @[@0.2,@0.17,@0.03,@0.2,@0.2];
    _isLocation = 0;
    rotations = [NSMutableArray arrayWithCapacity:_data.count];
    for (NSNumber *numb in _data) {
        CGFloat rate = [numb floatValue];
        CGFloat rotation = rate * M_PI * 2;
        [rotations addObject:[NSNumber numberWithFloat:rotation]];
    }
    
    colors = [NSMutableArray array];
    for (int i = 0; i < _data.count; i++) {
        int r = 255;
        int g = rand()%255;
        int b = rand()%255;
        
        
        UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
        [colors addObject:color];
        
        NSDictionary *dic = @{@"productName":@"五粮液",@"totalAmount":@"34218",@"percent":_data[i], @"income":@"1234",@"color":color};
        [_tableData addObject:dic];
    }
}

-(void)loadCircle{
    _circle = [[CDCircle alloc] initWithFrame:CGRectMake((375-200)/2,100 , 200, 200) Data:_data fillColors:colors ringWidth:30];
    _circle.delegate = self;
    _circle.circleColor = [UIColor clearColor];
    
    CDCircleOverlayView *overlay = [[CDCircleOverlayView alloc] initWithCircle:_circle];
    [self.view addSubview:_circle];
    [self.view addSubview:overlay];
}

-(void)loadTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 301, self.view.frame.size.width, 300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.rowHeight = kRowHeight;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, _tableView.frame.size.height-kRowHeight, 0);
    [self.view addSubview:_tableView];
    
    _startDrag = NO;
}

-(void)loadPointView{
    PointView *pointView = [[PointView alloc] initWithFrame:CGRectMake(0, 300, 375, kRowHeight)];
    pointView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pointView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadCircle];
    [self loadTable];
    [self loadPointView];
}

#pragma mark - CDCircleDelegate
-(void) circle: (CDCircle *) circle didMoveToSegment:(NSInteger) segment thumb: (CDCircleThumb *) thumb{
    CGPoint contentOffset = CGPointMake(0, segment * kRowHeight);
    //    _tableView.contentOffset = contentOffset;
    [_tableView setContentOffset:contentOffset animated:YES];
    _lastY = 0;
}

-(BOOL) circle: (CDCircle *)circle Move:(CGFloat) ration{
    CGFloat radius = circle.radius;
    CDCircleThumb *thumb = circle.thumbs[0];
    CGPoint centerPoint = thumb.centerPoint;
    CGPoint p = [thumb convertPoint:centerPoint toView:nil];
    
    CGFloat ra = [Common rationWithPoint:p center:circle.center radius:radius];
    CGFloat y = [self tableScrollToRation:ra];
    // 判断越界
    if (y < -kRowHeight/2) {

        return NO;
    }
    // 判断越界
    CGFloat ss = (_data.count) * kRowHeight-kRowHeight/2;
    if (y > ss) {
        return NO;
    }
    
    return YES;
}

-(CGFloat)tableScrollToRation:(CGFloat)angle{
    
    NSInteger index = [_circle circleSearchCurrentThumb];
    CGFloat height = 0;// 已经滑过的距离
    
//    NSLog(@" yy %f", _tableView.contentOffset.y);
    if (_circle.recognizer.director == kTurnDirectorRight && _lastIndex == 0 && index != 0) {
        index = 0;
    }
    
    if (_circle.recognizer.director == kTurnDirectorLeft && index == 0 && _lastIndex != 0) {
        index = _data.count-1;
    }
    
    for (int i = 0; i < index; i++) {
        height += kRowHeight;
    }
    
    CGFloat rs = 0;// 已经包含的角度
    for (int i = 0; i < index; i++) {
        CGFloat rr = [self kForRow:i];
        rs += rr;
    }
    
    if (rs >= [self kForRow:0]) {
        rs -= [self kForRow:0]/2;
    }
    
    if (height >= kRowHeight) {
        height -= kRowHeight/2;
    }
    
//    NSLog(@" index %ld", index);
//    NSLog(@"height %f", height);
    CGFloat rotation = [rotations[index] floatValue];
    CGFloat hr = kRowHeight / rotation;
//    NSLog(@"at %f", asin(sin(angle)));
    if (index == 0) {// 超过0点时
        angle = asin(sin(angle));
    }

    CGFloat y = hr * (angle-rs) + height;
//    NSLog(@"rs %f", rs);
//    NSLog(@"hr %f", hr);
    CGPoint contentOffset = _tableView.contentOffset;
    contentOffset.y =  y;
//    NSLog(@" y        %f", y);
    _tableView.contentOffset = contentOffset;
//    NSLog(@"         ");
    _lastIndex = index;
    return y;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:nil options:nil] lastObject];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%.2f", [_data[indexPath.row] floatValue]];
    cell.data = _tableData[indexPath.row];
    return cell;
}

#pragma makr- UITableViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startDrag = YES;
    _isLocation = 0;
}

// 斜率
-(CGFloat)kForRow:(NSInteger)row{
    if (row < 0) {
        return 0;
    }
    CGFloat rotation = [rotations[row] floatValue];
    return rotation;
}

// 余数
-(CGFloat)py:(CGFloat)y{
    NSInteger b = y / kRowHeight;
    CGFloat yu = ABS((b * kRowHeight) -y);
    return yu;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
//    NSLog(@"%f   %f", y, scrollView.contentSize.height);
    // 198 220
    NSInteger row = 0;
    if (kRowHeight/2.0 + y - scrollView.contentSize.height >= 0) {// 划过下界
        row = _data.count-1;
        _isLocation = -1;
        y = kRowHeight + y - scrollView.contentSize.height;
        // 每一个行对应扇形的角度
        CGFloat r = [self kForRow:row];
        
        CGFloat rs = 0;// 已经包含的角度
        for (int i = 0; i < row; i++) {
            CGFloat rr = [self kForRow:i];
            rs += rr;
        }
        // 每个cell滑动的距离
        y = (((NSInteger)y + kRowHeight/2) % (kRowHeight*10));
        // 第一个扇形的角度/2(默认滚过的角度)
        CGFloat dr = [self kForRow:row]/2;
        // 第一个扇形与90度的角度差的一半(没弄懂为什么要这样, 但必须这样做)
        CGFloat mr = (degreesToRadians(90)- dr * 2)/2;
        // 每一个单元格高度对应的角度
        CGFloat ner = y * (r/kRowHeight) - dr - mr;
//        NSLog(@"ner  %f", radiansToDegrees(ner));
        // 已经滚过的角度
        CGFloat ra = ner + rs;
//        NSLog(@"ra  %f", radiansToDegrees(ra));
        // 获取第0个扇形
        CDCircleThumb *thumb = _circle.thumbs[0];
        CGFloat deltaAngle= -ra + atan2(thumb.transform.a, thumb.transform.b)/2;
        if (_startDrag) {
            _circle.transform = CGAffineTransformMakeRotation(deltaAngle);
        }
        NSLog(@"                  ");
        return;
    }
    
    
    if (y <= 0) { // 画过上边界
        _isLocation = 1;
        
        // 每一个行对应扇形的角度
        CGFloat r = [self kForRow:row];
        
        CGFloat rs = 0;// 已经包含的角度
        for (int i = 0; i < row; i++) {
            CGFloat rr = [self kForRow:i];
            rs += rr;
        }
        // 每个cell滑动的距离
        y = (((NSInteger)y + kRowHeight/2) % (kRowHeight*10));
        // 第一个扇形的角度/2(默认滚过的角度)
        CGFloat dr = [self kForRow:0]/2;
        // 第一个扇形与90度的角度差的一半(没弄懂为什么要这样, 但必须这样做)
        CGFloat mr = (degreesToRadians(90)- dr * 2)/2;
        // 每一个单元格高度对应的角度
        CGFloat ner = y * (r/kRowHeight) - dr - mr;
        // 已经滚过的角度
        CGFloat ra = ner + rs;
        // 获取第0个扇形
        CDCircleThumb *thumb = _circle.thumbs[0];
        CGFloat deltaAngle= -ra + atan2(thumb.transform.a, thumb.transform.b)/2;
        if (_startDrag) {
            _circle.transform = CGAffineTransformMakeRotation(deltaAngle);
        }
        return;
    }
    
    row = (y + (kRowHeight/2))/kRowHeight;
    row = MIN(row, _data.count-1);
    // 每一个行对应扇形的角度
    CGFloat r = [self kForRow:row];
    
    CGFloat rs = 0;// 已经包含的角度
    for (int i = 0; i < row; i++) {
        CGFloat rr = [self kForRow:i];
        rs += rr;
    }
    // 每个cell滑动的距离
    y = (((NSInteger)y + kRowHeight/2) % kRowHeight);
    // 第一个扇形的角度/2(默认滚过的角度)
    CGFloat dr = [self kForRow:0]/2;

    // 第一个扇形与90度的角度差的一半(没弄懂为什么要这样, 但必须这样做)
    CGFloat mr = (degreesToRadians(90)- dr * 2)/2;
    // 每一个单元格高度对应的角度
    CGFloat ner = y * (r/kRowHeight) - dr - mr;
    // 已经滚过的角度
    CGFloat ra = ner + rs;
//    NSLog(@"ra  %f", radiansToDegrees(ra));
    // 获取第0个扇形
    CDCircleThumb *thumb = _circle.thumbs[0];
    CGFloat deltaAngle= -ra + atan2(thumb.transform.a, thumb.transform.b)/2;
    if (_startDrag) {
        _circle.transform = CGAffineTransformMakeRotation(deltaAngle);
    }
}

//-(void)point

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _startDrag = NO;
    if (_isLocation == 0) {
        CDCircleThumb *thumb = [_circle circleLocationAtTheCurrentThumb];
        CGPoint contentOffset = CGPointMake(0, thumb.tag * kRowHeight);
        [_tableView setContentOffset:contentOffset animated:YES];
    } else if(_isLocation == 1) {
        CDCircleThumb *thumb = _circle.thumbs[0];
        [_circle circleLocationAtIndex:thumb.tag];
        CGPoint contentOffset = CGPointMake(0, thumb.tag * kRowHeight);
        [_tableView setContentOffset:contentOffset animated:YES];
    } else if(_isLocation == -1) {
        CDCircleThumb *thumb = _circle.thumbs[_data.count-1];
        [_circle circleLocationAtIndex:thumb.tag];
        CGPoint contentOffset = CGPointMake(0, thumb.tag * kRowHeight);
        [_tableView setContentOffset:contentOffset animated:YES];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (decelerate) {
    _startDrag = NO;
        if (_isLocation == 0) {
            CDCircleThumb *thumb = [_circle circleLocationAtTheCurrentThumb];
            CGPoint contentOffset = CGPointMake(0, thumb.tag * kRowHeight);
            [_tableView setContentOffset:contentOffset animated:YES];
        } else if(_isLocation == 1) {
            CDCircleThumb *thumb = _circle.thumbs[0];
            [_circle circleLocationAtIndex:thumb.tag];
            CGPoint contentOffset = CGPointMake(0, thumb.tag * kRowHeight);
            [_tableView setContentOffset:contentOffset animated:YES];
        } else if(_isLocation == -1) {
            CDCircleThumb *thumb = _circle.thumbs[_data.count-1];
            [_circle circleLocationAtIndex:thumb.tag];
            CGPoint contentOffset = CGPointMake(0, thumb.tag * kRowHeight);
            [_tableView setContentOffset:contentOffset animated:YES];
        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
