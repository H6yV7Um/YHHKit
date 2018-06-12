//
//  YHHUIHelper.m
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import "YHHUIHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "YHHUICore.h"
@implementation YHHUIHelper

@end

@implementation YHHUIHelper (SystemVersion)

+ (NSInteger)yhh_numbericOSVersion {
    NSString *OSVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *OSVersionArr = [OSVersion componentsSeparatedByString:@"."];
    
    NSInteger numbericOSVersion = 0;
    NSInteger pos = 0;
    
    while ([OSVersionArr count] > pos && pos < 3) {
        numbericOSVersion += ([[OSVersionArr objectAtIndex:pos] integerValue] * pow(10, (4 - pos * 2)));
        pos++;
    }
    
    return numbericOSVersion;
}

+ (NSComparisonResult)yhh_compareSystemVersion:(NSString *)currentVersion toVersion:(NSString *)targetVersion {
    NSArray *currentVersionArr = [currentVersion componentsSeparatedByString:@"."];
    NSArray *targetVersionArr = [targetVersion componentsSeparatedByString:@"."];
    
    NSInteger pos = 0;
    
    while ([currentVersionArr count] > pos || [targetVersionArr count] > pos) {
        NSInteger v1 = [currentVersionArr count] > pos ? [[currentVersionArr objectAtIndex:pos] integerValue] : 0;
        NSInteger v2 = [targetVersionArr count] > pos ? [[targetVersionArr objectAtIndex:pos] integerValue] : 0;
        if (v1 < v2) {
            return NSOrderedAscending;
        }
        else if (v1 > v2) {
            return NSOrderedDescending;
        }
        pos++;
    }
    
    return NSOrderedSame;
}

+ (BOOL)yhh_isCurrentSystemAtLeastVersion:(NSString *)targetVersion {
    return [YHHUIHelper yhh_compareSystemVersion:[[UIDevice currentDevice] systemVersion] toVersion:targetVersion] == NSOrderedSame || [YHHUIHelper yhh_compareSystemVersion:[[UIDevice currentDevice] systemVersion] toVersion:targetVersion] == NSOrderedDescending;
}

+ (BOOL)yhh_isCurrentSystemLowerThanVersion:(NSString *)targetVersion {
    return [YHHUIHelper yhh_compareSystemVersion:[[UIDevice currentDevice] systemVersion] toVersion:targetVersion] == NSOrderedAscending;
}
@end

@implementation YHHUIHelper (DynamicType)

+ (NSNumber *)yhh_preferredContentSizeLevel {
    NSNumber *index = nil;
    if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
        NSString *contentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
        if ([contentSizeCategory isEqualToString:UIContentSizeCategoryExtraSmall]) {
            index = [NSNumber numberWithInt:0];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategorySmall]) {
            index = [NSNumber numberWithInt:1];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryMedium]) {
            index = [NSNumber numberWithInt:2];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryLarge]) {
            index = [NSNumber numberWithInt:3];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryExtraLarge]) {
            index = [NSNumber numberWithInt:4];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
            index = [NSNumber numberWithInt:5];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
            index = [NSNumber numberWithInt:6];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryAccessibilityMedium]) {
            index = [NSNumber numberWithInt:6];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryAccessibilityLarge]) {
            index = [NSNumber numberWithInt:6];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge]) {
            index = [NSNumber numberWithInt:6];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) {
            index = [NSNumber numberWithInt:6];
        } else if ([contentSizeCategory isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) {
            index = [NSNumber numberWithInt:6];
        } else{
            index = [NSNumber numberWithInt:6];
        }
    } else {
        index = [NSNumber numberWithInt:3];
    }
    
    return index;
}

+ (CGFloat)yhh_heightForDynamicTypeCell:(NSArray *)heights {
    NSNumber *index = [YHHUIHelper yhh_preferredContentSizeLevel];
    return [((NSNumber *)[heights objectAtIndex:[index intValue]]) floatValue];
}
@end

@implementation YHHUIHelper (AudioSession)

