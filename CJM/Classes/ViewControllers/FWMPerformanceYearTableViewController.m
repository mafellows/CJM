//
//  FWMPerformanceYearTableViewController.m
//  Music-Fun
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 broadwaylab. All rights reserved.
//

#import "FWMPerformanceYearTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FWMPerformanceYearTableViewController ()

@property (nonatomic, copy) NSArray *sectionHeaders;
@property (nonatomic, copy) NSArray *dictionaryArray;

@end

@implementation FWMPerformanceYearTableViewController

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
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    NSMutableArray *allYears = [NSMutableArray array];
    for (MPMediaItem *item in songs) {
        NSNumber *year = [item valueForKey:@"year"];
        if (year) [allYears addObject:year];
    }
    
    NSArray *uniqueYears = [[NSSet setWithArray:allYears] allObjects];
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedUniqueYears = [uniqueYears sortedArrayUsingDescriptors:@[lowestToHighest]];
    
    NSLog(@"Sorted Years: %@", sortedUniqueYears);
    
    for (NSNumber *year in sortedUniqueYears) {
        NSMutableArray *songsForKey = [NSMutableArray array];
        for (MPMediaItem *song in songs) {
            if ([[song valueForProperty:@"year"] isEqualToNumber:year]) {
                [songsForKey addObject:song];
            }
        }
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:songsForKey
                                                               forKey:year];
        [arrayOfDictionaries addObject:dictionary];
    }
    
    
    
    self.dictionaryArray = [arrayOfDictionaries copy];
    self.sectionHeaders = [sortedUniqueYears copy];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSNumber *year = [self.sectionHeaders objectAtIndex:section];
    return [NSString stringWithFormat:@"%@", year];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionHeaders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:section];
    NSArray *songs = [dictionary objectForKey:[self.sectionHeaders objectAtIndex:section]];
    return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PerformanceYearCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
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
}

@end
