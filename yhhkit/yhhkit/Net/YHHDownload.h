//
//  YHHDownload.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLSessionManager.h"
/**
 上传或者下载进度回调Block
 
 @param progress 上传或者下载进度
 */
typedef void (^ _Nullable Progress)(NSProgress * _Nullable progress);
/**
 下载路径
 
 @param targetPath 目标路径
 @param response   资源
 @return           返回URL的Block
 */
typedef NSURL * _Nullable (^ _Nullable Destination)(NSURL *targetPath, NSURLResponse *response);

typedef void (^DonwLoadSuccessBlock)(NSURL *fileUrlPath ,NSURLResponse *  response );
typedef void (^DownLoadfailBlock)(NSError*  error ,NSInteger statusCode);
//typedef void (^DowningProgress)(CGFloat  progress);

@interface YHHDownload : NSObject

@property (nonatomic,strong) AFURLSessionManager *manager;
/**  下载历史记录（字典类型，存着时间戳和数据） */
@property (nonatomic,strong) NSMutableDictionary *downLoadHistoryDictionary;

/**
 获取到网络请求单例对象（在APPdelegate里处理下，解决遗留信息）
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 [PUDownloadTool sharedTool];//先把遗留信息处理一下
 // Override point for customization after application launch.
 return YES;
 }
 
 
 @return 网络请求对象
 */
+ (instancetype)yhh_sharedTool;



/**
 离线断点下载
 
 @param urlHost     下载地址
 @param progress    下载进度
 @param destination 本地存储路径
 @param success     下载成功
 @param failure     下载失败
 @return            NSURLSessionDownloadTask对象控制下载开始、暂停、取消
 */
- (NSURLSessionDownloadTask  *)yhh_offLineDownLoadFileWithUrl:(NSString*)urlHost
                                                 progress:(Progress)progress
                                              destination:(Destination)destination
                                                  success:(DonwLoadSuccessBlock)success
                                                  failure:(DownLoadfailBlock)failure;

/**
 离线超时限制断点下载
 
 @param urlHost     下载地址
 @param progress    下载进度
 @param destination 本地存储路径
 @param overtime    超过多长时间删除以前缓存文件重新下载(秒)
 @param success     下载成功
 @param failure     下载失败
 @return            NSURLSessionDownloadTask对象控制下载开始、暂停、取消
 */
- (NSURLSessionDownloadTask  *)yhh_offLineDownLoadFileWithUrl:(NSString*)urlHost
                                                 progress:(Progress)progress
                                              destination:(Destination)destination
                                                 overtime:(long)overtime
                                                  success:(DonwLoadSuccessBlock)success
                                                  failure:(DownLoadfailBlock)failure;

/**
 停止所有的下载任务
 */
- (void)yhh_stopAllDownLoadTasks;

/**
 根据下载地址获取正在执行的下载task
 
 @param urlStr 下载地址
 */
- (NSURLSessionDownloadTask *)yhh_getDownLoadTasksByUrlStr:(NSString *)urlStr;
@end
