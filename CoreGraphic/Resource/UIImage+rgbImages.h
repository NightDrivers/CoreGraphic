//
//  UIImage+rgbImages.h
//  CoreGraphic
//
//  Created by ldc on 2018/6/29.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (rgbImages)

- (NSArray<UIImage *> *)rgbImages;

- (UIImage *)rgImage;

- (NSArray<UIImage *> *)ymcImages;
//获取y单色图、ym混合图
- (NSArray<UIImage *> *)ymImages;

@end
