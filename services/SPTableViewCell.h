//
//  SPTableViewCell.h
//  services
//
//  Created by Mac on 4/22/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *sp_name;
@property (strong, nonatomic) IBOutlet UILabel *sp_address;
@property (strong, nonatomic) IBOutlet UILabel *sp_distance;
@property (strong, nonatomic) IBOutlet UILabel *sp_rate;
@property (strong, nonatomic) IBOutlet UILabel *sp_rating;
@property (strong, nonatomic) IBOutlet UIImageView *sp_logo;
@property (strong, nonatomic) IBOutlet UILabel *sp_contact_now;

@end
