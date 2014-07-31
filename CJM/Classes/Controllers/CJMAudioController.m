//
//  CJMAudioController.m
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMAudioController.h"

@implementation CJMAudioController

+ (instancetype)sharedController
{
    static CJMAudioController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

- (id)init
{
    if ((self = [super init])) {
        _volumeLevel = 0.5; 
    }
    return self;
}

- (void)playItem
{
    NSURL *audioURL = [self.currentItem valueForProperty:MPMediaItemPropertyAssetURL];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL
                                                              error:nil];
    self.audioPlayer.volume = self.volumeLevel; 
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)pauseItem
{
    [self.audioPlayer pause];
}

- (void)nextItem
{
    
}

- (void)previousItem
{
    
}

- (void)setVolume:(CGFloat)volume
{
    self.volumeLevel = volume;
    NSLog(@"Current Volume: %f", self.volumeLevel);
    [self.audioPlayer setVolume:volume];
}

- (void)timeRemaining:(int)seconds
{
    
}

- (CGFloat)currentVolume
{
    return self.volumeLevel;
}

@end
