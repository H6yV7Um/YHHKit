//
//  UIView+YHHUI.m
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import "UIView+YHHUI.h"
#import "YHHUICore.h"
#import "UIImage+YHHUI.h"
@implementation UIView (YHHUI)

@end

@implementation UIView (YHH_Layout)

- (CGFloat)yhhui_top {
    return CGRectGetMinY(self.frame);
}

- (void)setYhhui_top:(CGFloat)top {
    self.frame = CGRectSetY(self.frame, top);
}

- (CGFloat)yhhui_left {
    return CGRectGetMinX(self.frame);
}

- (void)setYhhui_left:(CGFloat)left {
    self.frame = CGRectSetX(self.frame, left);
}

- (CGFloat)yhhui_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setYhhui_bottom:(CGFloat)bottom {
    self.frame = CGRectSetY(self.frame, bottom - CGRectGetHeight(self.frame));
}

- (CGFloat)yhhui_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setYhhui_right:(CGFloat)right {
    self.frame = CGRectSetX(self.frame, right - CGRectGetWidth(self.frame));
}

- (CGFloat)yhhui_width {
    return CGRectGetWidth(self.frame);
}

- (void)setYhhui_width:(CGFloat)width {
    self.frame = CGRectSetWidth(self.frame, width);
}

- (CGFloat)yhhui_height {
    return CGRectGetHeight(self.frame);
}

- (void)setYhhui_height:(CGFloat)height {
    self.frame = CGRectSetHeight(self.frame, height);
}

- (CGFloat)yhhui_extendToTop {
    return self.yhhui_top;
}

- (void)setYhhui_extendToTop:(CGFloat)yhhui_extendToTop {
    self.yhhui_height = self.yhhui_bottom - yhhui_extendToTop;
    self.yhhui_top = yhhui_extendToTop;
}

- (CGFloat)yhhui_extendToLeft {
    return self.yhhui_left;
}

- (void)setYhhui_extendToLeft:(CGFloat)yhhui_extendToLeft {
    self.yhhui_width = self.yhhui_right - yhhui_extendToLeft;
    self.yhhui_left = yhhui_extendToLeft;
}

- (CGFloat)yhhui_extendToBottom {
    return self.yhhui_bottom;
}

- (void)setYhhui_extendToBottom:(CGFloat)yhhui_extendToBottom {
    self.yhhui_height = yhhui_extendToBottom - self.yhhui_top;
    self.yhhui_bottom = yhhui_extendToBottom;
}

- (CGFloat)yhhui_extendToRight {
    return self.yhhui_right;
}

- (void)setYhhui_extendToRight:(CGFloat)yhhui_extendToRight {
    self.yhhui_width = yhhui_extendToRight - self.yhhui_left;
    self.yhhui_right = yhhui_extendToRight;
}

- (CGFloat)yhhui_leftWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetWidth(self.superview.bounds), CGRectGetWidth(self.frame));
}

- (CGFloat)yhhui_topWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetHeight(self.superview.bounds), CGRectGetHeight(self.frame));
}

@end

@implementation UIView (YHHUI_Snapshotting)

- (UIImage *)yhhui_snapshotLayerImage {
    return [UIImage yhhui_imageWithView:self];
}

- (UIImage *)yhhui_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates {
    return [UIImage yhhui_imageWithView:self afterScreenUpdates:afterScreenUpdates];
}

@end
