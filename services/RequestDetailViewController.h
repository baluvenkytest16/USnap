//
//  RequestDetailViewController.h
//  services
//
//  Created by Mac on 8/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavServiceProvider.h"
#import "KIImagePager.h"


@interface RequestDetailViewController : UIViewController<KIImagePagerDataSource,KIImagePagerImageSource,KIImagePagerDelegate>

@property (weak,nonatomic) FavServiceProvider *serviceProvider;
@property (weak,nonatomic) NSString *user_type;



@end
