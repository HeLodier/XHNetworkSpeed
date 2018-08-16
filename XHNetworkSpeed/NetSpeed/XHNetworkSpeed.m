//
//  XHNetworkSpeed.m
//  XHNetworkSpeed
//
//  Created by YZJMACMini on 2018/8/16.
//  Copyright © 2018年 Lxh.yzj. All rights reserved.
//

#import "XHNetworkSpeed.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <net/if_dl.h>


@interface XHNetworkSpeed ()
{
    uint32_t _iBytes;
    uint32_t _oBytes;
    uint32_t _allFlow;
    uint32_t _wifiIBytes;
    uint32_t _wifiOBytes;
    uint32_t _wifiFlow;
    uint32_t _wwanIBytes;
    uint32_t _wwanOBytes;
    uint32_t _wwanFlow;
}

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic,copy) void(^sendSpeedBlock)(NSString *sendSpeed);
@property (nonatomic,copy) void(^receivedSpeedBlock)(NSString *receivedSpeed);
@end



@implementation XHNetworkSpeed
static XHNetworkSpeed * instance = nil;
+ (instancetype)shareNetworkSpeed{
    if(instance == nil){
        static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            instance = [[self alloc] init] ;
        }) ;
    }
    return instance;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            instance = [super allocWithZone:zone];
            
        });
    }
    return instance;
}

-(instancetype)init{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
        self->_iBytes =
        self->_oBytes =
        self->_allFlow =
        self->_wifiIBytes =
        self->_wifiOBytes =
        self->_wifiFlow =
        self->_wwanIBytes =
        self->_wwanOBytes =
        self->_wwanFlow = 0;
    });
    return instance;
    
}


-(void)GetSendNetSpeedCompleteBlock:(void (^)(NSString *))netSpeed{
    self.sendSpeedBlock = ^(NSString *sendSpeed) {
        netSpeed(sendSpeed);
    };
}

-(void)GetReceivedNetSpeedCompleteBlock:(void (^)(NSString *))netSpeed{
    self.receivedSpeedBlock = ^(NSString *receivedSpeed) {
        netSpeed(receivedSpeed);
    };
}
- (void)startMonitoringNetworkSpeed{
    if(_timer)
        [self stopMonitoringNetworkSpeed];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(netSpeedNotification) userInfo:nil repeats:YES];
}

- (void)stopMonitoringNetworkSpeed{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)netSpeedNotification{
    [self checkNetworkflow];
}

-(NSString *)bytesToAvaiUnit:(int)bytes
{
    if(bytes < 10)
    {
        return [NSString stringWithFormat:@"0KB"];
    }
    else if(bytes >= 10 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.1fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.1fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}


-(void)checkNetworkflow
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
    }
    
    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow    = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow   = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow   = 0;
    //    struct timeval32 time;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        // network flow
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
        
        //wifi flow
        if (!strcmp(ifa->ifa_name, "en0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow    = wifiIBytes + wifiOBytes;
        }
        
        //3G and gprs flow
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow    = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
    
    
    if (_iBytes != 0) {
        self.receivedSpeedBlock([[self bytesToAvaiUnit:iBytes - _iBytes] stringByAppendingString:@"/s"]);
    }
    
    _iBytes = iBytes;
    
    if (_oBytes != 0) {
        self.sendSpeedBlock([[self bytesToAvaiUnit:oBytes - _oBytes] stringByAppendingString:@"/s"]);
    }
    _oBytes = oBytes;
}


@end
