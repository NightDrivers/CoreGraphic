//
//  ViewController.m
//  CoreGraphic
//
//  Created by ldc on 2018/5/17.
//  Copyright © 2018年 Xiamen Hanin. All rights reserved.
//

#import "ViewController.h"
#import "CGView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    CGView *temp = [[CGView alloc] initWithFrame:self.view.bounds];
    temp.backgroundColor = [UIColor clearColor];
    temp.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:temp];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
