//
//  MenuItemCell.m
//  tweetly
//
//  Created by Anna Do on 4/4/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "MenuItemCell.h"

@implementation MenuItemCell

- (void)awakeFromNib
{
    // Initialization code
    NSLog(@"init MenuItemCell");
    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];
    [self.textLabel setTextColor:[UIColor darkGrayColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
