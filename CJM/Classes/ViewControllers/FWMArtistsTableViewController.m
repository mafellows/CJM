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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItem *song = [self.artists objectAtIndex:indexPath.row];
    cell.textLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
    
    return cell;
}

#pragma mark - Private

- (void)_initialize
{
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query setGroupingType:MPMediaGroupingArtist];
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    _artists = [query items];
    
    for (MPMediaItem *item in _artists) {
        NSString *artist = [item valueForKey:MPMediaItemPropertyArtist];
        if (artist) [orderedSet addObject:artist];
    }
    NSArray *artists = [orderedSet array];
    for (NSString *artist in artists) {
        NSLog(@"%@", artist);
    }
}

@end
