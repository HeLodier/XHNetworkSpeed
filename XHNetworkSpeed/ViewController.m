//
//  ViewController.m
//  XHNetworkSpeed
//
//  Created by YZJMACMini on 2018/8/16.
//  Copyright © 2018年 Lxh.yzj. All rights reserved.
//

#import "ViewController.h"
#import "XHNetworkSpeed.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *speedLab;
@property (weak, nonatomic) IBOutlet UILabel *receivedLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (IBAction)startTestSpeedClick:(UIButton *)sender {
    
    [[XHNetworkSpeed shareNetworkSpeed]startMonitoringNetworkSpeed];
    
    __weak typeof(ViewController *)weakSelf = self;
    [[XHNetworkSpeed shareNetworkSpeed]GetSendNetSpeedCompleteBlock:^(NSString *sendSpeed) {
        weakSelf.speedLab.text = [NSString stringWithFormat:@"发送:-----%@",sendSpeed];
    }];
    [[XHNetworkSpeed shareNetworkSpeed]GetReceivedNetSpeedCompleteBlock:^(NSString *receivedSpeed) {
        weakSelf.receivedLab.text = [NSString stringWithFormat:@"接收:-----%@",receivedSpeed];
    }];
}
- (IBAction)stopTestSpeedClick:(UIButton *)sender {
    
    [[XHNetworkSpeed shareNetworkSpeed]stopMonitoringNetworkSpeed];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
