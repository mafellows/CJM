//
//  CJMMenuTableViewCell.m
//  CJM
//
//  Created by Michael Fellows on 8/7/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMMenuTableViewCell.h"
#import "UIFont+CJMFonts.h"

@implementation CJMMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *highlightedImageView = [[UIImageView alloc] init];
    highlightedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    highlightedImageView.layer.cornerRadius = 5.0f;
    [self.contentView addSubview:highlightedImageView];
    _highlightedImageView = highlightedImageView;
    
    UILabel *menuTitleLabel = [[UILabel alloc] init];
    menuTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    menuTitleLabel.textColor = [UIColor whiteColor];
    menuTitleLabel.textAlignment = NSTextAlignmentCenter;
    menuTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Light" size:28.0f];
    [self.contentView addSubview:menuTitleLabel];
    _menuTitleLabel = menuTitleLabel;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(highlightedImageView, menuTitleLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[highlightedImageView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[highlightedImageView]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuTitleLabel]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuTitleLabel]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    
}

@end
