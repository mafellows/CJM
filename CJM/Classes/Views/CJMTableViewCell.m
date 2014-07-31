//
//  CJMTableViewCell.m
//  CJM
//
//  Created by Michael Fellows on 7/25/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMTableViewCell.h"

@implementation CJMTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _initialize];
}

- (void)_initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone; 
    UILabel *songLabel = [[UILabel alloc] init];
    songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    songLabel.font = [UIFont tableViewFont];
    [self addSubview:songLabel];
    _songLabel = songLabel;
    
    UILabel *trackLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(550.0f, 10, 80.0f, CGRectGetHeight(self.frame))];
    trackLengthLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:trackLengthLabel];
    _trackLengthLabel = trackLengthLabel;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(40.0f,
                                                                     CGRectGetHeight(self.frame),
                                                                     610.0f,
                                                                     1.0f)];
    separatorView.backgroundColor = [UIColor blackColor]; //[UIColor colorWithWhite:0.9 alpha:1.0f];
    [self addSubview:separatorView];
    

    NSDictionary *viewsCDictionary = NSDictionaryOfVariableBindings(songLabel, trackLengthLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[songLabel(==520)]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsCDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[songLabel]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsCDictionary]];
}

@end
