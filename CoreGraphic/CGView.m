//
//  CGView.m
//  CoreGraphic
//
//  Created by ldc on 2018/5/17.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import "CGView.h"
#import <GLKit/GLKit.h>

@implementation CGView

- (void)cg_unkownApi:(CGContextRef)ctx {
    
    //设置曲线绘制精确度，当小于1是，有极高的绘制精度，但是会增加渲染次数。通常不会设置这个flatness,为指定设备性能定义这个值时，会降低其他设备的性能
    CGContextSetFlatness(ctx, 1);
    //上次看到--
//    CGContextSetFillPattern(<#CGContextRef  _Nullable c#>, <#CGPatternRef  _Nullable pattern#>, <#const CGFloat * _Nullable components#>)
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *white = [UIColor whiteColor];
    CGContextSetFillColorWithColor(ctx, white.CGColor);
    CGContextFillRect(ctx, rect);
    
    [self cg_clipToMask:ctx Rect:rect];
}

- (void)cg_clipToMask:(CGContextRef)ctx Rect:(CGRect)rect {
    
//    CGContextClipToRect(ctx, CGRectMake(20, 20, 300, 300));
    CGContextClearRect(ctx, rect);
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    //这个函数使用方法还是不确定
    CGContextClipToMask(ctx, rect, image.CGImage);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextFillRect(ctx, rect);
    CGContextRestoreGState(ctx);
}

- (void)cg_clipToRectTest:(CGContextRef)ctx Rect:(CGRect)rect {
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    
    CGRect rects[2];
    rects[0] = CGRectMake(20, 20, 200, 200);
    rects[1] = CGRectMake(20, 230, 200, 200);
    CGContextClipToRects(ctx, rects, 2);
    
//    CGRect rects2[2];
//    rects2[0] = CGRectMake(120, 120, 200, 200);
//    rects2[1] = CGRectMake(120, 330, 200, 200);
//    CGContextClipToRects(ctx, rects2, 2);
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextDrawImage(ctx, rect, image.CGImage);
    CGContextRestoreGState(ctx);
    //重置裁切区域
    CGContextResetClip(ctx);
    
    CGContextClipToRect(ctx, CGRectMake(20, 440, 200, 200));
    //多次调用时，会在上次的基础上进行裁切
    CGContextClipToRect(ctx, CGRectMake(120, 540, 200, 200));
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextDrawImage(ctx, rect, image.CGImage);
    CGContextRestoreGState(ctx);
    CGContextResetClip(ctx);
}

- (void)cg_setAlphaTest:(CGContextRef)ctx Rect:(CGRect)rect {
    
    //存储画布设置，blendModel、fillColr、strokeColor等设置都会进行存储
    CGContextSaveGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, rect);
    //将画布恢复到上个设置
    CGContextRestoreGState(ctx);
    //设置context alpha值，之后绘制到画布的对象都会用这个alpha值进行处理
    CGContextSetAlpha(ctx, 0.5);
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    CGContextDrawImage(ctx, rect, image.CGImage);
    CGContextRestoreGState(ctx);
}

- (void)cg_dashLineTest:(CGContextRef)ctx Rect:(CGRect)rect {
    
    CGFloat lengths[] = {6,5,4,3,2,1};
    //phase 第一条实线长度，小于lengths[0],若为0，第一条实线长度为lengths[0]
    CGContextSetLineDash(ctx, 3, lengths, 6);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, rect.size.width - 20, 20);
    CGContextAddLineToPoint(ctx, rect.size.width - 20, rect.size.height - 20);
    CGContextSetLineWidth(ctx, 10);
    CGContextSetStrokeColorWithColor(ctx, [UIColor cyanColor].CGColor);
    CGContextStrokePath(ctx);
    //清除虚线设置
    CGContextSetLineDash(ctx, 0, nil, 0);
}

- (void)cg_MiterLimitTest:(CGContextRef)ctx Rect:(CGRect)rect {
    
    //设置线段端点类型
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //设置线段连结点类型
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    //如果joinType为kCGLineJoinMiter,根据两条线相交的斜接边长除以线宽得到结果，与limit比较，若结果大，join效果为kCGLineJoinBevel,否则kCGLineJoinMiter
    //limit = 1/sin(a/2) a为两条线相交角度，若两条线角度小于a，则为kCGLineJoinBevel，否则kCGLineJoinMiter
    CGContextSetMiterLimit(ctx, 1/sin(M_PI_4/2));
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 20, 20);
    CGContextAddLineToPoint(ctx, 20, 300);
    CGContextAddLineToPoint(ctx, 300, 300);
    //连接起点和当前点以闭合贝塞曲线----不是相对开始的结束
    CGContextClosePath(ctx);
    
    CGContextMoveToPoint(ctx, 300, 400);
    CGContextAddLineToPoint(ctx, rect.size.width - 20, rect.size.height - 20);
    CGContextSetLineWidth(ctx, 10);
    CGContextSetStrokeColorWithColor(ctx, [UIColor magentaColor].CGColor);
    CGContextStrokePath(ctx);
}

@end
