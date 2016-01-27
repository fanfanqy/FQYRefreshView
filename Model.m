//
//  Model.m
//  评论页
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 ErHu. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (Model *)modeWithGData:(GDataXMLElement *)ele{
    return [[Model alloc] initWithGDataElement:ele];
}

- (instancetype)initWithGDataElement:(GDataXMLElement *)ele{
    if (self = [super init]) {
        self.author = [[ele elementsForName:@"author"][0] stringValue];
        self.pubData = [[ele elementsForName:@"pubDate"][0] stringValue];
        self.body = [[ele elementsForName:@"body"][0] stringValue];
        self.portrait = [[ele elementsForName:@"portrait"][0] stringValue];
    }
    return self;
}

@end
