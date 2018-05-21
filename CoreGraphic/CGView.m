//
//  CGView.m
//  CoreGraphic
//
//  Created by ldc on 2018/5/17.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import "CGView.h"
#import <CoreGraphics/CoreGraphics.h>
#define H_PATTERN_SIZE 16
#define V_PATTERN_SIZE 18
#define PSIZE 16    // size of the pattern cell
//pattern cell 使用path进行stroke还是fill
#define StencilPatternCellStroke
//绘图使用pattern进行stroke还是fill
#define StencilPatternDrawStroke

static void MyDrawStencilStar(void *info, CGContextRef myContext)
{
    int k;
    double r, theta;
    
    r = 0.8 * PSIZE / 2;
    theta = 2 * M_PI * (2.0 / 5.0); // 144 degrees
    
    CGContextTranslateCTM (myContext, PSIZE/2, PSIZE/2);
    
    CGContextMoveToPoint(myContext, 0, r);
    for (k = 1; k < 5; k++) {
        CGContextAddLineToPoint (myContext,
                                 r * sin(k * theta),
                                 r * cos(k * theta));
    }
    CGContextClosePath(myContext);
#ifdef StencilPatternCellStroke
    CGContextSetLineWidth(myContext, 0.5);
    CGContextStrokePath(myContext);
#else
    CGContextFillPath(myContext);
#endif
}


void MyDrawColoredPattern(void *info, CGContextRef myContext)
{
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 1);
    CGContextFillRect (myContext, CGRectMake(0, 0, 15, 15));
    
    CGFloat subunit = 5; // the pattern cell itself is 16 by 18
    
    CGRect  myRect1 = {{0,0}, {subunit, subunit}},
    myRect2 = {{subunit, subunit}, {subunit, subunit}},
    myRect3 = {{0,subunit}, {subunit, subunit}},
    myRect4 = {{subunit,0}, {subunit, subunit}};
    
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 0.5);
    CGContextFillRect (myContext, myRect1);
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 0.5);
    CGContextFillRect (myContext, myRect2);
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 0.5);
    CGContextFillRect (myContext, myRect3);
    CGContextSetRGBFillColor (myContext, .5, 0, .5, 0.5);
    CGContextFillRect (myContext, myRect4);
}

@implementation CGView {
    
    CGViewType _type;
}

- (instancetype)initWith:(CGViewType)type {
    
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)cg_apiComment:(CGContextRef)ctx Rect:(CGRect)rect {
    //kCGRenderingIntentDefault 默认
    //kCGRenderingIntentAbsoluteColorimetric 绝对标准 渲染时超出设备颜色范围会被修改，但是设备范围内的颜色不变
    //kCGRenderingIntentRelativeColorimetric 相对标准 渲染时会根据设备颜色范围调整所有色值
    //kCGRenderingIntentPerceptual 根据设备压缩图形颜色范围以保存可视效果，多用于照片和其他复杂、精细的图片
    //kCGRenderingIntentSaturation 根据设备调整色值，但保留饱和度关系，用于低细节图片效果较好，比如演示图形和图表
    //设置渲染意图
    CGContextSetRenderingIntent(ctx, kCGRenderingIntentSaturation);
    //获取插值质量 图像放大等操作时会用到插值算法
    CGContextGetInterpolationQuality(ctx);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
}

- (void)cg_unkownApi:(CGContextRef)ctx {
    
    //设置曲线绘制精确度，当小于1是，有极高的绘制精度，但是会增加渲染次数。通常不会设置这个flatness,为指定设备性能定义这个值时，会降低其他设备的性能
    CGContextSetFlatness(ctx, 1);
    //另一种渐变色绘制方法，但比CGGradientRef复杂，需要自定义颜色渐变相关方法
    CGContextDrawShading(ctx, NULL);
    //上次看到--
    CGContextSetShadowWithColor(ctx, CGSizeMake(3, 3), 1, [UIColor whiteColor].CGColor);
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *white = [UIColor whiteColor];
    CGContextSetFillColorWithColor(ctx, white.CGColor);
    CGContextFillRect(ctx, rect);
    
    switch (_type) {
        case CGViewTypeMiterLimit:
            [self cg_MiterLimitTest:ctx Rect:rect];
            break;
        case CGViewTypeDashLine:
            [self cg_dashLineTest:ctx Rect:rect];
            break;
        case CGViewTypeAlpha:
            [self cg_setAlphaTest:ctx Rect:rect];
            break;
        case CGViewTypeClipToRect:
            [self cg_clipToRectTest:ctx Rect:rect];
            break;
        case CGViewTypeClipToMask:
            [self cg_clipToMask:ctx Rect:rect];
            break;
        case CGViewTypeColorPattern:
            [self cg_colorPatternTest:ctx Rect:rect];
            break;
        case CGViewTypeStencilPattern:
            [self cg_stencilPatterTest:ctx Rect:rect];
            break;
        case CGViewTypeGradient:
            [self cg_gradientTest:ctx Rect:rect];
            break;
        default:
            break;
    }
}

