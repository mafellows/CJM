//
//  CJMTrackPlayingView.m
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMTrackPlayingView.h"
#import "UIFont+CJMFonts.h"

@implementation CJMTrackPlayingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)init
{
    if ((self = [super init])) {
        [self _initialize];
    }
    return self;
}

#pragma mark - Private

- (void)_initialize
{
    CGFloat height = 150.0f;
    self.frame = CGRectMake(40.0f,
                            [[UIScreen mainScreen] bounds].size.width - height,
                            610.0f,
                            height);
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 610.0f, 2.0f)];
    separatorView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:separatorView];
    
    UILabel *artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20.0f, 610.0f, 18.0f)];
    artistLabel.textAlignment = NSTextAlignmentCenter;
    artistLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    artistLabel.text = @"Test Artist";
    [self addSubview:artistLabel];
    _artistLabel = artistLabel;
    
    UILabel *songTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42.0f, 610.0f, 18.0f)];
    songTitleLabel.textAlignment = NSTextAlignmentCenter;
    songTitleLabel.text = @"Test Song";
    songTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self addSubview:songTitleLabel];
    _songTitleLabel = songTitleLabel;
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousButton setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    previousButton.frame = CGRectMake(0, 100.0f, 24.0f, 24.0f);
    [self addSubview:previousButton];
    _previouisButton = previousButton;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    playButton.frame = CGRectMake(28.0f, 100.0f, 24.0f, 24.0f);
    [self addSubview:playButton];
    _playButton = playButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(54.0f, 100.0f, 24.0f, 24.0f);
    [self addSubview:nextButton];
    _nextButton = nextButton;
    
    UISlider *timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 200.0f, 24.0f)];
    timeSlider.minimumValue = 0.0f;
    timeSlider.maximumValue = 1.0f;
    timeSlider.minimumTrackTintColor = [UIColor blueColor];
    timeSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    [self addSubview:timeSlider];
    _timeSlider = timeSlider;
    
    UILabel *secondsRemainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(310.0f, 100.0f, 36.0f, 36.0f)];
    secondsRemainingLabel.text = @"00:42";
    secondsRemainingLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:secondsRemainingLabel];
    _secondsRemainingLabel = secondsRemainingLabel;
    
    UIImage *minimumVolumeImage = [UIImage imageNamed:@"quiet-small"];
    UIImageView *minimumVolumeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(440.0f, 100.0f, 24.0f, 24.0f)];
    minimumVolumeImageView.image = minimumVolumeImage;
    [self addSubview:minimumVolumeImageView];
    
    UISlider *volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(468.0f, 100.0f, 100.0f, 24.0f)];
    volumeSlider.minimumValue = 0.0f;
    volumeSlider.maximumValue = 1.0f;
    volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
    volumeSlider.maximumTrackTintColor = [UIColor darkGrayColor];
    [self addSubview:volumeSlider];
    _volumeSlider = volumeSlider;
    
    UIImage *maximumVolumeImage = [UIImage imageNamed:@"loud-small"];
    UIImageView *maximumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(572.0f, 100.0f, 24.0f, 24.0f)];
    maximumImageView.image = maximumVolumeImage;
    [self addSubview:maximumImageView];
}

@end
