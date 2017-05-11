//
//  SelectSPTableViewCell.h
//  services
//
//  Created by Mac on 5/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface SelectSPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spName;

@property (weak, nonatomic) IBOutlet BEMCheckBox *main_checkbox;
@property (weak, nonatomic) IBOutlet BEMCheckBox *sub_checkbox;
@property (weak, nonatomic) IBOutlet UITextField *charge_field;

@end
