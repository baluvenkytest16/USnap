//
//  FavServiceProvider.h
//  services
//
//  Created by Mac on 7/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavServiceProvider : NSObject

@property(strong,nonatomic) NSString *_id;
@property(strong,nonatomic) NSString *senderUserId;
@property(strong,nonatomic) NSString *requestStatus;
@property(strong,nonatomic) NSString *hasImage;
@property(strong,nonatomic) NSString *subServiceId;
@property(strong,nonatomic) NSString *subServiceName;
@property(strong,nonatomic) NSString *serviceName;
@property(strong,nonatomic) NSString *serviceId;
@property(strong,nonatomic) NSString *receiverName;
@property(strong,nonatomic) NSString *senderName;
@property(strong,nonatomic) NSString *message;
@property(strong,nonatomic) NSString *subject;
@property(strong,nonatomic) NSMutableArray *images;



-(id) initWithDictionaryfrom: (NSDictionary *)dictionary;


@end
