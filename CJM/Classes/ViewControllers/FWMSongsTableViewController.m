//
//  FWMSongsTableViewController.m
//  Music-Fun
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 broadwaylab. All rights reserved.
//

#import "FWMSongsTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FWMSongsTableViewController ()

@property (nonatomic, copy) NSArray *songs;
@property (nonatomic, copy) NSArray *tableData;

@end

@implementation FWMSongsTableViewController

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
    
    self.navigationItem.title = @"Songs";
    self.tableData = [self _partitionObjects:self.songs collationStringSelector:@selector(title)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tableData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SongCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    
    // MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    MPMediaItem *song = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSNumber *duration = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    int songDuration = [duration intValue];
    int minutes = songDuration / 60;
    int seconds = songDuration % 60;
    NSString *string = [NSString stringWithFormat:@"%@ - %d:%02d",
                        [song valueForProperty:MPMediaItemPropertyTitle], minutes, seconds];
    
    cell.textLabel.text = string;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    BOOL showSection = [[self.tableData objectAtIndex:section] count] != 0;
    return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

#pragma mark - Private

- (void)_initialize
{
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    _songs = [query items];
}

- (NSArray *)_partitionObjects:(NSArray *)objects collationStringSelector:(SEL)selector
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger sectionCount = [[collation sectionTitles] count];
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    // Create an array to hold data from each section
    for (int i = 0; i < sectionCount; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    // Put each object into a section
    for (id object in objects) {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    // Sort each section
    for (NSMutableArray *section in unsortedSections) {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    return sections;
}

@end
