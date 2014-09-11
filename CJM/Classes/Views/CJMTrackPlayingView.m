//
//  CJMTrackPlayingView.m
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMTrackPlayingView.h"
#import "UIFont+CJMFonts.h"
#import "CJMAudioController.h"
#import "CJMAudioController.h"

@interface CJMTrackPlayingView () {
    NSDictionary *_viewsDictionary;
}

@end

@implementation CJMTrackPlayingView

- (id)init
{
    if ((self = [super init])) {
        [self _initialize];
    }
    return self;
}

#pragma mark - Selector

- (void)backPressed:(id)sender
{
    [self _sendNotification:CJMSongControlBack];
}

- (void)playPressed:(id)sender
{
    [self _sendNotification:CJMSongControlPlay];
}

- (void)nextPressed:(id)sender
{
    [self _sendNotification:CJMSongControlNext];
}

- (void)timeSliderChanged:(UISlider *)slider
{
    MPMediaItem *song = [[CJMAudioController sharedController] currentItem];
    if (slider == self.timeSlider && song != nil) {
        AVAudioPlayer *player = [[CJMAudioController sharedController] audioPlayer];
        [player pause];
        CGFloat currentTime = slider.value * player.duration;
        NSLog(@"New time: %f", currentTime);
        [player setCurrentTime:currentTime];
        [player prepareToPlay];
        [player play];
    }
}

- (void)volumeChanged:(UISlider *)slider
{
    if (slider == self.volumeSlider) {
        [self.volumeSlider setValue:slider.value animated:YES];
        [[CJMAudioController sharedController] setVolume:slider.value];
    }

}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[artistLabel(==20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[songTitleLabel(==20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[artistLabel]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[songTitleLabel]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[trackImageView(==44)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[trackImageView(==44)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_viewsDictionary]];
    
    [self.trackImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imagePressedButton]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:_viewsDictionary]];
    
    [self.trackImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imagePressedButton]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:_viewsDictionary]];
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
    
    UILabel *artistLabel = [[UILabel alloc] init]; // WithFrame:CGRectMake(0, 20.0f, 610.0f, 20.0f)];
    artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    artistLabel.textAlignment = NSTextAlignmentLeft;
    artistLabel.font = [UIFont nowPlayingArtistFont];
    artistLabel.text = @"Select A Song";
    [self addSubview:artistLabel];
    _artistLabel = artistLabel;
    
    UILabel *songTitleLabel = [[UILabel alloc] init]; //WithFrame:CGRectMake(0, 44.0f, 610.0f, 20.0f)];
    songTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    songTitleLabel.textAlignment = NSTextAlignmentLeft;
    songTitleLabel.font = [UIFont nowPlayingTitleFont];
    [self addSubview:songTitleLabel];
    _songTitleLabel = songTitleLabel;
    
    UIImageView *trackImageView = [[UIImageView alloc] init];
    trackImageView.image = [UIImage imageNamed:@"HELLMAN_icon_01"];
    trackImageView.clipsToBounds = YES;
    trackImageView.contentMode = UIViewContentModeScaleAspectFill;
    trackImageView.layer.cornerRadius = 2.0f;
    trackImageView.translatesAutoresizingMaskIntoConstraints = NO;
    trackImageView.userInteractionEnabled = YES;
    [self addSubview:trackImageView];
    _trackImageView = trackImageView;
    
    UIButton *imagePressedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imagePressedButton.translatesAutoresizingMaskIntoConstraints = NO;
    imagePressedButton.backgroundColor = [UIColor clearColor];
    [trackImageView addSubview:imagePressedButton];
    _imagePressedButton = imagePressedButton;
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousButton setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    previousButton.frame = CGRectMake(0, 100.0f, 24.0f, 24.0f);
    [previousButton addTarget:self
                       action:@selector(backPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:previousButton];
    _previouisButton = previousButton;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    playButton.frame = CGRectMake(38.0f, 94.0f, 36.0f, 36.0f);
    [playButton addTarget:self
                   action:@selector(playPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    _playButton = playButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(88.0f, 100.0f, 24.0f, 24.0f);
    [nextButton addTarget:self
                   action:@selector(nextPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    _nextButton = nextButton;
    
    UISlider *timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(140, 100.0f, 245.0f, 24.0f)];
    timeSlider.minimumValue = 0.0f;
    timeSlider.maximumValue = 1.0f;
    timeSlider.minimumTrackTintColor = [UIColor blueColor];
    timeSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    [timeSlider addTarget:self
                   action:@selector(timeSliderChanged:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:timeSlider];
    _timeSlider = timeSlider;
    
    UILabel *secondsRemainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(390, 100.0f, 50.0F, 22.0f)];
    secondsRemainingLabel.text = @"00:00";
    secondsRemainingLabel.textAlignment = NSTextAlignmentLeft;
    secondsRemainingLabel.font = [UIFont systemFontOfSize:14.0f];
    secondsRemainingLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:secondsRemainingLabel];
    _secondsRemainingLabel = secondsRemainingLabel;
    
    UIImage *minimumVolumeImage = [UIImage imageNamed:@"quiet-small"];
    UIImageView *minimumVolumeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(440.0f, 100.0f, 24.0f, 24.0f)];
    minimumVolumeImageView.image = minimumVolumeImage;
    [self addSubview:minimumVolumeImageView];
    
    UISlider *volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(468.0f, 100.0f, 100.0f, 24.0f)];
    volumeSlider.minimumValue = 0.0f;
    volumeSlider.maximumValue = 1.0f;
    volumeSlider.value = [[CJMAudioController sharedController] currentVolume]; 
    volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
    volumeSlider.maximumTrackTintColor = [UIColor darkGrayColor];
    [volumeSlider addTarget:self
                     action:@selector(volumeChanged:)
           forControlEvents:UIControlEventValueChanged];
    [self addSubview:volumeSlider];
    _volumeSlider = volumeSlider;
    
    UIImage *maximumVolumeImage = [UIImage imageNamed:@"loud-small"];
    UIImageView *maximumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(586.0f, 100.0f, 24.0f, 24.0f)];
    maximumImageView.image = maximumVolumeImage;
    [self addSubview:maximumImageView];
    
    _viewsDictionary = NSDictionaryOfVariableBindings(trackImageView, artistLabel, songTitleLabel, imagePressedButton);
}

- (void)_sendNotification:(NSInteger)notificationType
{
    switch (notificationType) {
        case CJMSongControlBack:
            [[NSNotificationCenter defaultCenter] postNotificationName:Back_Pressed_Notification
                                                                object:self
                                                              userInfo:nil];
            break;
            
        case CJMSongControlPlay:
            [[NSNotificationCenter defaultCenter] postNotificationName:Play_Pressed_Notification
                                                                object:self
                                                              userInfo:nil];
            break;
            
        case CJMSongControlNext:
            [[NSNotificationCenter defaultCenter] postNotificationName:Next_Pressed_Notification
                                                                object:self
                                                              userInfo:nil];
            break;
            
        default:
            break;
    }
}

@end
