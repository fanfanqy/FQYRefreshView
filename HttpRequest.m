//
//  HttpRequest.m
//  FQYRefreshView
//
//  Created by DEVP-IOS-03 on 16/1/27.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest 
- (instancetype)initWithRequestString:(NSString *)requestString andRequestBlock:(void (^)(NSData *))block{
    if (self = [super init]) {
        NSURL *url                      = [NSURL URLWithString:requestString];
        NSURLRequest *request           = [NSURLRequest requestWithURL:url];
        NSURLSession *session            = [NSURLSession sharedSession];
        NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                if (block) {
                    block(data);
                }
            }
            else
                NSLog(@"%@",error.description);
        }];
        [task resume];
    }
    return self;
}

@end