- (void)cg_gradientTest:(CGContextRef)ctx Rect:(CGRect)rect {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {1,0,0,1,0,1,0,1};
    CGFloat location[] = {0,1};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, location, 2);
//    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(rect.size.width, rect.size.height), 0);
    CGContextDrawRadialGradient(ctx, gradient, CGPointMake(50, 50), 50, CGPointMake(rect.size.width-100, rect.size.height - 100), 100, 0);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

- (void)cg_stencilPatterTest:(CGContextRef)ctx Rect:(CGRect)rect {
    
    CGPatternRef pattern;
    CGColorSpaceRef baseSpace;
    CGColorSpaceRef patternSpace;
    static const CGFloat color[4] = { 0, 1, 1, 1 };
    static const CGPatternCallbacks callbacks = {0, &MyDrawStencilStar, NULL};
    baseSpace = CGColorSpaceCreateDeviceRGB ();
    patternSpace = CGColorSpaceCreatePattern (baseSpace);
    
#ifdef StencilPatternDrawStroke
    CGContextSetStrokeColorSpace(ctx, patternSpace);
    pattern = CGPatternCreate(NULL, CGRectMake(0, 0, PSIZE, PSIZE),// 6
                              CGAffineTransformTranslate(CGAffineTransformIdentity, PSIZE/2, PSIZE/2), PSIZE, PSIZE,
                              kCGPatternTilingConstantSpacing,
                              false, &callbacks);
    CGContextSetStrokePattern(ctx, pattern, color);
    CGContextStrokeRectWithWidth(ctx, CGRectMake(PSIZE, PSIZE, PSIZE*20, PSIZE*20), PSIZE);
#else
    CGContextSetFillColorSpace (ctx, patternSpace);
    pattern = CGPatternCreate(NULL, CGRectMake(0, 0, PSIZE, PSIZE),
                              CGAffineTransformIdentity, PSIZE, PSIZE,
                              kCGPatternTilingConstantSpacing,
                              false, &callbacks);
    CGContextSetFillPattern (ctx, pattern, color);
    CGContextFillRect (ctx,CGRectMake (0,0,PSIZE*20,PSIZE*20));
#endif
    
    CGPatternRelease (pattern);
    CGColorSpaceRelease (patternSpace);
    CGColorSpaceRelease (baseSpace);
}

- (void)cg_colorPatternTest:(CGContextRef)ctx Rect:(CGRect)rect {
    
    CGColorSpaceRef space = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(ctx, space);
    CGColorSpaceRelease(space);
    
    static const CGPatternCallbacks callback = {0,&MyDrawColoredPattern,NULL};
    
    CGPatternRef pattern = CGPatternCreate(NULL, CGRectMake(0, 0, 15, 15), CGAffineTransformIdentity, 15, 15, kCGPatternTilingNoDistortion, YES, &callback);
    CGFloat alpha = 1;
    CGContextSetFillPattern(ctx, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(ctx, rect);
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
    //实虚实虚实虚 循环
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
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(3, 3), 10, [UIColor blueColor].CGColor);
    //设置线段端点类型
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //设置线段连结点类型
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    //如果joinType为kCGLineJoinMiter,根据两条线相交的斜接边长除以线宽得到结果，与limit比较，若结果大，join效果为kCGLineJoinBevel,否则kCGLineJoinMiter
    //limit = 1/sin(a/2) a为两条线相交角度，若两条线角度小于a，则为kCGLineJoinBevel，否则kCGLineJoinMiter
    CGContextSetMiterLimit(ctx, 1/sin((M_PI_4 + 0.00000001)/2));
    
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
