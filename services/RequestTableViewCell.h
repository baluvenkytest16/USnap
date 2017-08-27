//
//  RequestTableViewCell.h
//  services
//
//  Created by Mac on 7/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *request_subject;
@property (strong, nonatomic) IBOutlet UILabel *request_message;
@property (strong, nonatomic) IBOutlet UIImageView *request_image;

@end
