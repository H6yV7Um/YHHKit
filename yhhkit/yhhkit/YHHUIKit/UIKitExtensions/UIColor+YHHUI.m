//
//  UIColor+YHHUI.m
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import "UIColor+YHHUI.h"

@implementation UIColor (YHHUI)
+ (NSArray *)yhhui_colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return @[[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0]];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return @[[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0]];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return @[[NSString stringWithFormat:@"%d",r],[NSString stringWithFormat:@"%d",g],[NSString stringWithFormat:@"%d",b]];
}

+ (UIColor *)yhhui_colorFromRGB:(int)rgbValue
{
    return [self yhhui_colorFromRGB:rgbValue alphaValue:1.f];
}

+ (UIColor *)yhhui_colorFromRGB:(int)rgbValue alphaValue:(float)alphaValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0x00FF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0x0000FF))/255.0
                           alpha:alphaValue];
}
@end
