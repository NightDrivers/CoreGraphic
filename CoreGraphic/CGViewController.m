//
//  CGViewController.m
//  CoreGraphic
//
//  Created by ldc on 2018/5/21.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import "CGViewController.h"

@interface CGViewController ()

@property (nonatomic, assign) CGViewType type;

@end

@implementation CGViewController

- (instancetype)initWith:(CGViewType)type {
    
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGView *temp = [[CGView alloc] initWith:self.type];
    temp.frame = self.view.bounds;
    temp.backgroundColor = [UIColor clearColor];
    temp.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:temp];
}

@end
