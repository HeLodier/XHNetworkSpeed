# XHNetworkSpeed
网络速度

使用方法:
1. 开始监听网络速度
    
         [[XHNetworkSpeed shareNetworkSpeed]startMonitoringNetworkSpeed];

2. 网络速度回调
      
        2.1 接收网络速度回调
        
         [[XHNetworkSpeed shareNetworkSpeed]GetReceivedNetSpeedCompleteBlock:^(NSString *receivedSpeed) {
                    weakSelf.receivedLab.text = [NSString stringWithFormat:@"接收:-----%@",receivedSpeed];
          }];
       
        2.2 发送网络速度回调
      
     
         [[XHNetworkSpeed shareNetworkSpeed]GetSendNetSpeedCompleteBlock:^(NSString *sendSpeed) {
                    weakSelf.speedLab.text = [NSString stringWithFormat:@"发送:-----%@",sendSpeed];
          }];

3. 停止网络监听
   
         [[XHNetworkSpeed shareNetworkSpeed]stopMonitoringNetworkSpeed];
