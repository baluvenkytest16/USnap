//
//  ServiceProvider.h
//  services
//
//  Created by Mac on 5/19/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceProvider : NSObject

@property(strong,nonatomic) NSString *service_id;
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *service_name;
@property(strong,nonatomic) NSString *service_address;
@property(strong,nonatomic) NSString *service_distance;
@property(strong,nonatomic) NSString *service_price;
@property(strong,nonatomic) NSString *service_rating;
@property(strong,nonatomic) NSString *service_description;
@property(strong,nonatomic) NSString *lat;
@property(strong,nonatomic) NSString *lon;
@property(strong,nonatomic) NSData *image;
@property(strong,nonatomic) NSString *isfav;
@property(strong,nonatomic) NSString *bannerImage;
@property(strong,nonatomic) NSMutableArray *userServices;



-(id) initWithDictionaryfrom: (NSDictionary *)dictionary;
    

@end
