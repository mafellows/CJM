//
//  FWMArtistsTableViewController.m
//  Music-Fun
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 broadwaylab. All rights reserved.
//

#import "FWMArtistsTableViewController.h"
#import <MediaPlayer/MediaPlayer.h> 

@interface FWMArtistsTableViewController ()

@property (nonatomic, copy) NSArray *artists;
@property (nonatomic, copy) NSArray *dictionaryArray;
@property (nonatomic, copy) NSArray *sectionHeaders;

@end

@implementation FWMArtistsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Artists";
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeaders objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionHeaders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:section];
    NSArray *songs = [dictionary objectForKey:[self.sectionHeaders objectAtIndex:section]];
    return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *key = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:key];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@ - %@",
                        [song valueForProperty:MPMediaItemPropertyTitle],
                        [song valueForProperty:MPMediaItemPropertyPlaybackDuration]];
    cell.textLabel.text = string; 
    return cell;
}

#pragma mark - Private

- (void)_initialize
{
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    NSArray *artists = [artistsQuery items];
    
    NSMutableArray *allArtists = [NSMutableArray array];
    for (MPMediaItem *item in artists) {
        NSString *song = [item valueForKey:MPMediaItemPropertyAlbumArtist];
        if (song) [allArtists addObject:song];
    }
    
    NSArray *uniqueArtists = [[NSSet setWithArray:allArtists] allObjects];
    NSLog(@"Unique Artists: %@", uniqueArtists);
    
    for (NSString *artist in uniqueArtists) {
        MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate predicateWithValue:artist
                                                                                     forProperty:MPMediaItemPropertyAlbumArtist
                                                                                  comparisonType:MPMediaPredicateComparisonEqualTo];
        
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        [songsQuery addFilterPredicate:artistPredicate];
        NSArray *songsArray = [songsQuery items];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:songsArray forKey:artist];
        [arrayOfDictionaries addObject:dictionary];
    }

    self.dictionaryArray = [arrayOfDictionaries copy];
    self.sectionHeaders = [uniqueArtists copy];
}

@end
