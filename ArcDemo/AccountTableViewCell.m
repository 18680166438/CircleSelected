//
//  MDJXTableViewCell.m
//  ArcDemo
//
//  Created by sfwan on 14-12-23.
//  Copyright (c) 2014年 MIDUO. All rights reserved.
//

#import "AccountTableViewCell.h"
@interface AccountTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end

@implementation AccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setData:(NSDictionary *)data{
    _data = data;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    _productNameLabel.text = _data[@"productName"];
    _totalAmountLabel.text = [NSString stringWithFormat:@"资产: %@", _data[@"totalAmount"]];
    _percentLabel.text = [NSString stringWithFormat:@"%.0f%%", [_data[@"percent"] floatValue] * 100];
    _incomeLabel.text = [NSString stringWithFormat:@"%@",_data[@"income"]];
    
    _colorView.backgroundColor = _data[@"color"];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
