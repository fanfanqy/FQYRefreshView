//
//  HttpRequest.h
//  FQYRefreshView
//
//  Created by DEVP-IOS-03 on 16/1/27.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject <NSURLSessionTaskDelegate>

- (instancetype)initWithRequestString:(NSString *)requestString andRequestBlock:(void (^)(NSData *data))block;
@end
