//
//  DeviceDetail.h
//  services
//
//  Created by Mac on 6/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceDetail : NSObject


@property(strong,nonatomic) NSString *device_id;
@property(strong,nonatomic) NSString *deviceId;
@property(strong,nonatomic) NSString *deviceName;
@property(strong,nonatomic) NSString *deviceType;
@property(strong,nonatomic) NSString *userId;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *updated_at;
@property(strong,nonatomic) NSString *created_at;




-(id) initWithDictionaryfrom: (NSDictionary *)dictionary;


@end
