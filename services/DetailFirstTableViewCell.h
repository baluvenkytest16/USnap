//
//  DetailFirstTableViewCell.h
//  services
//
//  Created by Mac on 4/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailFirstTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *service_name;
@property (strong, nonatomic) IBOutlet UIImageView *sp_image;

@property (strong, nonatomic) IBOutlet UIImageView *service_image;
@property (strong, nonatomic) IBOutlet UILabel *service_address;
@end
