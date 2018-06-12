//
//  UIImage+YHHUI.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHHUICore.h"
#define CGContextInspectSize(size) [YHHUIHelper yhh_inspectContextSize:size]

#ifdef DEBUG
#define CGContextInspectContext(context) [YHHUIHelper yhh_inspectContextIfInvalidatedInDebugMode:context]
#else
#define CGContextInspectContext(context) if(![YHHUIHelper yhh_inspectContextIfInvalidatedInReleaseMode:context]){return nil;}
#endif

@interface UIImage (YHHUI)
/**
 根据颜色生成纯色图片
 
 @param color 颜色
 @return      图片对象
 */
+ (UIImage *)yhh_imageWithColor:(UIColor *)color;


/**
 压缩图片使之宽度等于屏幕宽（图片宽大于屏幕宽时）或高度等于屏幕高
 
 @param originImg 原图片
 @return          压缩图
 */
+ (UIImage *)yhh_simpleImage:(UIImage *)originImg;


/**
 合并图片
 
 @param baseImg     底部图片
 @param topImage    上层图片
 @param baseImgSize 底部图片尺寸
 @param topImgRect  上层图片位置
 @return            合并后的图片
 */
+ (UIImage *)yhh_addImage:(UIImage *)baseImg topImage:(UIImage *)topImage baseImgSize:(CGSize)baseImgSize topImgRect:(CGRect)topImgRect;

/// 获取当前图片的像素大小，如果是多倍图，会被放大到一倍来算
@property(nonatomic, assign, readonly) CGSize yhhui_sizeInPixel;

/**
 *  获取当前图片的均色，原理是将图片绘制到1px*1px的矩形内，再从当前区域取色，得到图片的均色。
 *  @link http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage/ @/link
 *
 *  @return 代表图片平均颜色的UIColor对象
 */
- (UIColor *)yhhui_averageColor;

/**
 *  置灰当前图片
 *
 *  @return 已经置灰的图片
 */
- (UIImage *)yhhui_grayImage;

/**
 *  设置一张图片的透明度
 *
 *  @param alpha 要用于渲染透明度
 *
 *  @return 设置了透明度之后的图片
 */
- (UIImage *)yhhui_imageWithAlpha:(CGFloat)alpha;

/**
 *  判断一张图是否不存在 alpha 通道，注意 “不存在 alpha 通道” 不等价于 “不透明”。一张不透明的图有可能是存在 alpha 通道但 alpha 值为 1。
 */
- (BOOL)yhhui_opaque;

/**
 *  保持当前图片的形状不变，使用指定的颜色去重新渲染它，生成一张新图片并返回
 *
 *  @param tintColor 要用于渲染的新颜色
 *
 *  @return 与当前图片形状一致但颜色与参数tintColor相同的新图片
 */
- (UIImage *)yhhui_imageWithTintColor:(UIColor *)tintColor;

/**
 *  以 CIColorBlendMode 的模式为当前图片叠加一个颜色，生成一张新图片并返回，在叠加过程中会保留图片内的纹理。
 *
 *  @param blendColor 要叠加的颜色
 *
 *  @return 基于当前图片纹理保持不变的情况下颜色变为指定的叠加颜色的新图片
 *
 *  @warning 这个方法可能比较慢，会卡住主线程，建议异步使用
 */
- (UIImage *)yhhui_imageWithBlendColor:(UIColor *)blendColor;

/**
 *  在当前图片的基础上叠加一张图片，并指定绘制叠加图片的起始位置
 *
 *  叠加上去的图片将保持原图片的大小不变，不被压缩、拉伸
 *
 *  @param image 要叠加的图片
 *  @param point 所叠加图片的绘制的起始位置
 *
 *  @return 返回一张与原图大小一致的图片，所叠加的图片若超出原图大小，则超出部分被截掉
 */
- (UIImage *)yhhui_imageWithImageAbove:(UIImage *)image atPoint:(CGPoint)point;

/**
 *  在当前图片的上下左右增加一些空白（不支持负值），通常用于调节NSAttributedString里的图片与文字的间距
 *  @param extension 要拓展的大小
 *  @return 拓展后的图片
 */
