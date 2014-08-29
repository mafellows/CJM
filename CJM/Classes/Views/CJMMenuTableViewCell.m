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
    
    UIView *highlightedView = [[UIView alloc] init];
    highlightedView.translatesAutoresizingMaskIntoConstraints = NO;
    highlightedView.layer.cornerRadius = 5.0f;
    [self.contentView addSubview:highlightedView];
    _highlightedView = highlightedView;
    
    UILabel *menuTitleLabel = [[UILabel alloc] init];
    menuTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    menuTitleLabel.textColor = [UIColor whiteColor];
    menuTitleLabel.textAlignment = NSTextAlignmentCenter;
    menuTitleLabel.font = [UIFont menuFont];
    [highlightedView addSubview:menuTitleLabel];
    _menuTitleLabel = menuTitleLabel;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(highlightedView, menuTitleLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[highlightedView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[highlightedView]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [highlightedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuTitleLabel]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary]];
    
    [highlightedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuTitleLabel]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary]];
    
    
}

@end
