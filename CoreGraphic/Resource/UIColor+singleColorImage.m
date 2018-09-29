//
//  UIColor+singleColorImage.m
//  CoreGraphic
//
//  Created by ldc on 2018/6/28.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import "UIColor+singleColorImage.h"

@implementation UIColor (singleColorImage)

- (UIImage *)image {
    
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    [self setFill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFillRect(ctx, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
