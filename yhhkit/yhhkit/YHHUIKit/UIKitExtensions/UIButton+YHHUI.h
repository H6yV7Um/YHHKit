//
//  UIButton+YHHUI.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ActionBlock)(UIButton *button);

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, YHHUIButtonEdgeInsetsStyle) {
    YHHUIButtonEdgeInsetsStyleTop,    // image在上，label在下
    YHHUIButtonEdgeInsetsStyleLeft,   // image在左，label在右
    YHHUIButtonEdgeInsetsStyleBottom, // image在下，label在上
    YHHUIButtonEdgeInsetsStyleRight   // image在右，label在左
};


@interface UIButton (YHHUI)
/**
 block按钮回调
 
 @param controlEvent 触发事件
 @param action       方法回调
 */
- (void)yhhui_handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

/**
 设置button的titleLabel和imageView的布局样式，及间距（注：须知道按钮大小）
 
 @param style titleLabel和imageView的布局样式
 @param space titleLabel和imageView的间距
 */
- (void)yhhui_layoutButtonWithEdgeInsetsStyle:(YHHUIButtonEdgeInsetsStyle)style
                              imageTitleSpace:(CGFloat)space;
@end
