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
        _currentIndex = 0;
        _songsList = [NSArray array];
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

- (void)nextItem
{
    NSUInteger index = self.currentIndex;
    if (index >= (self.songsList.count -1)) {
        self.currentIndex = 0;
    } else {
        self.currentIndex++;
    }
    self.currentItem = [self.songsList objectAtIndex:self.currentIndex];
    [self playItem];
}

- (void)previousItem
{
    NSUInteger index = self.currentIndex;
    if (index == 0) {
        self.currentIndex = self.songsList.count -1;
    } else {
        self.currentIndex -= 1;
    }
    self.currentItem = [self.songsList objectAtIndex:self.currentIndex];
    [self playItem];
}

- (void)setArrayOfSongs:(NSArray *)songs withCurrentIndex:(NSUInteger)index
{
    self.songsList = songs;
    self.currentIndex = index;
}

- (void)setVolume:(CGFloat)volume
{
    self.volumeLevel = volume;
    NSLog(@"Current Volume: %f", self.volumeLevel);
    [self.audioPlayer setVolume:volume];
}

- (CGFloat)currentVolume
{
    return self.volumeLevel;
}

@end
