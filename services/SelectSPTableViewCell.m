//
//  SelectSPTableViewCell.m
//  services
//
//  Created by Mac on 5/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SelectSPTableViewCell.h"
#import "DemoCollectionViewCell.h"

@implementation SelectSPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if(selected){
        [self.main_checkbox setOn:YES];
    }else{
        [self.main_checkbox setOn:NO];

    }
    // Configure the view for the selected state
}



@end