+ (void)yhh_redirectAudioRouteWithSpeaker:(BOOL)speaker temporary:(BOOL)temporary {
    if (![[AVAudioSession sharedInstance].category isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
        return;
    }
    if (temporary) {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:speaker ? AVAudioSessionPortOverrideSpeaker : AVAudioSessionPortOverrideNone error:nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory:[AVAudioSession sharedInstance].category withOptions:speaker ? AVAudioSessionCategoryOptionDefaultToSpeaker : 0 error:nil];
    }
}

+ (void)yhh_setAudioSessionCategory:(nullable NSString *)category {
    
    // 如果不属于系统category，返回
    if (category != AVAudioSessionCategoryAmbient &&
        category != AVAudioSessionCategorySoloAmbient &&
        category != AVAudioSessionCategoryPlayback &&
        category != AVAudioSessionCategoryRecord &&
        category != AVAudioSessionCategoryPlayAndRecord &&
        category != AVAudioSessionCategoryAudioProcessing)
    {
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:category error:nil];
}

+ (UInt32)categoryForLowVersionWithCategory:(NSString *)category {
    if ([category isEqualToString:AVAudioSessionCategoryAmbient]) {
        return kAudioSessionCategory_AmbientSound;
    }
    if ([category isEqualToString:AVAudioSessionCategorySoloAmbient]) {
        return kAudioSessionCategory_SoloAmbientSound;
    }
    if ([category isEqualToString:AVAudioSessionCategoryPlayback]) {
        return kAudioSessionCategory_MediaPlayback;
    }
    if ([category isEqualToString:AVAudioSessionCategoryRecord]) {
        return kAudioSessionCategory_RecordAudio;
    }
    if ([category isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
        return kAudioSessionCategory_PlayAndRecord;
    }
    if ([category isEqualToString:AVAudioSessionCategoryAudioProcessing]) {
        return kAudioSessionCategory_AudioProcessing;
    }
    return kAudioSessionCategory_AmbientSound;
}

@end

@implementation YHHUIHelper (UIGraphic)

static CGFloat pixelOne = -1.0f;
+ (CGFloat)yhh_pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
}

