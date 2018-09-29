//
//  UIImage+rgbImages.m
//  CoreGraphic
//
//  Created by ldc on 2018/6/29.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import "UIImage+rgbImages.h"

@implementation UIImage (rgbImages)

- (NSArray<UIImage *> *)rgbImages {
    
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    Byte *bytes = calloc(width*height*4, 1);
    CGContextRef ctx = CGBitmapContextCreate(bytes, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), self.CGImage);
    Byte *red = calloc(width*height*4, 1);
    Byte *green = calloc(width*height*4, 1);
    Byte *blue = calloc(width*height*4, 1);
    for (int i = 0; i < width*height; i++) {
        red[i*4] = bytes[i*4];
        green[i*4+1] = bytes[i*4+1];
        blue[i*4+2] = bytes[i*4+2];
        red[i*4+3] = 0xff;
        green[i*4+3] = 0xff;
        blue[i*4+3] = 0xff;
    }
    CGContextRef red_ctx = CGBitmapContextCreate(red, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef redImageRef = CGBitmapContextCreateImage(red_ctx);
    UIImage *redImage = [UIImage imageWithCGImage:redImageRef];
    
    CGContextRef green_ctx = CGBitmapContextCreate(green, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef greenImageRef = CGBitmapContextCreateImage(green_ctx);
    UIImage *greenImage = [UIImage imageWithCGImage:greenImageRef];
    
    CGContextRef blue_ctx = CGBitmapContextCreate(blue, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef blueImageRef = CGBitmapContextCreateImage(blue_ctx);
    UIImage *blueImage = [UIImage imageWithCGImage:blueImageRef];
    
    CGContextRelease(ctx);
    CGContextRelease(red_ctx);
    CGContextRelease(green_ctx);
    CGContextRelease(blue_ctx);
    
    free(bytes);
    free(red);
    free(green);
    free(blue);
    
    CGImageRelease(redImageRef);
    CGImageRelease(greenImageRef);
    CGImageRelease(blueImageRef);
    
    return @[redImage,greenImage,blueImage];
}

- (UIImage *)rgImage {
    
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    Byte *bytes = calloc(width*height*4, 1);
    CGContextRef ctx = CGBitmapContextCreate(bytes, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), self.CGImage);
    for (int i = 0; i < width*height; i++) {
        bytes[i*4+2] = 0;
        bytes[i*4+3] = 0xff;
    }
    CGImageRef rgImageRef = CGBitmapContextCreateImage(ctx);
    UIImage *rgImage = [UIImage imageWithCGImage:rgImageRef];
    
    CGContextRelease(ctx);
    free(bytes);
    CGImageRelease(rgImageRef);
    
    return rgImage;
}

- (NSArray<UIImage *> *)ymcImages {
    
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    Byte *bytes = calloc(width*height*4, 1);
    CGContextRef ctx = CGBitmapContextCreate(bytes, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), self.CGImage);
    Byte *yellow = calloc(width*height*4, 1);
    Byte *magenta = calloc(width*height*4, 1);
    Byte *cyan = calloc(width*height*4, 1);
    for (int i = 0; i < width*height; i++) {
        UInt8 r = bytes[4*i];
        UInt8 g = bytes[4*i+1];
        UInt8 b = bytes[4*i+2];
        UInt8 y;
        UInt8 m;
        UInt8 c;
        //当rgb值最大值大于其他两个值之后时，对应的ymc值有一个为负
        //将其置0以取得较好的ymc单色效果(会引起数据丢失)
        int y1 = 0.5*g+0.5*r-0.5*b;
        int m1 = 0.5*r+0.5*b-0.5*g;
        int c1 = 0.5*g+0.5+b-0.5*r;
        if (y1 < 0) {
            y = 0;
        }else {
            y = y1;
        }
        if (m1 < 0) {
            m = 0;
        }else {
            m = m1;
        }
        if (c1 < 0) {
            c = 0;
        }else {
            c = c1;
        }
//        @property(class, nonatomic, readonly) UIColor *cyanColor;       // 0.0, 1.0, 1.0 RGB
//        @property(class, nonatomic, readonly) UIColor *yellowColor;     // 1.0, 1.0, 0.0 RGB
//        @property(class, nonatomic, readonly) UIColor *magentaColor;    // 1.0, 0.0, 1.0 RGB
        
        yellow[4*i] = y;
        yellow[4*i+1] = y;
        yellow[4*i+3] = 0xff;
        
        magenta[4*i] = m;
        magenta[4*i+2] = m;
        magenta[4*i+3] = 0xff;
        
        cyan[4*i+1] = c;
        cyan[4*i+2] = c;
        cyan[4*i+3] = 0xff;
    }
    CGContextRef yellow_ctx = CGBitmapContextCreate(yellow, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef yellowImageRef = CGBitmapContextCreateImage(yellow_ctx);
    UIImage *yellowImage = [UIImage imageWithCGImage:yellowImageRef];
    
    CGContextRef magenta_ctx = CGBitmapContextCreate(magenta, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef magentaImageRef = CGBitmapContextCreateImage(magenta_ctx);
    UIImage *magentaImage = [UIImage imageWithCGImage:magentaImageRef];
    
    CGContextRef cyan_ctx = CGBitmapContextCreate(cyan, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef cyanImageRef = CGBitmapContextCreateImage(cyan_ctx);
    UIImage *cyanImage = [UIImage imageWithCGImage:cyanImageRef];
    
    CGContextRelease(ctx);
    CGContextRelease(yellow_ctx);
    CGContextRelease(magenta_ctx);
    CGContextRelease(cyan_ctx);
    
    free(bytes);
    free(yellow);
    free(magenta);
    free(cyan);
    
    CGImageRelease(yellowImageRef);
    CGImageRelease(magentaImageRef);
    CGImageRelease(cyanImageRef);
    
    return @[yellowImage,magentaImage,cyanImage];
}

- (NSArray<UIImage *> *)ymImages {
    
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    Byte *bytes = calloc(width*height*4, 1);
    CGContextRef ctx = CGBitmapContextCreate(bytes, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), self.CGImage);
    Byte *yellow = calloc(width*height*4, 1);
    Byte *yellow_magenta = calloc(width*height*4, 1);
    for (int i = 0; i < width*height; i++) {
        UInt8 r = bytes[4*i];
        UInt8 g = bytes[4*i+1];
        UInt8 b = bytes[4*i+2];
        UInt8 y;
        UInt8 m;
        //当rgb值最大值大于其他两个值之后时，对应的ymc值有一个为负
        //将其置0以取得较好的ymc单色效果(会引起数据丢失)
//        int y1 = 0.5*g+0.5*r-0.5*b;
//        int m1 = 0.5*r+0.5*b-0.5*g;
//        if (y1 < 0) {
//            y = 0;
//        }else {
//            y = y1;
//        }
//        if (m1 < 0) {
//            m = 0;
//        }else {
//            m = m1;
//        }
        y = b;
        //        @property(class, nonatomic, readonly) UIColor *cyanColor;       // 0.0, 1.0, 1.0 RGB
        //        @property(class, nonatomic, readonly) UIColor *yellowColor;     // 1.0, 1.0, 0.0 RGB
        //        @property(class, nonatomic, readonly) UIColor *magentaColor;    // 1.0, 0.0, 1.0 RGB
        
        yellow[4*i] = y+g;
        yellow[4*i+1] = y+g;
        yellow[4*i+3] = 0xff;
        
        yellow_magenta[4*i] = y;
        yellow_magenta[4*i+1] = y+g;
        yellow_magenta[4*i+2] = g+r;
        yellow_magenta[4*i+3] = 0xff;
        
    }
    CGContextRef yellow_ctx = CGBitmapContextCreate(yellow, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef yellowImageRef = CGBitmapContextCreateImage(yellow_ctx);
    UIImage *yellowImage = [UIImage imageWithCGImage:yellowImageRef];
    
    CGContextRef ym_ctx = CGBitmapContextCreate(yellow_magenta, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef ymImageRef = CGBitmapContextCreateImage(ym_ctx);
    UIImage *ymImage = [UIImage imageWithCGImage:ymImageRef];
    
    CGContextRelease(ctx);
    CGContextRelease(yellow_ctx);
    CGContextRelease(ym_ctx);
    
    free(bytes);
    free(yellow);
    free(yellow_magenta);
    
    CGImageRelease(yellowImageRef);
    CGImageRelease(yellowImageRef);
    
    return @[yellowImage,ymImage];
}

@end
