//
//  FavServiceProvider.m
//  services
//
//  Created by Mac on 7/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "FavServiceProvider.h"

@implementation FavServiceProvider

- (id) initWithDictionaryfrom:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){//always use this pattern in a constructor.
        
        self.images = [[NSMutableArray alloc] init];
        
        self._id = [[dictionary objectForKey:@"request"] valueForKey:@"_id"];
        self.senderUserId = [[dictionary objectForKey:@"request"] valueForKey:@"senderUserId"];
        self.requestStatus = [[dictionary objectForKey:@"request"] valueForKey:@"requestStatus"];
        self.hasImage = [[dictionary objectForKey:@"request"] valueForKey:@"hasImage"];
        self.subServiceId = [[dictionary objectForKey:@"request"] valueForKey:@"subServiceId"];
        self.subServiceName = [[dictionary objectForKey:@"request"] valueForKey:@"subServiceName"];
        self.serviceName = [[dictionary objectForKey:@"request"] valueForKey:@"serviceName"];
        self.serviceId = [[dictionary objectForKey:@"request"] valueForKey:@"serviceId"];
        self.receiverName = [[dictionary objectForKey:@"request"] valueForKey:@"receiverName"];
        self.senderName = [[dictionary objectForKey:@"request"] valueForKey:@"senderName"];
        self.message = [[dictionary objectForKey:@"request"] valueForKey:@"message"];
        self.subject = [[dictionary objectForKey:@"request"] valueForKey:@"subject"];
        
        self.images   = [dictionary objectForKey:@"requestFiles"];
        
        
        
        
        
    }
    
    return self;
}




@end
