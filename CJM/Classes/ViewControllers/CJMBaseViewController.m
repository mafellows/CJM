//
//  CJMBaseViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMBaseViewController.h"
#import "CJMTableViewCell.h"
#import "CJMTableHeaderView.h"
#import "CJMSearchHeaderView.h"
#import "UIERealTimeBlurView.h"
#import "CJMAudioController.h"
#import "CJMTrackPlayingView.h"
#import <MediaPlayer/MediaPlayer.h>

#define kCellIdentifier @"ArtistCellIdentifier"

@interface CJMBaseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *artists;
@property (nonatomic, copy) NSArray *dictionaryArray;
@property (nonatomic, copy) NSArray *sectionHeaders;
@property (nonatomic, weak) CJMTrackPlayingView *trackPlayingView;

@end

@implementation CJMBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)init
{
    if ((self = [super init])) {
        [self _initialize];
    }
    return self; 
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Artists";
    
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

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeaders objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionHeaders count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJMTableHeaderView *tableHeaderView = [[CJMTableHeaderView alloc] init];
    tableHeaderView.sectionTitleLabel.text = [self.sectionHeaders objectAtIndex:section];
    return tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:section];
    NSArray *songs = [dictionary objectForKey:[self.sectionHeaders objectAtIndex:section]];
    return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMTableViewCell *cell = (CJMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    NSString *key = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:key];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    NSNumber *duration = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    int songDuration = [duration intValue];
    int minutes = songDuration / 60;
    int seconds = songDuration % 60;
    cell.songLabel.text = [NSString stringWithFormat:@"%@", [song valueForProperty:MPMediaItemPropertyTitle]];
    cell.trackLengthLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *artist = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:artist];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    
    CJMAudioController *controller = [CJMAudioController sharedController];
    controller.currentItem = song;
    [controller playItem];
}

#pragma mark - Private

- (void)_initialize
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds]; 
    imageView.image = [UIImage imageNamed:@"detail-background"];
    [self.view addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    CGRect newFrame = tableView.frame;
    newFrame.size.height = [[UIScreen mainScreen] bounds].size.width - 150.0f;
    tableView.frame = newFrame;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CJMTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    _tableView = tableView;
    
    CJMSearchHeaderView *tableHeaderView = [[CJMSearchHeaderView alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 550.0f, 80.0f)];
    tableHeaderView.titleLabel.text = @"ARTISTS";
    tableView.tableHeaderView = tableHeaderView;
    
    CJMTrackPlayingView *trackPlayingView = [[CJMTrackPlayingView alloc] init];
    _trackPlayingView = trackPlayingView;
    [self.view addSubview:trackPlayingView];
    [self.view bringSubviewToFront:trackPlayingView];
}



@end
