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

@interface CJMAudioController : NSObject

@property (nonatomic, strong) MPMediaItem *currentItem;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer; 

+ (instancetype)sharedController; 

- (void)playItem;
- (void)pauseItem;
- (void)nextItem;
- (void)previousItem;
- (void)setVolume:(CGFloat)volume;
- (void)timeRemaining:(int)seconds; 

@end
