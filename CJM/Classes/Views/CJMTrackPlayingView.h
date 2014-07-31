//
//  CJMTrackPlayingView.h
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger, CJMSongControl) {
    CJMSongControlBack,
    CJMSongControlPlay,
    CJMSongControlNext,
    CJMSongControlTimeSlider,
    CJMSongControlVolumeSlider
};

@interface CJMTrackPlayingView : UIView

@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UILabel *songTitleLabel;
@property (nonatomic, weak) UIButton *playButton;
@property (nonatomic, weak) UIButton *previouisButton;
@property (nonatomic, weak) UIButton *nextButton;
@property (nonatomic, weak) UISlider *volumeSlider;
@property (nonatomic, weak) UISlider *timeSlider;
@property (nonatomic, weak) UILabel *secondsRemainingLabel;
@property (nonatomic, strong) MPMediaItem *currentSong; 

@end
