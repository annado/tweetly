//
//  ProfileBannerView.m
//  tweetly
//
//  Created by Anna Do on 4/6/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <ColorUtils/ColorUtils.h>
#import "ProfileBannerView.h"

@interface ProfileBannerView ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@end

@implementation ProfileBannerView

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	UIView *containerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
	containerView.frame = self.bounds;
	[self addSubview:containerView];
    // add rounded corners
    self.avatarImageView.layer.cornerRadius = 3;
    self.avatarImageView.clipsToBounds = YES;
    [self.avatarImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.avatarImageView.layer setBorderWidth: 2.0];
    
	return self;
}

- (void)setUser:(User *)user
{
    _user = user;
    [self.bannerImageView setImageWithURL:_user.backgroundURL];
    [self.avatarImageView setImageWithURL:_user.avatarURL];
    self.nameLabel.text = _user.name;
    self.usernameLabel.text = _user.username;
    
    UIColor *textColor = [UIColor colorWithString:_user.textHexColor];
    self.nameLabel.textColor = textColor;
    self.usernameLabel.textColor = textColor;
}

@end
