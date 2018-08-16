//
//  XHNetworkSpeed.h
//  XHNetworkSpeed
//
//  Created by YZJMACMini on 2018/8/16.
//  Copyright © 2018年 Lxh.yzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHNetworkSpeed : NSObject

+(instancetype)shareNetworkSpeed;

-(void)startMonitoringNetworkSpeed;

-(void)stopMonitoringNetworkSpeed;

-(void)GetSendNetSpeedCompleteBlock:(void(^)(NSString *sendSpeed))netSpeed;
-(void)GetReceivedNetSpeedCompleteBlock:(void(^)(NSString *receivedSpeed))netSpeed;

@end
