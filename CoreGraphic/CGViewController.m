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

@property (nonatomic, strong) CGView *temp;

@property (nonatomic, strong) CGView *temp1;

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
    
    self.temp = [[CGView alloc] initWith:self.type];
    self.temp.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
    self.temp.frame = self.view.bounds;
    self.temp.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.temp];
}

@end
