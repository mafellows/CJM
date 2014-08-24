//
//  CJMSearchHeaderView.m
//  CJM
//
//  Created by Michael Fellows on 7/25/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSearchHeaderView.h"

@interface CJMSearchHeaderView () {
    NSDictionary *_viewsDictionary;
    NSArray *_constraintWithCaret;
    NSArray *_constraintWithoutCaret;
}

@end

@implementation CJMSearchHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (self.caretButton.isHidden) {
        [self removeConstraints:_constraintWithCaret];
        [self addConstraints:_constraintWithoutCaret];
    } else {
        [self removeConstraints:_constraintWithoutCaret];
        [self addConstraints:_constraintWithCaret]; 
    }
}

#pragma mark - Private

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
    searchBar.placeholder = @"Search"; 
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self addSubview:searchBar];
    _searchBar = searchBar;
    
    UIButton *caretButton = [UIButton buttonWithType:UIButtonTypeCustom];
    caretButton.translatesAutoresizingMaskIntoConstraints = NO;
    caretButton.alpha = 0.5;
    [caretButton setImage:[UIImage imageNamed:@"caret"]
                 forState:UIControlStateNormal];
    [self addSubview:caretButton];
    _caretButton = caretButton;
    
    _viewsDictionary = NSDictionaryOfVariableBindings(titleLabel, searchBar, caretButton);
    
    _constraintWithCaret = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[caretButton(==24)]-[titleLabel]-[searchBar(==200)]-110-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:_viewsDictionary];
    
    _constraintWithoutCaret = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[titleLabel]-[searchBar(==200)]-110-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:_viewsDictionary];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[titleLabel]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[searchBar]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-42-[caretButton(==24)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self addConstraints:_constraintWithCaret];
    
}

@end
