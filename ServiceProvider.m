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
        
        self.service_id = [[dictionary objectForKey:@"serviceProvider"] valueForKey:@"_id"];
        
        self.service_name = [[dictionary objectForKey:@"userProfile"] valueForKey:@"fullName"];
        
        self.service_price = [[dictionary objectForKey:@"serviceProvider"] valueForKey:@"chargePerHour"];
        
        NSMutableArray *service_addresses = [dictionary objectForKey:@"userAddresses"];
        
        if(service_addresses.count>0){
            NSDictionary *temp_adrs = [service_addresses objectAtIndex:0];

            self.service_address = [temp_adrs objectForKey:@"address1"];
        }
        
        

    }
    return self;
}

@end
