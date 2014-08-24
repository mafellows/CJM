//
//  CJMSidePanelTableViewCell.m
//  CJM
//
//  Created by Michael Fellows on 8/19/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSidePanelTableViewCell.h"
#import "UIFont+CJMFonts.h"

@implementation CJMSidePanelTableViewCell

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
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *itemLabel = [[UILabel alloc] init];
    itemLabel.translatesAutoresizingMaskIntoConstraints = NO;
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.numberOfLines = 0;
    itemLabel.lineBreakMode = NSLineBreakByWordWrapping;
    itemLabel.font = [UIFont cellHeaderFont];
    itemLabel.textColor = [UIColor colorWithRed:255.0f / 255.0f
                                          green:170.0f / 255.0f
                                           blue:2.0f / 255.0f
                                          alpha:1.0f];
    [self.contentView addSubview:itemLabel];
    _itemLabel = itemLabel;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(itemLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[itemLabel(==290)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[itemLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
}

@end
