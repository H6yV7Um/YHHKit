//
//  NSDate+YHHUI.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSUInteger, YHHChineseCalendarOptions) {
    YHHChineseCalendarOptionTianGanDiZhi   =   1   <<  0,  //天干地支
    YHHChineseCalendarOptionShuXiang       =   1   <<  1,  //属相
    YHHChineseCalendarOptionMonth          =   1   <<  2,  //农历月
    YHHChineseCalendarOptionDay            =   1   <<  3,  //农历日
};

@interface NSDate (YHHUI)
// 将日期转换成农历
+(NSString *)yhhui_chineseCalendarWithDate:(NSDate *)date;

/**
 *  将日期转换成农历
 *
 *  @param date 日期
 *  @param options 需要显示的选项
 *
 *  @return 农历
 */
+(NSString *)yhhui_chineseCalendarWithDate:(NSDate *)date options:(YHHChineseCalendarOptions)options;

// 将日期转换成农历
-(NSString *)yhh_toChineseCalendar;


/**
 *  将日期转换成农历
 *
 *  @param options 需要显示的选项
 *
 *  @return 农历
 */
-(NSString *)yhhui_toChineseCalendarWithOptions:(YHHChineseCalendarOptions)options;
@end
