//
//  YHHUIHelper.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YHHUIHelper : NSObject

@end

@interface YHHUIHelper (SystemVersion)
// 获取当前版本
+ (NSInteger)yhh_numbericOSVersion;
// 比较版本
+ (NSComparisonResult)yhh_compareSystemVersion:(nonnull NSString *)currentVersion toVersion:(nonnull NSString *)targetVersion;
// 比较版本与目标版本（相等或大返回YES）
+ (BOOL)yhh_isCurrentSystemAtLeastVersion:(nonnull NSString *)targetVersion;
// 比较版本与目标版本（小返回YES）
+ (BOOL)yhh_isCurrentSystemLowerThanVersion:(nonnull NSString *)targetVersion;
@end

@interface YHHUIHelper (DynamicType) 
// 返回当前contentSize的level，这个值可以在设置里面的“字体大小”查看，辅助功能里面有个“更大字体”可以设置更大的字体，不过这里我们这个接口将更大字体都做了统一，都返回“字体大小”里面最大值。
+ (nonnull NSNumber *)yhh_preferredContentSizeLevel;

// 设置当前cell的高度，heights是有七个数值的数组，对于不支持的iOS版本，则选择中间的值返回。
+ (CGFloat)yhh_heightForDynamicTypeCell:(nonnull NSArray *)heights;
@end

@interface YHHUIHelper (AudioSession)
/**
 *  听筒和扬声器的切换
 *
 *  @param speaker   是否转为扬声器，NO则听筒
 *  @param temporary 决定使用kAudioSessionProperty_OverrideAudioRoute还是kAudioSessionProperty_OverrideCategoryDefaultToSpeaker，两者的区别请查看本组的博客文章:http://km.oa.com/group/gyui/articles/show/235957
 */
+ (void)yhh_redirectAudioRouteWithSpeaker:(BOOL)speaker temporary:(BOOL)temporary;

/**
 *  设置category
 *
 *  @param category 使用iOS7的category，iOS6的会自动适配
 */
+ (void)yhh_setAudioSessionCategory:(nullable NSString *)category;
@end

@interface YHHUIHelper (UIGraphic)
// 获取一像素的大小
+ (CGFloat)yhh_pixelOne;

/// 判断size是否超出范围
+ (void)yhh_inspectContextSize:(CGSize)size;

// context是否合法
+ (void)yhh_inspectContextIfInvalidatedInDebugMode:(CGContextRef _Nonnull)context;
+ (BOOL)yhh_inspectContextIfInvalidatedInReleaseMode:(CGContextRef _Nonnull)context;
@end

@interface YHHUIHelper (Device)

+ (BOOL)yhh_isIPad;
+ (BOOL)yhh_isIPadPro;
+ (BOOL)yhh_isIPod;
+ (BOOL)yhh_isIPhone;
+ (BOOL)yhh_isSimulator;

+ (BOOL)yhh_is58InchScreen;
+ (BOOL)yhh_is55InchScreen;
+ (BOOL)yhh_is47InchScreen;
+ (BOOL)yhh_is40InchScreen;
+ (BOOL)yhh_is35InchScreen;

+ (CGSize)yhh_screenSizeFor58Inch;
+ (CGSize)yhh_screenSizeFor55Inch;
+ (CGSize)yhh_screenSizeFor47Inch;
+ (CGSize)yhh_screenSizeFor40Inch;
+ (CGSize)yhh_screenSizeFor35Inch;

// 用于获取 iPhoneX 安全区域的 insets
+ (UIEdgeInsets)yhh_safeAreaInsetsForIPhoneX;

/// 判断当前设备是否高性能设备，只会判断一次，以后都直接读取结果，所以没有性能问题
+ (BOOL)yhh_isHighPerformanceDevice;

@end
