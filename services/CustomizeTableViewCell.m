//
//  CustomizeTableViewCell.m
//  services
//
//  Created by Mac on 5/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "CustomizeTableViewCell.h"

@implementation CustomizeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(selected){
        [self.sub_ser_check setOn:YES];
    }else{
        [self.sub_ser_check setOn:NO];
        
    }

    // Configure the view for the selected state
}

@end
