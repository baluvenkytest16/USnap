//
//  DeviceDetail.m
//  services
//
//  Created by Mac on 6/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "DeviceDetail.h"

@implementation DeviceDetail


- (id) initWithDictionaryfrom:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){//always use this pattern in a constructor.
        
        self.device_id = [dictionary valueForKey:@"_id"];
        
        self.deviceId = [dictionary valueForKey:@"deviceId"];
        
        self.deviceName = [dictionary valueForKey:@"deviceName"];
        
        self.deviceType = [dictionary valueForKey:@"deviceType"];
        
        self.userId = [dictionary valueForKey:@"userId"];
        
        self.status = [dictionary valueForKey:@"status"];
        
        self.updated_at = [dictionary valueForKey:@"updated_at"];
        
        self.created_at = [dictionary valueForKey:@"created_at"];
        
    }
    return self;
}

@end
