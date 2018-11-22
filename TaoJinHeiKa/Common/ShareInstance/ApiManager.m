//
//  ApiManager.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/30.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "ApiManager.h"

static NSTimeInterval const TimeOutInterval = 10.f; // 请求超时时间
static NSString * const accessKey = @"699b9305418757ef9a26e5a32ca9dbfb"; // 秘钥标识
static NSString * const accessValue = @"0bca3e8e2baa42218040c5dbf6978f315e104e5c"; // 签名秘钥

@implementation ApiManager

+ (instancetype)manager {
    static ApiManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseRequestUrl]];
    });
    return shareInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self responseSerializer];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = TimeOutInterval;
        [self.requestSerializer setValue:accessKey forHTTPHeaderField:@"accessKey"];
    }
    return self;
}

#pragma 请求方法(开放)

+ (void)requestWithTpye:(NSString *)tpye path:(NSString *)path parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    [[ApiManager manager] requestDataWithTpye:tpye path:path parameters:parameters success:success failure:failure];
}

#pragma 请求方法(私有)

- (void)requestDataWithTpye:(NSString *)tpye path:(NSString *)path parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *tmpDict = (!parameters?@{}:parameters).mutableCopy;
    [tmpDict setValue:AppVersion forKey:@"version"];
    [tmpDict setValue:@"IOS" forKey:@"platform"];
    [tmpDict setValue:[TJHKTool getUUID] forKey:@"deviceId"];
    [tmpDict setValue:BundleID forKey:@"appKey"];
    [tmpDict setValue:@"_ios" forKey:@"appMarket"];
    parameters = tmpDict.copy;
    
    [self httpRequestWithTpye:tpye path:path parameters:parameters success:^(NSURLSessionDataTask *task, id response) {
        NSString *code = [[response valueForKey:ResponseCode] stringValue];
        NSString *message = [response valueForKey:ResponseMessage];
        if (!message.length) {
            message = @"请求失败";
        }
        if (code.length) {
            if ([code isEqualToString:SuccessCode]) {
                if (success) {
                    success(task,response);
                }
            }
            else
            {
                if (failure) {
                    failure(task,[self requestErrorWithDomin:[response valueForKey:ResponseMessage] errorCode:nil]);
                }
            }
        }
        else
        {
            if (failure) {
                failure(task,[NSError errorWithDomain:message code:[code integerValue] userInfo:response]);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
                failure(task,[self requestErrorWithDomin:error.domain errorCode:nil]);
            }else{
                failure(task,error);
            }
        }
    }];
}

- (void)httpRequestWithTpye:(NSString *)tpye path:(NSString *)path parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    __block NSDictionary *params = nil;
    __block NSDictionary *files = nil;
    [self signParameters:parameters callback:^(NSDictionary *noFileDictionary, NSDictionary *fileDictionary) {
        params = noFileDictionary;
        files = fileDictionary;
    }];
    
    if ([tpye isEqualToString:@"GET"]) {
        [self GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(task,error);
            }
        }];
    }
    else
    {
        [self POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(task,error);
            }
        }];
    }
}

#pragma 参数拼接加密处理

- (NSString *)getSignStringWithParams:(NSDictionary *)params {
    NSArray *sortArray = [params allKeys];
    sortArray = [sortArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    NSString *signString = @"";
    for (NSString *key in sortArray) {
        signString = [signString stringByAppendingFormat:@"%@%@",key,params[key]];
    }
    signString = [signString stringByAppendingString:@""];
    NSString *reqTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", accessValue, reqTime, signString];
    sign = [[sign md5String] md5String];
    [self.requestSerializer setValue:reqTime forHTTPHeaderField:@"reqTime"];
    [self.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
    return sign;
}

- (void)signParameters:(NSDictionary *)parameters callback:(void(^)(NSDictionary *noFileDictionary, NSDictionary *fileDictionary))callback {
    NSMutableDictionary * params = [self dictFromObject:parameters withKey:nil].mutableCopy;
    NSMutableDictionary *files = @{}.mutableCopy;
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]] || [obj isKindOfClass:[NSData class]]) {
            [params removeObjectForKey:key];
            if ([key hasSuffix:@"file"]) {
                [files setObject:obj forKey:key];
            }else{
                [files setObject:obj forKey:[key stringByAppendingString:@"file"]];
            }
        }else if ([obj isKindOfClass:[NSString class]] && [obj containsString:@"/Documents/"] && ([obj hasSuffix:@".png"] || [obj hasSuffix:@".jpg"] || [obj hasSuffix:@".jpeg"] || [obj hasSuffix:@".pcm"])){
            [params removeObjectForKey:key];
            if ([key hasSuffix:@"file"]) {
                [files setObject:obj forKey:key];
            }else{
                [files setObject:obj forKey:[key stringByAppendingString:@"file"]];
            }
        }
    }];
    [self getSignStringWithParams:params];
    if (callback) {
        callback(params.copy,files.copy);
    }
}

- (NSDictionary *)dictFromObject:(id)object withKey:(NSString *)key {
    NSMutableDictionary *mutableDictionary = @{}.mutableCopy;
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = object;
        for (NSString *aKey in [dictionary allKeys]) {
            id aValue = [dictionary valueForKey:aKey];
            NSString *nextKey = key.length?[NSString stringWithFormat:@"%@.%@", key, aKey]:aKey;
            [mutableDictionary setValuesForKeysWithDictionary:[self dictFromObject:aValue withKey:nextKey]];
        }
    }else if ([object isKindOfClass:[NSArray class]]){
        NSArray *array = object;
        for (int i = 0; i < array.count; i++) {
            id aValue = array[i];
            NSString *nextKey = [NSString stringWithFormat:@"%@[%d]", key, i];
            [mutableDictionary setValuesForKeysWithDictionary:[self dictFromObject:aValue withKey:nextKey]];
        }
    }else{
        [mutableDictionary setObject:object forKey:key];
    }
    return mutableDictionary.copy;
}

- (NSError *)requestErrorWithDomin:(NSString *)domin errorCode:(NSString *)errorCode {
    if (!domin.length) {
        domin = @"请求失败";
    }
    if (!errorCode.length) {
        errorCode = ErrorCode;
    }
    if ([domin isEqualToString:@"NSURLErrorDomain"]) {
        domin = @"网络异常,请查看网络";
    }
    return [NSError errorWithDomain:domin code:errorCode.integerValue userInfo:nil];
}

@end
