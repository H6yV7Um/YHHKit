//
//  UIView+YHHUI.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YHHUI)

@end

/**
 *  对 view.frame 操作的简便封装，注意 view 与 view 之间互相计算时，需要保证处于同一个坐标系内。
 */
@interface UIView (YHHUI_Layout)

/// 等价于 CGRectGetMinY(frame)
@property(nonatomic, assign) CGFloat yhhui_top;

/// 等价于 CGRectGetMinX(frame)
@property(nonatomic, assign) CGFloat yhhui_left;

/// 等价于 CGRectGetMaxY(frame)
@property(nonatomic, assign) CGFloat yhhui_bottom;

/// 等价于 CGRectGetMaxX(frame)
@property(nonatomic, assign) CGFloat yhhui_right;

/// 等价于 CGRectGetWidth(frame)
@property(nonatomic, assign) CGFloat yhhui_width;

/// 等价于 CGRectGetHeight(frame)
@property(nonatomic, assign) CGFloat yhhui_height;

/// 保持其他三个边缘的位置不变的情况下，将顶边缘拓展到某个指定的位置，注意高度会跟随变化。
@property(nonatomic, assign) CGFloat yhhui_extendToTop;

/// 保持其他三个边缘的位置不变的情况下，将左边缘拓展到某个指定的位置，注意宽度会跟随变化。
@property(nonatomic, assign) CGFloat yhhui_extendToLeft;

/// 保持其他三个边缘的位置不变的情况下，将底边缘拓展到某个指定的位置，注意高度会跟随变化。
@property(nonatomic, assign) CGFloat yhhui_extendToBottom;

/// 保持其他三个边缘的位置不变的情况下，将右边缘拓展到某个指定的位置，注意宽度会跟随变化。
@property(nonatomic, assign) CGFloat yhhui_extendToRight;

/// 获取当前 view 在 superview 内水平居中时的 left
@property(nonatomic, assign, readonly) CGFloat yhhui_leftWhenCenterInSuperview;

/// 获取当前 view 在 superview 内垂直居中时的 top
@property(nonatomic, assign, readonly) CGFloat yhhui_topWhenCenterInSuperview;

@end


/**
 *  方便地将某个 UIView 截图并转成一个 UIImage，注意如果这个 UIView 本身做了 transform，也不会在截图上反映出来，截图始终都是原始 UIView 的截图。
 */
@interface UIView (YHHUI_Snapshotting)

- (UIImage *)yhhui_snapshotLayerImage;
- (UIImage *)yhhui_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates;
@end
