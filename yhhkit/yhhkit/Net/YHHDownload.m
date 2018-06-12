//
//  YHHDownload.m
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import "YHHDownload.h"
#import "YHHUICore.h"
#import "NSString+YHHUI.h"

#import "NSObject+YHHUI.h"
static NSString *kDatakey = @"kDatakey";
static NSString *kTimekey = @"kTimekey";

@interface YHHDownload ()
@property (nonatomic,strong) NSString  *fileHistoryPath;
@end

@implementation YHHDownload
static YHHDownload *tool = nil;
+ (instancetype)sharedTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool =  [[self alloc] init];
    });
    return tool;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.bundleiD.TES"];
        //设置请求超时为30秒钟
        configuration.timeoutIntervalForRequest = 30;
        //在蜂窝网络情况下是否继续请求（上传或下载）
        configuration.allowsCellularAccess = YES;
        
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        // 接收下载完成、中断、意外崩溃、退出应用处理通知
        NSURLSessionDownloadTask *task;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(downLoadData:)
                                                     name:AFNetworkingTaskDidCompleteNotification
                                                   object:task];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths  objectAtIndex:0];
        self.fileHistoryPath = [path stringByAppendingPathComponent:@"fileDownLoadHistory.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileHistoryPath]) {
            self.downLoadHistoryDictionary =[NSMutableDictionary dictionaryWithContentsOfFile:self.fileHistoryPath];
        }else{
            self.downLoadHistoryDictionary = [NSMutableDictionary dictionary];
            //将dictionary中的数据写入plist文件中
            [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:YES];
        }
    }
    return  self;
}

- (void)saveHistoryWithKey:(NSString *)key DownloadTaskResumeDataDict:(NSDictionary *)dataDict{
    if (!dataDict) {
        NSDictionary *emptyData = [NSDictionary new];
        [self.downLoadHistoryDictionary setObject:emptyData forKey:key];
        
    }else{
        [self.downLoadHistoryDictionary setObject:dataDict forKey:key];
    }
    
    [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:NO];
}
- (void)saveDownLoadHistoryDirectory{
    [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:YES];
}



- (NSURLSessionDownloadTask  *)offLineDownLoadFileWithUrl:(NSString*)urlHost
                                                 progress:(Progress)progress
                                              destination:(Destination)destination
                                                 overtime:(long)overtime
                                                  success:(DonwLoadSuccessBlock)success
                                                  failure:(DownLoadfailBlock)failure
{
    NSDictionary *historyDataDict = [self.downLoadHistoryDictionary objectForKey:urlHost];
    NSString *historyTimeStamp    = [historyDataDict objectForKey:kTimekey];
    long historyTime = [historyTimeStamp longLongValue] /1000;
    NSString *currentTimeStamp    = [NSString getTimeStamp];
    long currentTime = [currentTimeStamp longLongValue] /1000;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlHost]];
    NSURLSessionDownloadTask   *downloadTask = nil;
    if (currentTime - historyTime > overtime) {// 超时
        downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (destination) {
                return destination([NSURL fileURLWithPath:[ExpendFile getPathStrByUrlStr:urlHost] isDirectory:NO], response);
            }else{
                return nil;
            }
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            PULOG(@"完成");
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            if (error) {
                if (failure) {
                    failure(error,[httpResponse statusCode]);
                }
                //将下载失败存储起来  提交到了appDelegate 的网络监管类里面
            }else{
                if (success) {
                    success(filePath,response);
                }
                //将下载成功存储起来  提交到了appDelegate 的网络监管类里面
            }
            
        }];
    }
    else
    {
        downloadTask = [self offLineDownLoadFileWithUrl:urlHost progress:progress destination:destination success:success failure:failure];
    }
    return downloadTask;
}

