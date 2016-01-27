//
//  ViewController.m
//  FQYRefreshView
//
//  Created by DEVP-IOS-03 on 16/1/26.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "GDataXMLNode.h"
#import "HttpRequest.h"
#include "Model.h"
#import "Cell.h"
#import "RefreshView.h"
#define URL @"http://www.oschina.net/action/api/tweet_list?uid=0&pageIndex=%d&pageSize=%d"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshViewDelegate>

@end

@implementation ViewController
{
    HttpRequest *request;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    int _page;
    int _count;
    RefreshView *_refreshHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _count = 10;
    self.title = @"评论详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initHttpRequest];
}

- (void)initHttpRequest{
    //判断 如果count大于20 则page++
    if (_count >= 20) {
        _page++;
        request = [[HttpRequest alloc] initWithRequestString:[NSString stringWithFormat:URL,_page,_count] andRequestBlock:^(NSData *data) {
            if (_count >=20) {
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                NSArray *nodesArray = [document nodesForXPath:@"//tweets/tweet" error:nil];
                for (GDataXMLElement *ele in nodesArray) {
                    Model *model = [Model modeWithGData:ele];
                    [_dataArray addObject:model];
                }
            }else {
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                NSArray *nodesArray = [document nodesForXPath:@"//tweets/tweet" error:nil];
                _dataArray = [[NSMutableArray alloc] init];
                for (GDataXMLElement *ele in nodesArray) {
                    Model *model = [Model modeWithGData:ele];
                    [_dataArray addObject:model];
                }
            }

            if (!_tableView) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self creatTableView];
                    [self creatRefreshHeadView];
                });


            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [_tableView reloadData];
                });

            }

        }];
    }else{
        request = [[HttpRequest alloc] initWithRequestString:[NSString stringWithFormat:URL,_page,_count] andRequestBlock:^(NSData *data) {
            if (_count >=20) {
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                NSArray *nodesArray = [document nodesForXPath:@"//tweets/tweet" error:nil];
                for (GDataXMLElement *ele in nodesArray) {
                    Model *model = [Model modeWithGData:ele];
                    [_dataArray addObject:model];
                }
            }else {
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                NSArray *nodesArray = [document nodesForXPath:@"//tweets/tweet" error:nil];
                _dataArray = [[NSMutableArray alloc] init];
                for (GDataXMLElement *ele in nodesArray) {
                    Model *model = [Model modeWithGData:ele];
                    [_dataArray addObject:model];
                }
            }
            if (!_tableView) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self creatTableView];
                    [self creatRefreshHeadView];
                });

            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }

        }];
    }
}
- (void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // _tableView.rowHeight = 100;  定义高度
    [self.view addSubview:_tableView];
    //注册一下 cell 的创建方式
    [_tableView registerClass:[Cell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count > 1) {
        Model *model = _dataArray[indexPath.row];
        CGSize size = [model.body sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(250, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height + 45;
    }
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_dataArray.count > 1) {
        Model *model = _dataArray[indexPath.row];
        CGSize size = [model.body sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(250, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        cell.body.frame = CGRectMake(60, 35, 250, size.height);
        cell.body.text = model.body;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]];

        //在200这个宽度内能计算出这个Size;
        CGSize nameSize = [model.author sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
        cell.name.frame = CGRectMake(60, 10, nameSize.width, 20);
        cell.name.text = model.author;

        //去掉年月日
        cell.date.textColor = [UIColor blueColor];
        cell.date.frame = CGRectMake(60+nameSize.width+10, 10, 300, 20);
        NSArray *array = [model.pubData componentsSeparatedByString:@" "];
        cell.date.text = array[1];
    }
    return cell;
}

#pragma mark   ---------- 下拉刷新 上拉刷新

- (void)creatRefreshHeadView{
    //创建下拉刷新 View
    if (!_refreshHeaderView) {
        RefreshView *view = [[RefreshView alloc] initWithFrame:CGRectMake(0, -300, self.view.frame.size.width, 300)];
        _refreshHeaderView = view;
        _refreshHeaderView.delegate = self;
        [_tableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark scrollView Delegate
//上拉 下拉都要用这两个方法监听滚动高度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView refreshViewDidScroll:scrollView];
}

//结束拖拽状态
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView refreshViewDidEndDragging:scrollView];
}

//下载数据
- (void)UpdownloadData{
    //这里刷新数据
    [self initHttpRequest];
    //刷新完成后,应该让刷新视图调用下面的方法,来结束刷新,收起刷新提示条
    [_refreshHeaderView refreshViewDataSourceDidFinishedLoading:_tableView];
    //改变标记状态
    _isRefreshing = NO;
}

#pragma mark RefreshView Delegate

//下拉刷新的执行方法  如果上述两个监听的滚动高度小于-65(scrollView.contentOffset.y <= - 65.0f)则执行这个代理方法改变刷新状态(出现菊花图)
- (void)refreshViewDidTriggerRefresh{
    NSLog(@"这里触发执行刷新操作");
    _isRefreshing = YES;

    [self performSelector:@selector(UpdownloadData) withObject:nil afterDelay:0];
}

//滚动过程会不断调用这个方法监听是否改变刷新状态(即是否出现菊花图转的效果),实现原理中 需要这个变量去判断请求数据是否完成
- (BOOL)refreshViewDataIsLoading:(UIView *)view{
    return _isRefreshing;
}

//显示刷新时间
- (NSDate*)refreshViewDataLastUpdated{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
