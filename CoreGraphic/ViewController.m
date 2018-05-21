//
//  ViewController.m
//  CoreGraphic
//
//  Created by ldc on 2018/5/17.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import "ViewController.h"
#import "CGViewController.h"

@interface CGDemoType: NSObject

@property (nonatomic, assign) CGViewType type;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWith:(NSString *)name type:(CGViewType)type;

@end

@implementation CGDemoType

- (instancetype)initWith:(NSString *)name type:(CGViewType)type {
    
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
    }
    return self;
}

@end

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<CGDemoType *> *demoTypes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    self.navigationController.navigationBar.translucent = false;
    self.title = @"demo选择";
    self.demoTypes = [NSMutableArray new];
    [self.demoTypes addObject:[[CGDemoType alloc] initWith:@"miter limit" type:CGViewTypeMiterLimit]];
    [self.demoTypes addObject:[[CGDemoType alloc] initWith:@"虚线绘制" type:CGViewTypeDashLine]];
    [self.demoTypes addObject:[[CGDemoType alloc] initWith:@"透明度设置" type:CGViewTypeAlpha]];
    [self.demoTypes addObject:[[CGDemoType alloc] initWith:@"绘制区域切割" type:CGViewTypeClipToRect]];
    [self.demoTypes addObject:[[CGDemoType alloc] initWith:@"绘制区域图片蒙板切割" type:CGViewTypeClipToMask]];
    [self.demoTypes addObject:[[CGDemoType alloc] initWith:@"颜色模版" type:CGViewTypeColorPattern]];
    [self.demoTypes addObject:[[CGDemoType alloc] initWith:@"图案模版" type:CGViewTypeStencilPattern]];
    [self.demoTypes addObject:[[CGDemoType alloc] initWith:@"渐变色" type:CGViewTypeGradient]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.demoTypes.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iden"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iden"];
    }
    CGDemoType *type = self.demoTypes[indexPath.row];
    cell.textLabel.text = type.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    CGDemoType *type = self.demoTypes[indexPath.row];
    CGViewController *temp = [[CGViewController alloc] initWith:type.type];
    temp.title = type.name;
    [self.navigationController pushViewController:temp animated:true];
}

@end
