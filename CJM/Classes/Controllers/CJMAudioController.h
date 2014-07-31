//
//  CJMAudioController.h
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define Back_Pressed_Notification @"backPressed"
#define Play_Pressed_Notification @"playPressed"
#define Next_Pressed_Notification @"nextPressed"
#define Time_Slider_Notification @"timeSlider"
#define Volume_Slider_Notification @"volumeSlider"


@interface CJMAudioController : NSObject

@property (nonatomic, strong) MPMediaItem *currentItem;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) NSArray *shufflePlaylist; 

+ (instancetype)sharedController; 

- (void)playItem;
- (void)pauseItem;
- (void)nextItem;
- (void)previousItem;
- (void)setVolume:(CGFloat)volume;
- (void)timeRemaining:(int)seconds; 

@end
