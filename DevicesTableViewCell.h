//
//  DevicesTableViewCell.h
//  services
//
//  Created by Mac on 6/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevicesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *device_name;
@property (strong, nonatomic) IBOutlet UIButton *unlink_btn;

@end
