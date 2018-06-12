//
//  NSArray+YHHUI.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YHHUI)
/**
   将多维数组打平成一维数组再遍历所有子元素
 */
- (void)yhhui_enumerateNestedArrayWithBlock:(void (^)(id obj, BOOL *stop))block;

/**
   将多维数组递归转换成 mutable 多维数组
 */
- (NSMutableArray *)yhhui_mutableCopyNestedArray;

/**
   过滤数组元素，将 block 返回 YES 的 item 重新组装成一个数组返回
 */
- (instancetype)yhhui_filterWithBlock:(BOOL (^)(id item))block;
@end
