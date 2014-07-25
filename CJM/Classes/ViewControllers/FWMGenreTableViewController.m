//
//  FWMGenreTableViewController.m
//  Music-Fun
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 broadwaylab. All rights reserved.
//

#import "FWMGenreTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>

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

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeaders objectAtIndex:section];
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
    static NSString *CellIdentifier = @"GenreCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    
    NSString *key = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *genres = [dictionary objectForKey:key];
    MPMediaItem *song = [genres objectAtIndex:indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@ - %@",
                        [song valueForProperty:MPMediaItemPropertyTitle],
                        [song valueForProperty:MPMediaItemPropertyPlaybackDuration]];
    
    cell.textLabel.text = string;
    
    return cell;
}

#pragma mark - Private

- (void)_initialize
{

}

@end
