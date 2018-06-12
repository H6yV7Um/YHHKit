//
//  NSString+YHHUI.m
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import "NSString+YHHUI.h"
#import "NSArray+YHHUI.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/xattr.h>
#import "YHHUICore.h"
#define Key_FileTotalSize @"Key_FileTotalSize"

@implementation NSString (YHHUI)
- (NSArray<NSString *> *)yhhui_toArray {
    if (!self.length) {
        return nil;
    }
    
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.length; i++) {
        NSString *stringItem = [self substringWithRange:NSMakeRange(i, 1)];
        [array addObject:stringItem];
    }
    return [array copy];
}

- (NSArray<NSString *> *)yhhui_toTrimmedArray {
    return [[self yhhui_toArray] yhhui_filterWithBlock:^BOOL(NSString *item) {
        return item.yhhui_trim.length > 0;
    }];
}

- (NSString *)yhhui_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)yhhui_trimAllWhiteSpace {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)yhhui_trimLineBreakCharacter {
    return [self stringByReplacingOccurrencesOfString:@"[\r\n]" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

@end

@implementation NSString (YHHUI_File)

+ (NSString *)yhh_getPathStrByUrlStr:(NSString *)urlStr
{
    // 创建文件管理者
    NSFileManager* fileManager = [NSFileManager defaultManager];
    // 获取文件各个部分
    NSArray* fileComponents = [fileManager componentsToDisplayForPath:urlStr];
    // 获取下载之后的文件名
    NSString* fileName = [fileComponents lastObject];
    // 根据文件名拼接沙盒全路径
    NSString* fileFullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[@"Documents/" stringByAppendingString:fileName]];
    return fileFullPath;
}

+ (NSString *)yhh_getPathStrByUrlStr:(NSString *)urlStr isCreateFile:(BOOL)isCreateFile
{
    // 创建文件管理者
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取文件各个部分
    NSArray *fileComponents = [fileManager componentsToDisplayForPath:urlStr];
    // 获取下载之后的文件名
    NSString *fileName = [fileComponents lastObject];
    
    NSString *dirFillPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Documents"];
    // 根据文件名拼接沙盒全路径
    NSString* fileFullPath = [dirFillPath stringByAppendingPathComponent:fileName];
    
    if (![fileManager fileExistsAtPath:fileFullPath] && isCreateFile) {
        
        BOOL isDir = NO;
        // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        BOOL existed = [fileManager fileExistsAtPath:dirFillPath isDirectory:&isDir];
        
        if ( !(isDir == YES && existed == YES) ) {
            // 在 Document 目录下创建一个 head 目录
            [fileManager createDirectoryAtPath:dirFillPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // 如果没有下载文件的话，就创建一个文件。如果有文件的话，则不用重新创建(不然会覆盖掉之前的文件)
        BOOL isSucces =  [fileManager createFileAtPath:fileFullPath contents:nil attributes:nil];
        YHHLOG(@"isSucces:%d",isSucces);
    }
    return fileFullPath;
}

+(NSInteger)yhh_getFileSizeWithFilePath:(NSString *)filePath
{
    // 创建文件管理者
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSDictionary* attributes = [fileManager attributesOfItemAtPath:filePath
                                                             error:nil];
    
    NSInteger fileCurrentSize = [attributes[@"NSFileSize"] integerValue];
    return fileCurrentSize;
}

+ (NSString *)yhh_transOriginalSize:(id)originalSize originalUnit:(NSString *)originalUnit toDestinationUnit:(NSString *)destinationUnit
{
    
    if (!(originalUnit!=nil && originalUnit!=NULL && (NSNull *)originalUnit!=[NSNull null] && [originalUnit respondsToSelector:@selector(length)] && [(NSString *)originalUnit length]>0) || !(destinationUnit!=nil && destinationUnit!=NULL && (NSNull *)destinationUnit!=[NSNull null] && [destinationUnit respondsToSelector:@selector(length)] && [(NSString *)destinationUnit length]>0)) {
        return nil;
    }
    double convertedValue = [originalSize doubleValue];
    NSInteger originalIndex    = 0;
    NSInteger destinationIndex = 0;
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];
    originalIndex   = [tokens indexOfObject:originalUnit];
    destinationIndex = [tokens indexOfObject:destinationUnit];
    if (originalIndex > destinationIndex) {
        NSInteger marginCount = originalIndex - destinationIndex;
        for (int index = 0; index < marginCount; marginCount++)
        {
            convertedValue /= 1024;
        }
        return [NSString stringWithFormat:@"%4.2f %@",convertedValue, destinationUnit];
    }
    else
    {
        NSInteger marginCount = destinationIndex - originalIndex;
        for (int index = 0; index < marginCount; marginCount++)
        {
            convertedValue *= 1024;
        }
        return [NSString stringWithFormat:@"%4.2f %@",convertedValue, destinationUnit];
    }
}

+ (NSString *)yhh_transformedValue:(id)value
{
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

//为文件增加一个扩展属性
+ (BOOL)yhh_extendedStringValueWithPath:(NSString *)path key:(NSString *)key value:(NSString *)stringValue
{
    NSData* value = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
    ssize_t writelen = setxattr([path fileSystemRepresentation],
                                [key UTF8String],
                                [value bytes],
                                [value length],
                                0,
                                0);
    return writelen==0?YES:NO;
}
//读取文件扩展属性
+ (NSString *)yhh_stringValueWithPath:(NSString *)path key:(NSString *)key
{
    ssize_t readlen = 1024;
    do {
        char buffer[readlen];
        bzero(buffer, sizeof(buffer));
        size_t leng = sizeof(buffer);
        readlen = getxattr([path fileSystemRepresentation],
                           [key UTF8String],
                           buffer,
                           leng,
                           0,
                           0);
        if (readlen < 0){
            return nil;
        }
        else if (readlen > sizeof(buffer)) {
            continue;
        }else{
            NSData *data = [NSData dataWithBytes:buffer length:readlen];
            NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return result;
        }
    } while (YES);
    return nil;
}
@end

#pragma mark -
#pragma mark 时间相关
@implementation NSString (YHHUI_Date)
+(NSString *)yhhui_getTimeStamp
{
    NSDate *senddate = [NSDate date];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    return timeStamp;
}

+ (NSString *)yhhui_timeStringWithMinsAndSecsFromSecs:(double)seconds
{
    NSUInteger min = floor(seconds / 60);
    NSUInteger sec = floor(seconds - min * 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
}

+(NSString *)yhhui_timeStampTransferTime:(NSString *)tempSpain andTimeFormat:(NSString *)fromFormat
{
    long long createTime;
    if (tempSpain.length > 10) {
        createTime = [tempSpain longLongValue]/1000;
    }
    else{
        createTime = [tempSpain longLongValue];
    }
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:createTime];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:fromFormat];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

+(long)yhhui_timeTransfertimeStampOldTimeStr:(NSString *)timeStr timeFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat
{
    /*
     timeStr : 2016年08月08日 21时28分00秒
     timeFormat: yyyy年MM月dd日 HH时mm分ss秒
     toFormat: yyyy-MM-dd HH:mm:ss
     */
    
    long timeStamp;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:fromFormat];
    
    NSDate *f = [formatter dateFromString:timeStr];
    [formatter setDateFormat:toFormat];
    
    timeStamp = (long)[f timeIntervalSince1970]*1000;
    
    return timeStamp;
}
@end

#pragma mark -
#pragma mark MD5
@implementation NSString (YHHUI_md5)
- (NSString *)yhhui_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
@end

#pragma mark -
#pragma mark 经纬度相关
@implementation NSString (YHHUI_Location)
+(NSString *)yhhui_stringWithCoordinateString:(NSString *)coordinateString
{
    /** 将经度或纬度整数部分提取出来 */
    int latNumber = [coordinateString intValue];
    
    /** 取出小数点后面两位(为转化成'分'做准备) */
    NSArray *array = [coordinateString componentsSeparatedByString:@"."];
    /** 小数点后面部分 */
    NSString *lastCompnetString = [array lastObject];
    
    /** 拼接字字符串(将字符串转化为0.xxxx形式) */
    NSString *str1 = [NSString stringWithFormat:@"0.%@", lastCompnetString];
    
    /** 将字符串转换成float类型以便计算 */
    float minuteNum = [str1 floatValue];
    
    /** 将小数点后数字转化为'分'(minuteNum * 60) */
    float minuteNum1 = minuteNum * 60;
    
    /** 将转化后的float类型转化为字符串类型 */
    NSString *latStr = [NSString stringWithFormat:@"%f", minuteNum1];
    
    /** 取整数部分即为纬度或经度'分' */
    int latMinute = [latStr intValue];
    
    /** 取出小数点后面两位(为转化成'秒'做准备)*/
    
    NSArray *array1 = [latStr componentsSeparatedByString:@"."];
    /** 小数点后面部分 */
    NSString *lastCompnetString1 = [array1 lastObject];
    
    /** 拼接字字符串(将字符串转化为0.xxxx形式) */
    NSString *strMiao = [NSString stringWithFormat:@"0.%@", lastCompnetString1];
    
    /** 将字符串转换成float类型以便计算 */
    float miaoNum = [strMiao floatValue];
    
    /** 将小数点后数字转化为'秒'(miaoNum * 60) */
    float miaoNum1 = miaoNum * 60;
    
    /** 将转化后的float类型转化为字符串类型 */
    NSString *miaoStr = [NSString stringWithFormat:@"%f", miaoNum1];
    
    /** 取整数部分即为纬度或经度'秒' */
    int latMiao = [miaoStr intValue];
    
    /** 将经度或纬度字符串合并为(xx°xx')形式 */
    NSString *string = @"";
    if ((latMinute<10) && (latMiao <0)) {
        string = [NSString stringWithFormat:@"%d°%02d′%02d″", latNumber, latMinute,latMiao];
    }
    else{
        string = [NSString stringWithFormat:@"%d°%02d′%02d″", latNumber, latMinute,latMiao];
    }
    
    return string;
}
@end
