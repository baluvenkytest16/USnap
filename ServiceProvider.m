//
//  ServiceProvider.m
//  services
//
//  Created by Mac on 5/19/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "ServiceProvider.h"

@implementation ServiceProvider

- (id) initWithDictionaryfrom:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){//always use this pattern in a constructor.
        
        self.isfav = [dictionary valueForKey:@"isFavorite"];
        
        self.service_id = [[dictionary objectForKey:@"serviceProvider"] valueForKey:@"_id"];
        
        self.service_name = [[dictionary objectForKey:@"userProfile"] valueForKey:@"fullName"];
        
        self.user_id = [[dictionary objectForKey:@"userProfile"] valueForKey:@"userId"];
        
        self.service_price = [[dictionary objectForKey:@"serviceProvider"] valueForKey:@"chargePerHour"];
        
        self.userServices = [dictionary objectForKey:@"providerServicesInfo"];
        
        NSMutableArray *service_addresses = [dictionary objectForKey:@"userAddresses"];
        
        if(service_addresses.count>0){
            
            NSDictionary *temp_adrs = [service_addresses firstObject];
            self.service_address = [temp_adrs objectForKey:@"address1"];
            self.lat = [temp_adrs objectForKey:@"latitude"];
            self.lon = [temp_adrs objectForKey:@"longitude"];
            
        }
    }
    return self;
}

@end
