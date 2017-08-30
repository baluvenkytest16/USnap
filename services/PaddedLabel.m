//
//  PaddedLabel.m
//  services
//
//  Created by Mac on 7/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "PaddedLabel.h"

@implementation PaddedLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
