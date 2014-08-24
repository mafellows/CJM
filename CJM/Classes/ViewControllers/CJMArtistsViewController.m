//
//  CJMArtistsViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/30/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMArtistsViewController.h"
#import "CJMMenuTableViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "CJMAppDelegate.h"

@interface CJMArtistsViewController ()

@property (nonatomic, copy) NSArray *songs;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;

@end

@implementation CJMArtistsViewController

- (instancetype)initWithMenuController:(CJMMenuTableViewController *)menuController
{
    if ((self = [super init])) {
        _menuController = menuController;
    }
    return self;
}

- (id)init
{
    return [self initWithMenuController:nil];
}   

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableHeaderView.caretButton addTarget:self
                                         action:@selector(showMenu:)
                               forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(artistSelected:)
                                                 name:@"selectedArtist"
                                               object:nil];
    
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    NSArray *artists = [artistsQuery items];
    
    NSMutableArray *allArtists = [NSMutableArray array];
    for (MPMediaItem *item in artists) {
        NSString *song = [item valueForKey:MPMediaItemPropertyAlbumArtist];
        if (song) [allArtists addObject:song];
    }
    
    NSArray *uniqueArtists = [[NSSet setWithArray:allArtists] allObjects];
    NSMutableArray *sortedArtists = [NSMutableArray arrayWithArray:uniqueArtists];
    [sortedArtists sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *artist = [sortedArtists firstObject];
    if (artist) {
        [self _fetchArtistNamed:artist];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"selectedArtist"
                                                  object:nil];
}

#pragma mark - Selector

- (void)artistSelected:(NSNotification *)aNotification
{
    if ([aNotification.name isEqualToString:@"selectedArtist"]) {
        NSString *artist = [[aNotification object] objectForKey:@"artist"];
        [self _fetchArtistNamed:artist];
    }
}

- (void)showMenu:(id)sender
{
    [self.menuController.artistSidePanelController showLeftPanelAnimated:YES]; 
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        CJMTableViewCell *cell = (CJMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        }
    
        MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
        
        if (song == [[CJMAudioController sharedController] currentItem]) {
            cell.trackLengthLabel.hidden = YES;
            cell.speakerImageView.hidden = NO;
        } else {
            cell.trackLengthLabel.hidden = NO;
            cell.speakerImageView.hidden = YES;
        }
        cell.songLabel.text = [NSString stringWithFormat:@"%@", [song valueForProperty:MPMediaItemPropertyTitle]];
        cell.trackLengthLabel.text = [self timeRemainingForDuration:[song valueForProperty:MPMediaItemPropertyPlaybackDuration]];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    CJMAudioController *controller = [CJMAudioController sharedController];
    controller.currentItem = song;
    [controller setArrayOfSongs:self.songs withCurrentIndex:indexPath.row];
    [controller playItem];
    
    [self.trackPlayingView.songTitleLabel setText:[song valueForProperty:MPMediaItemPropertyTitle]];
    [self.trackPlayingView.artistLabel setText:[song valueForProperty:MPMediaItemPropertyArtist]];
    [self.tableView reloadData];
    
    [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal]; 
}

#pragma mark - Private

- (void)_fetchArtistNamed:(NSString *)artist
{
    self.tableHeaderView.titleLabel.text = [artist uppercaseString];
    MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate predicateWithValue:artist
                                                                                 forProperty:MPMediaItemPropertyAlbumArtist
                                                                              comparisonType:MPMediaPredicateComparisonEqualTo];
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    [songsQuery addFilterPredicate:artistPredicate];
    self.songs = [songsQuery items];
    [self.tableView reloadData];
}

@end
