//
//  FQTRefreshView.m
//  FQYRefreshView
//
//  Created by DEVP-IOS-03 on 16/1/26.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel=label;


        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;


//        初始给个Normal 状态
        [self setState:RefreshNormal];
    }
    return self;
}

- (void)refreshLastUpdatedDate
{
    if ([_delegate respondsToSelector:@selector(refreshViewDataLastUpdated)]) {

        NSDate *date = [_delegate refreshViewDataLastUpdated];

        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm:ss"];
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"上次刷新:%@",[formatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"lastUpdatedDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSString *text = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastUpdatedDate"];
        if (text != nil) {
            _lastUpdatedLabel.text = text;
        }
        else{
            _lastUpdatedLabel.text = @"上次刷新:从未加载";
        }
    }
}

- (void)refreshViewDidScroll:(UIScrollView *)scrollView
{
    //在一个拖动过程中,随时会出现3种状态,需要进行条件判断,当最后结束的时候,查看完整EGORefresh效果,缺少"刷新完成",为了效果,加了一个刷新完成的状态
    // scrollView 是拖动状态下,这几个状态会来回转换
    if (_state != RefreshSuccess) {
        if (scrollView.isDragging) {
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(refreshViewDataIsLoading:)]) {
            _loading = [_delegate refreshViewDataIsLoading:self];
        }
        //状态的赋值,是根据contentOffset.y的值来决定的,所以y值改变量达到另一种状态时,_state 还是原来的值
        if (_state == RefreshNormal && scrollView.contentOffset.y < -65.0f && scrollView.contentOffset.y <0 && !_loading) {
                [self setState:RefreshTrigger];
        }

        if (_state == RefreshTrigger && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y <0 && !_loading) {
            [self setState:RefreshNormal];
        }
    }
    }
    else
    {
        [self setState:RefreshSuccess];
    }
}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(refreshViewDataIsLoading:)]) {
        _loading = [_delegate refreshViewDataIsLoading:self];
    }
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
        if ([_delegate respondsToSelector:@selector(refreshViewDidTriggerRefresh)]) {
            [_delegate refreshViewDidTriggerRefresh];
        }
        [self setState:RefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
    }
}

- (void)refreshViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [self setState:RefreshSuccess];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];


}

#pragma mark  私有方法
//设置状态,每种状态对应不同显示内容
- (void)setState:(RefreshState)state{

    switch (state) {
        case RefreshTrigger:
            //文字
            _statusLabel.text = @"松开刷新";
            break;

        case RefreshNormal:

            _statusLabel.text = @"下拉刷新";
            [self refreshLastUpdatedDate];
            break;

        case RefreshLoading:
            _statusLabel.text = @"正在刷新";
            break;

        case RefreshSuccess:
            _statusLabel.text = @"刷新完成";
            break;

        default:
            break;
    }
    _state = state;
    
    if (_state == RefreshSuccess) {
        _state = RefreshTrigger;
    }
}

@end
