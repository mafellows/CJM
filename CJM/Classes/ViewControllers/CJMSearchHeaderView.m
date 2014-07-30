//
//  CJMSearchHeaderView.m
//  CJM
//
//  Created by Michael Fellows on 7/25/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSearchHeaderView.h"

@implementation CJMSearchHeaderView

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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont titleFont];
    titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0f];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self addSubview:searchBar];
    _searchBar = searchBar;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(titleLabel, searchBar);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[titleLabel]-[searchBar(==200)]-50-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[titleLabel]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[searchBar]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
}

@end
