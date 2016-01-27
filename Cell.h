//
//  OneTableViewCell.h
//  评论页
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 ErHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell
@property (nonatomic,retain) UIImageView *iconImageView;
@property (nonatomic,retain) UILabel *name;
@property (nonatomic,retain) UILabel *date;
@property (nonatomic,retain) UILabel *body;
@end
