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
        _audioPlayer = [[AVAudioPlayer alloc] init];
    }
    return self;
}

- (void)playItem
{
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self.currentItem valueForProperty:MPMediaItemPropertyAssetURL]
                                                              error:nil];
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
    [self.audioPlayer setVolume:volume];
}

- (void)timeRemaining:(int)seconds
{
    
}

@end