- (UIImage *)yhhui_imageWithSpacingExtensionInsets:(UIEdgeInsets)extension;

/**
 *  切割出在指定位置中的图片
 *
 *  @param rect 要切割的rect
 *
 *  @return 切割后的新图片
 */
- (UIImage *)yhhui_imageWithClippedRect:(CGRect)rect;


/**
 *  切割出在指定圆角的图片
 *
 *  @param cornerRadius 要切割的圆角值
 *
 *  @return 切割后的新图片
 */
- (UIImage *)yhhui_imageWithClippedCornerRadius:(CGFloat)cornerRadius;

/**
 *  同上，可以设置 scale
 */

- (UIImage *)yhhui_imageWithClippedCornerRadius:(CGFloat)cornerRadius scale:(CGFloat)scale;

/**
 *  将原图以 UIViewContentModeScaleAspectFit 的策略缩放，使其缩放后的大小不超过指定的大小，并返回缩放后的图片，缩放后的图片的倍数保持与原图一致。
 *  @param size 在这个约束的 size 内进行缩放后的大小，处理后返回的图片的 size 会根据 contentMode 不同而不同，但必定不会超过 size。
 *
 *  @return 处理完的图片
 *  @see yhhui_imageResizedInLimitedSize:contentMode:scale:
 */
- (UIImage *)yhhui_imageResizedInLimitedSize:(CGSize)size;

/**
 *  将原图按指定的 UIViewContentMode 缩放，使其缩放后的大小不超过指定的大小，并返回缩放后的图片，缩放后的图片的倍数保持与原图一致。
 *  @param size 在这个约束的 size 内进行缩放后的大小，处理后返回的图片的 size 会根据 contentMode 不同而不同，但必定不会超过 size。
 *  @param contentMode 希望使用的缩放模式，目前仅支持 UIViewContentModeScaleToFill、UIViewContentModeScaleAspectFill、UIViewContentModeScaleAspectFit（默认）
 *
 *  @return 处理完的图片
 *  @see yhhui_imageResizedInLimitedSize:contentMode:scale:
 */
- (UIImage *)yhhui_imageResizedInLimitedSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 *  将原图按指定的 UIViewContentMode 缩放，使其缩放后的大小不超过指定的大小，并返回缩放后的图片。
 *  @param size 在这个约束的 size 内进行缩放后的大小，处理后返回的图片的 size 会根据 contentMode 不同而不同，但必定不会超过 size。
 *  @param contentMode 希望使用的缩放模式，目前仅支持 UIViewContentModeScaleToFill、UIViewContentModeScaleAspectFill、UIViewContentModeScaleAspectFit（默认）
 *  @param scale 用于指定缩放后的图片的倍数
 *
 *  @return 处理完的图片
 */
- (UIImage *)yhhui_imageResizedInLimitedSize:(CGSize)size contentMode:(UIViewContentMode)contentMode scale:(CGFloat)scale;

/**
 *  将原图进行旋转，只能选择上下左右四个方向
 *
 *  @param  direction 旋转的方向
 *
 *  @return 处理完的图片
 */
- (UIImage *)yhhui_imageWithOrientation:(UIImageOrientation)direction;

/**
 对传进来的 `UIView` 截图，生成一个 `UIImage` 并返回。注意这里使用的是 view.layer 来渲染图片内容。
 
 @param view 要截图的 `UIView`
 
 @return `UIView` 的截图
 
 @warning UIView 的 transform 并不会在截图里生效
 */
+ (UIImage *)yhhui_imageWithView:(UIView *)view;

/**
 对传进来的 `UIView` 截图，生成一个 `UIImage` 并返回。注意这里使用的是 iOS 7的系统截图接口。
 
 @param view         要截图的 `UIView`
 @param afterUpdates 是否要在界面更新完成后才截图
 
 @return `UIView` 的截图
 
 @warning UIView 的 transform 并不会在截图里生效
 */
+ (UIImage *)yhhui_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates;
@end
