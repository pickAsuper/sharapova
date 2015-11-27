//
//  ViewController.m
//  我的订单demo
//
//  Created by 李超 on 15/11/27.
//  Copyright © 2015年 super. All rights reserved.
//

#import "ViewController.h"
#import "HBMyOrderController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(self.view.frame.origin.x/2, self.view.frame.origin.y/2, 30, 30);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick {
    HBMyOrderController *myorder = [[HBMyOrderController alloc]init];
    [self.navigationController pushViewController:myorder animated:YES];
}

@end
