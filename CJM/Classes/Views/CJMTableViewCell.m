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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.songLabel.textColor = [UIColor lightGrayColor];
        self.trackLengthLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.songLabel.textColor = [UIColor darkTextColor];
        self.trackLengthLabel.textColor = [UIColor darkTextColor];
    }
}

- (void)_initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone; 
    UILabel *songLabel = [[UILabel alloc] init];
    songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    songLabel.font = [UIFont cellFont];
    [self addSubview:songLabel];
    _songLabel = songLabel;
    
    UILabel *trackLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(550.0f, 10, 80.0f, CGRectGetHeight(self.frame))];
    trackLengthLabel.textAlignment = NSTextAlignmentRight;
    trackLengthLabel.font = [UIFont cellFont]; 
    [self addSubview:trackLengthLabel];
    _trackLengthLabel = trackLengthLabel;
    
    UIImageView *speakerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(600.0f, 10.0f, 36.0f, 36.0f)];
    speakerImageView.image = [UIImage imageNamed:@"now-playing"];
    [self addSubview:speakerImageView];
    speakerImageView.hidden = YES; 
    _speakerImageView = speakerImageView;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(40.0f,
                                                                     CGRectGetHeight(self.frame),
                                                                     610.0f,
                                                                     1.0f)];
    separatorView.backgroundColor = [UIColor colorWithRed:229.0f / 255.0f green:227.0f / 255.0f blue:193.0f / 255.0f alpha:0.8f]; 
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