+ (void)yhh_inspectContextSize:(CGSize)size {
    if (size.width < 0 || size.height < 0) {
        NSAssert(NO, @"YHHUI CGPostError, %@:%d %s, 非法的size：%@\n%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, NSStringFromCGSize(size), [NSThread callStackSymbols]);
    }
}

+ (void)yhh_inspectContextIfInvalidatedInDebugMode:(CGContextRef)context {
    if (!context) {
        // crash了就找zhoon或者molice
        NSAssert(NO, @"YHHUI CGPostError, %@:%d %s, 非法的context：%@\n%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, context, [NSThread callStackSymbols]);
    }
}

+ (BOOL)yhh_inspectContextIfInvalidatedInReleaseMode:(CGContextRef)context {
    if (context) {
        return YES;
    }
    return NO;
}
@end

@implementation YHHUIHelper (Device)

static NSInteger isIPad = -1;
+ (BOOL)yhh_isIPad {
    if (isIPad < 0) {
        // [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] 无法判断模拟器，改为以下方式
        isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
    }
    return isIPad > 0;
}

static NSInteger isIPadPro = -1;
+ (BOOL)yhh_isIPadPro {
    if (isIPadPro < 0) {
        isIPadPro = [YHHUIHelper yhh_isIPad] ? (YHHDEVICE_WIDTH == 1024 && YHHDEVICE_HEIGHT == 1366 ? 1 : 0) : 0;
    }
    return isIPadPro > 0;
}

static NSInteger isIPod = -1;
+ (BOOL)yhh_isIPod {
    if (isIPod < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPod = [string rangeOfString:@"iPod touch"].location != NSNotFound ? 1 : 0;
    }
    return isIPod > 0;
}

static NSInteger isIPhone = -1;
+ (BOOL)yhh_isIPhone {
    if (isIPhone < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPhone = [string rangeOfString:@"iPhone"].location != NSNotFound ? 1 : 0;
    }
    return isIPhone > 0;
}

static NSInteger isSimulator = -1;
+ (BOOL)yhh_isSimulator {
    if (isSimulator < 0) {
#if TARGET_OS_SIMULATOR
        isSimulator = 1;
#else
        isSimulator = 0;
#endif
    }
    return isSimulator > 0;
}

static NSInteger is58InchScreen = -1;
+ (BOOL)yhh_is58InchScreen {
    if (is58InchScreen < 0) {
        is58InchScreen = (YHHDEVICE_WIDTH == self.yhh_screenSizeFor58Inch.width && YHHDEVICE_HEIGHT == self.yhh_screenSizeFor58Inch.height) ? 1 : 0;
    }
    return is58InchScreen > 0;
}

static NSInteger is55InchScreen = -1;
+ (BOOL)yhh_is55InchScreen {
    if (is55InchScreen < 0) {
        is55InchScreen = (YHHDEVICE_WIDTH == self.yhh_screenSizeFor55Inch.width && YHHDEVICE_HEIGHT == self.yhh_screenSizeFor55Inch.height) ? 1 : 0;
    }
    return is55InchScreen > 0;
}

static NSInteger is47InchScreen = -1;
+ (BOOL)yhh_is47InchScreen {
    if (is47InchScreen < 0) {
        is47InchScreen = (YHHDEVICE_WIDTH == self.yhh_screenSizeFor47Inch.width && YHHDEVICE_HEIGHT == self.yhh_screenSizeFor47Inch.height) ? 1 : 0;
    }
    return is47InchScreen > 0;
}

static NSInteger is40InchScreen = -1;
+ (BOOL)yhh_is40InchScreen {
    if (is40InchScreen < 0) {
        is40InchScreen = (YHHDEVICE_WIDTH == self.yhh_screenSizeFor40Inch.width && YHHDEVICE_HEIGHT == self.yhh_screenSizeFor40Inch.height) ? 1 : 0;
    }
    return is40InchScreen > 0;
}

static NSInteger is35InchScreen = -1;
+ (BOOL)yhh_is35InchScreen {
    if (is35InchScreen < 0) {
        is35InchScreen = (YHHDEVICE_WIDTH == self.yhh_screenSizeFor35Inch.width && YHHDEVICE_HEIGHT == self.yhh_screenSizeFor35Inch.height) ? 1 : 0;
    }
    return is35InchScreen > 0;
}

+ (CGSize)yhh_screenSizeFor58Inch {
    return CGSizeMake(375, 812);
}

+ (CGSize)yhh_screenSizeFor55Inch {
    return CGSizeMake(414, 736);
}

+ (CGSize)yhh_screenSizeFor47Inch {
    return CGSizeMake(375, 667);
}

+ (CGSize)yhh_screenSizeFor40Inch {
    return CGSizeMake(320, 568);
}

+ (CGSize)yhh_screenSizeFor35Inch {
    return CGSizeMake(320, 480);
}

+ (UIEdgeInsets)yhh_safeAreaInsetsForIPhoneX {
    if (![self yhh_is58InchScreen]) {
        return UIEdgeInsetsZero;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return UIEdgeInsetsMake(44, 0, 34, 0);
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIEdgeInsetsMake(34, 0, 44, 0);
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return UIEdgeInsetsMake(0, 44, 21, 44);
            
        case UIInterfaceOrientationUnknown:
        default:
            return UIEdgeInsetsMake(44, 0, 34, 0);
    }
}

static NSInteger isHighPerformanceDevice = -1;
+ (BOOL)yhh_isHighPerformanceDevice {
    if (isHighPerformanceDevice < 0) {
        isHighPerformanceDevice =  [self yhh_isIPad] ? 1 : ([self yhh_is35InchScreen] ? 0 : ([self yhh_is40InchScreen] ? 0 : ([self yhh_is47InchScreen] ? 1 : ([self yhh_is55InchScreen] ? 1 : 1))));
    }
    return isHighPerformanceDevice > 0;
}

@end



