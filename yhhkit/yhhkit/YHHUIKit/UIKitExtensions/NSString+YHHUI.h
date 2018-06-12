//
//  NSString+YHHUI.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark -
#pragma mark 字符处理
@interface NSString (YHHUI)
// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，如果多个空格，则每个空格也会当成一个 item
- (NSArray<NSString *> *)yhhui_toArray;

// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，但会自动过滤掉空白字符
- (NSArray<NSString *> *)yhhui_toTrimmedArray;

// 去掉头尾的空白字符
- (NSString *)yhhui_trim;

// 去掉整段文字内的所有空白字符（包括换行符）
- (NSString *)yhhui_trimAllWhiteSpace;

// 将文字中的换行符替换为空格
- (NSString *)yhhui_trimLineBreakCharacter;
@end


#pragma mark -
#pragma mark 文件名及文件拓展
@interface NSString (YHHUI_File)
/**
 根据文件路径获取文件长度
 
 @param filePath 文件路径
 @return 文件长度
 */
+(NSInteger)yhh_getFileSizeWithFilePath:(NSString *)filePath;

/**
 转换文件大小单位（@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB"）
 
 @param originalSize    原始单位下大小
 @param originalUnit    原始单位
 @param destinationUnit 目标单位
 @return                目标单位下大小
 */
+ (NSString *)yhh_transOriginalSize:(id)originalSize originalUnit:(NSString *)originalUnit toDestinationUnit:(NSString *)destinationUnit;

/**
 转换文件大小(原始单位为bytes)
 
 @param value 文件大小
 @return      对应目标打下
 */
+ (NSString *)yhh_transformedValue:(id)value;

/**
 根据url字符串配置路径
 
 @param urlStr url字符串
 @return       路径
 */
+ (NSString *)yhh_getPathStrByUrlStr:(NSString *)urlStr;

/**
 根据url字符串配置路径
 
 @param urlStr url字符串
 @return       路径
 */

/**
 根据url字符串配置路径
 
 @param urlStr       url字符串
 @param isCreateFile 若没有对应的路径文件则创建一个该路径文件
 @return             文件路径
 */
+ (NSString *)yhh_getPathStrByUrlStr:(NSString *)urlStr isCreateFile:(BOOL)isCreateFile;

/**
 为文件增加一个扩展属性，值是字符串
 
 @param path  文件路径
 @param key   拓展键
 @param value 拓展值
 @return      是否拓展成功
 */
+ (BOOL)yhh_extendedStringValueWithPath:(NSString *)path key:(NSString *)key value:(NSString *)value;
/**
 读取文件扩展属性，值是字符串
 
 @param path 文件路径
 @param key  拓展键
 @return     拓展值
 */
+ (NSString *)yhh_stringValueWithPath:(NSString *)path key:(NSString *)key;
@end


#pragma mark -
#pragma mark 时间戳相关
@interface NSString (YHHUI_Date)
// 获取十三位时间戳
+(NSString *)yhhui_getTimeStamp;

/**
 将秒数转换为同时包含分钟和秒数的格式的字符串，例如 100->"01:40"
 
 @param seconds 秒数
 @return        对应结果
 */
+ (NSString *)yhhui_timeStringWithMinsAndSecsFromSecs:(double)seconds;

/**
 时间戳转时间
 
 @param tempSpain       时间戳
 @param fromFormat      时间格式
 
 @return 返回格式化之后的字符串
 */
+(NSString *)yhhui_timeStampTransferTime:(NSString *)tempSpain andTimeFormat:(NSString *)fromFormat;

/**
 将格式化的日期字符串重新格式化 -->转换成时间戳
 
 @param timeStr    格式化的字符串
 @param fromFormat 格式化字符串的格式的格式
 @param toFormat   目标格式
 
 @return 返回时间戳
 */
+(long)yhhui_timeTransfertimeStampOldTimeStr:(NSString *)timeStr timeFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
@end

#pragma mark -
#pragma mark MD5
@interface NSString (YHHUI_md5)
// 把该字符串转换为对应的 md5
- (NSString *)yhhui_md5;
@end

#pragma mark -
#pragma mark 经纬度相关
@interface NSString (YHHUI_Location)
/**
 经纬度转度分秒
 
 @param coordinateString 原始经纬度
 @return                 度分秒经纬度
 */
+(NSString *)yhhui_stringWithCoordinateString:(NSString *)coordinateString;
@end
