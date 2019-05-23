//
//  ViewController.m
//  XXTimeMonitorDemo
//
//  Created by xxg90s on 2019/5/23.
//  Copyright © 2019 AnTuan Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fakeDelaySelector];
    
}

- (void)fakeDelaySelector {
    int a = 0;
    for (int i = 0; i < 50000000; i++) {
        a += 1;
    }
}

@end
