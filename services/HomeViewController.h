//
//  HomeViewController.h
//  services
//
//  Created by Mac on 4/19/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@import LGSideMenuController;

@interface HomeViewController : UIViewController<KIImagePagerDataSource,KIImagePagerImageSource,UITableViewDelegate,UITableViewDataSource>
    @property (weak, nonatomic) IBOutlet UICollectionView *homeTable;
@property (weak,nonatomic) NSString *gotologin;

@end
