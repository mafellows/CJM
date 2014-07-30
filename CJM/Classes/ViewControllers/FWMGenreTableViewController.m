//
//  FWMGenreTableViewController.m
//  Music-Fun
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 broadwaylab. All rights reserved.
//

#import "FWMGenreTableViewController.h"
#import "CJMTableViewCell.h"
#import "CJMTableHeaderView.h"
#import "CJMSearchHeaderView.h"
#import <MediaPlayer/MediaPlayer.h>

#define KCellIdentifier @"GenreCellIdentifier"

@interface FWMGenreTableViewController ()
@property (nonatomic, copy) NSArray *dictionaryArray;
@property (nonatomic, copy) NSArray *sectionHeaders;
@end

@implementation FWMGenreTableViewController

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
    
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    MPMediaQuery *genresQuery = [MPMediaQuery genresQuery];
    NSArray *genres = [genresQuery items];
    
    NSMutableArray *allGenres = [NSMutableArray array];
    for (MPMediaItem *item in genres) {
        NSString *genre = [item valueForKey:MPMediaItemPropertyGenre];
        if (genre) [allGenres addObject:genre];
    }
    
    NSArray *uniqueGenres = [[NSSet setWithArray:allGenres] allObjects];
    NSLog(@"Unique Artists: %@", uniqueGenres);
    
    for (NSString *genre in uniqueGenres) {
        MPMediaPropertyPredicate *genrePredicate = [MPMediaPropertyPredicate predicateWithValue:genre
                                                                                    forProperty:MPMediaItemPropertyGenre
                                                                                 comparisonType:MPMediaPredicateComparisonEqualTo];
        
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        [songsQuery addFilterPredicate:genrePredicate];
        NSArray *songsArray = [songsQuery items];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:songsArray forKey:genre];
        [arrayOfDictionaries addObject:dictionary];
    }
    
    self.dictionaryArray = [arrayOfDictionaries copy];
    self.sectionHeaders = [uniqueGenres copy];
}

- (BOOL)prefersStatusBarHidden
{
    return YES; 
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJMTableHeaderView *headerView = [[CJMTableHeaderView alloc] init];
    headerView.sectionTitleLabel.text = [self.sectionHeaders objectAtIndex:section];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionHeaders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:section];
    NSArray *genres = [dictionary objectForKey:[self.sectionHeaders objectAtIndex:section]];
    return genres.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMTableViewCell *cell = (CJMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:KCellIdentifier];
    if (!cell) {
        cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KCellIdentifier];
    }
    
    NSString *key = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *genres = [dictionary objectForKey:key];
    MPMediaItem *song = [genres objectAtIndex:indexPath.row];
    NSNumber *duration = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    int songDuration = [duration intValue];
    int minutes = songDuration / 60;
    int seconds = songDuration % 60;
    cell.songLabel.text = [NSString stringWithFormat:@"%@", [song valueForProperty:MPMediaItemPropertyTitle]];
    cell.trackLengthLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    
    return cell;
}

#pragma mark - Private

- (void)_initialize
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"detail-background"];
    self.tableView.backgroundView = imageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CJMTableViewCell class] forCellReuseIdentifier:KCellIdentifier];
    
    CJMSearchHeaderView *tableHeaderView = [[CJMSearchHeaderView alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 550.0f, 80.0f)];
    tableHeaderView.titleLabel.text = @"GENRE";
    self.tableView.tableHeaderView = tableHeaderView;
}

@end
