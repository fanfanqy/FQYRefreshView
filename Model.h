//
//  Model.h
//  评论页
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 ErHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface Model : NSObject
@property (nonatomic,copy)NSString *portrait;
@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *body;
@property (nonatomic,copy)NSString *pubData;
+ (Model *)modeWithGData:(GDataXMLElement *)ele;
@end
