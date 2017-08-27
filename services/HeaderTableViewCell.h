//
//  HeaderTableViewCell.h
//  services
//
//  Created by Mac on 5/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface HeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *charge_rate;
@property (strong, nonatomic) IBOutlet BEMCheckBox *nego_chekc;

@end
