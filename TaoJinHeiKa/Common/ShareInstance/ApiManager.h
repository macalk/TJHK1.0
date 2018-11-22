//
//  ApiManager.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/30.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "AFHTTPSessionManager.h"

static NSString *const ResponseCode = @"code";
static NSString *const ResponseData = @"data";
static NSString *const ResponseMessage = @"msg";
static NSString *const SuccessCode = @"1000000";
static NSString *const ErrorCode = @"1000100";

@interface ApiManager : AFHTTPSessionManager

typedef void (^SuccessBlock) (NSURLSessionDataTask *task, id response);
typedef void (^FailureBlock) (NSURLSessionDataTask *task, NSError *error);

/*
 tpye        :  默认是 POST，可以设置 GET
 path        :  请求路径
 parameters  :  请求参数，可以为 nil
 */

+ (void)requestWithTpye:(NSString *)tpye path:(NSString *)path parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
