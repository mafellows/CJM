//
//  CJMQueryStore.m
//  CJM
//
//  Created by Michael Fellows on 8/4/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMQueryStore.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation CJMQueryStore

+ (instancetype)sharedStore
{
    static CJMQueryStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    return sharedStore;
}

- (NSArray *)currentResults
{
    if (!_currentResults) {
        MPMediaQuery *searchQuery = [MPMediaQuery songsQuery];
        _currentResults = [searchQuery items];
    }
    return _currentResults;
}

- (NSArray *)resultsForQuery:(NSString *)query
{
    MPMediaQuery *searchQuery = [[MPMediaQuery alloc] init];
    NSPredicate *test = [NSPredicate predicateWithFormat:@"title contains[cd] %@ OR albumTitle contains[cd] %@ OR artist contains[cd] %@",
                         query,
                         query,
                         query];
    NSArray *filteredArray = [[searchQuery items] filteredArrayUsingPredicate:test];
    if (filteredArray.count == 0) {
        MPMediaQuery *allQuery = [MPMediaQuery songsQuery];
        self.currentResults = [allQuery items];
    } else {
        self.currentResults = filteredArray;
    }
    return self.currentResults;
}

@end
