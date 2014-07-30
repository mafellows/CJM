//
//  CJMMenuHeaderView.m
//  CJM
//
//  Created by Michael Fellows on 7/23/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMMenuHeaderView.h"

@implementation CJMMenuHeaderView

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
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.center = self.center;
    imageView.image = [UIImage imageNamed:@"logo"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    
    self.backgroundColor = [UIColor clearColor];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(imageView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[imageView]-40-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[imageView]-40-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
}

@end
