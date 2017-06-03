//
//  CustomizeTableViewCell.h
//  services
//
//  Created by Mac on 5/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface CustomizeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet BEMCheckBox *sub_ser_check;
@property (strong, nonatomic) IBOutlet UILabel *sub_sp_name;

@end
