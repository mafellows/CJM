//
//  CJMTableHeaderView.m
//  CJM
//
//  Created by Michael Fellows on 7/25/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMTableHeaderView.h"

@implementation CJMTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    UILabel *sectionTitleLabel = [[UILabel alloc] init];
    sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    sectionTitleLabel.font = [UIFont cellHeaderFont];
    sectionTitleLabel.numberOfLines = 0;
    sectionTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:sectionTitleLabel];
    _sectionTitleLabel = sectionTitleLabel;
    
    self.backgroundColor = [UIColor clearColor];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(sectionTitleLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[sectionTitleLabel(==610)]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sectionTitleLabel]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
}

@end