- (NSURLSessionDownloadTask  *)offLineDownLoadFileWithUrl:(NSString*)urlHost
                                                 progress:(Progress)progress
                                              destination:(Destination)destination
                                                  success:(DonwLoadSuccessBlock)success
                                                  failure:(DownLoadfailBlock)failure{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlHost]];
    NSURLSessionDownloadTask   *downloadTask = nil;
    NSDictionary *historyDataDict = [self.downLoadHistoryDictionary objectForKey:urlHost];
    NSData *downLoadHistoryData   = [historyDataDict objectForKey:kDatakey];
    PULOG(@"本地是否存储需要续传的数据长度为 %ld",downLoadHistoryData.length);
    if (downLoadHistoryData.length > 0 ) {
        PULOG(@"使用旧任务");
        downloadTask = [self.manager downloadTaskWithResumeData:downLoadHistoryData progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (destination) {
                return destination([NSURL fileURLWithPath:[ExpendFile getPathStrByUrlStr:urlHost] isDirectory:NO], response);
                
            }else{
                return nil;
            }
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            
            if (error) {
                if (failure) {
                    //将下载失败存储起来  提交到下面的 的网络监管类里面
                    failure(error,[httpResponse statusCode]);
                }
            }else{
                if (success) {
                    //将下载成功存储起来  提交到下面的 的网络监管类里面
                    success(filePath,response);
                    
                }
            }
            
        }];
    }else{
        PULOG(@"开辟 新任务");
        downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (destination) {
                return destination([NSURL fileURLWithPath:[ExpendFile getPathStrByUrlStr:urlHost] isDirectory:NO], response);
            }else{
                return nil;
            }
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            PULOG(@"完成");
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            if (error) {
                if (failure) {
                    //将下载失败存储起来  提交到了appDelegate 的网络监管类里面
                    failure(error,[httpResponse statusCode]);
                }
            }else{
                if (success) {
                    //将下载成功存储起来  提交到了appDelegate 的网络监管类里面
                    success(filePath,response);
                }
            }
            
        }];
    }
    return downloadTask;
}
/***************************************下载模块的关键的代码 包括强退闪退都会有***************************************/
- (void)downLoadData:(NSNotification *)notification{
    
    if ([notification.object isKindOfClass:[ NSURLSessionDownloadTask class]]) {
        NSURLSessionDownloadTask *task = notification.object;
        NSString *urlHost = [task.currentRequest.URL absoluteString];
        NSError *error  = [notification.userInfo objectForKey:AFNetworkingTaskDidCompleteErrorKey] ;
        if (error) {
            if (error.code == -1001) {
                PULOG(@"下载出错,看一下网络是否正常");
            }
            NSData *resumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
            NSDictionary *dataDict = @{kDatakey:resumeData,kTimekey:[NSString getTimeStamp]};
            [self saveHistoryWithKey:urlHost DownloadTaskResumeDataDict:dataDict];
            //这个是因为 用户比如强退程序之后 ,再次进来的时候 存进去这个继续的data  需要用户去刷新列表
        }else{
            if ([self.downLoadHistoryDictionary valueForKey:urlHost]) {
                [self.downLoadHistoryDictionary removeObjectForKey:urlHost];
                [self saveDownLoadHistoryDirectory];
            }
        }
    }
    
}
- (void)stopAllDownLoadTasks{
    //停止所有的下载
    if ([[self.manager downloadTasks] count]  == 0) {
        return;
    }
    for (NSURLSessionDownloadTask *task in  [self.manager downloadTasks]) {
        if (task.state == NSURLSessionTaskStateRunning) {
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                
            }];
        }
    }
}

- (NSURLSessionDownloadTask *)getDownLoadTasksByUrlStr:(NSString *)urlStr
{
    if ([[self.manager downloadTasks] count]  == 0 || ![urlStr isNotEmpty]) {
        return nil;
    }
    for (NSURLSessionDownloadTask *task in  [self.manager downloadTasks]) {
        if (task.state == NSURLSessionTaskStateRunning) {
            NSString *currentUrlStr = [NSString stringWithFormat:@"%@",task.currentRequest.URL];
            if ([currentUrlStr isEqualToString:urlStr]) {
                return task;
            }
        }
    }
    return nil;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
