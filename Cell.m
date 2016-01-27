//
//  OneTableViewCell.m
//  评论页
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 ErHu. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatCell];
    }
    return self;
}

- (void)creatCell{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.iconImageView = imageView;
    [self.contentView addSubview:self.iconImageView];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont boldSystemFontOfSize:15];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.textColor = [UIColor redColor];
    self.body = contentLabel;
    [self.contentView addSubview:self.body];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 20)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    self.name = label;
    [self.contentView addSubview:self.name];
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    dataLabel.textColor = [UIColor blackColor];
    self.date = dataLabel;
    [self.contentView addSubview:self.date];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
