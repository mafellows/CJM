//
//  CJMPerformanceYearViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/30/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMPerformanceYearViewController.h"

@interface CJMPerformanceYearViewController ()

@property (nonatomic, copy) NSArray *sectionHeaders;
@property (nonatomic, copy) NSArray *dictionaryArray;

@end

@implementation CJMPerformanceYearViewController

- (id)init
{
    if ((self = [super init])) {
        self.tableHeaderView.titleLabel.text = @"PERFORMANCE YEARS";
    }
    return self; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _fetchPerformanceYears];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJMTableHeaderView *headerView = [[CJMTableHeaderView alloc] init];
    NSNumber *year = [self.sectionHeaders objectAtIndex:section];
    headerView.sectionTitleLabel.text = [NSString stringWithFormat:@"%@", year];
    return headerView;
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
    CJMTableViewCell *cell = (CJMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
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
    
    return cell;
}

#pragma mark - Private

- (void)_fetchPerformanceYears
{
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

@end
