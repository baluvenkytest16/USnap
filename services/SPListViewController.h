//
//  SPListViewController.h
//  services
//
//  Created by Mac on 4/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface SPListViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>
@property (weak,nonatomic) NSString *serviceId;


@end
