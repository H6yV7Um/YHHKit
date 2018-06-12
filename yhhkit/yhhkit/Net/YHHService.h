//
//  YHHService.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface YHHService : NSObject
/**
 *  网络请求数据回调block
 *
 *  @param status 请求结果状态
 *  @param data   服务器响应数据源
 */
typedef void(^BlockHandle) (NSInteger status,id data);
/**
 上传或者下载进度回调Block
 
 @param progress 上传或者下载进度
 */
typedef void (^ _Nullable Progress)(NSProgress * _Nullable progress);


@property (nonatomic, copy) NSString *urlStr;  //服务部署地址
@property (nonatomic, copy) NSString *handler; //处理器名
@property (nonatomic, copy) NSString *method;  //函数名
@property(readonly,nonatomic,strong) NSMutableDictionary *params;   //传递参数


@property(readonly,nonatomic,strong) AFHTTPSessionManager *manager;

/**
 *  为网络请求添加参数
 *
 *  @param key   参数名
 *  @param value 参数值
 */
- (void)yhh_addParamByKey:(NSString *)key value:(id)value;

/**
 发起POST网络请求并回调服务器响应结果
 
 @param finish 回调函数
 @return       NSURLSessionDataTask对象，用来取消请求
 */
- (NSURLSessionDataTask *)yhh_request:(BlockHandle)finish;

/**
 发起GET网络请求并回调服务器响应结果
 
 @param finish 回调函数
 @return       NSURLSessionDataTask对象，用来取消请求
 */
- (NSURLSessionDataTask *)yhh_get:(BlockHandle)finish;

/**
 发起网络请求获取AppStore上版本号信息
 
 @param finish 回调函数
 */
- (void)yhh_checkVersion:(BlockHandle)finish;

/**
 *  生成完整URL路径,子类可重载本方法自定义URL拼接规则
 *
 *  @return 完整URL路径
 */
- (NSString *)yhh_generateURL;

//取消所有的网络请求
+ (void)yhh_cancelAllRequest;

@end
