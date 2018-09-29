//
//  CGView.h
//  CoreGraphic
//
//  Created by ldc on 2018/5/17.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CGViewType) {
    CGViewTypeMiterLimit = 0,
    CGViewTypeDashLine,
    CGViewTypeAlpha,
    CGViewTypeClipToRect,
    CGViewTypeClipToMask,
    CGViewTypeColorPattern,
    CGViewTypeStencilPattern,
    CGViewTypeGradient,
    CGViewTypeTransparencyLayers,
    CGViewTypePDF,
    CGViewTypeBlendMode,
    CGViewTypeAnimation
};

@interface CGView : UIView

- (instancetype)initWith:(CGViewType)type;

@end
