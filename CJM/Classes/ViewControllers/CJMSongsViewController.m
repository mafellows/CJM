//
//  CJMSongsViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/30/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSongsViewController.h"

@interface CJMSongsViewController ()

@property (nonatomic, copy) NSArray *songs;
@property (nonatomic, copy) NSArray *tableData;

@end

@implementation CJMSongsViewController

- (id)init
{
    if ((self = [super init])) {
        self.tableHeaderView.titleLabel.text = @"SONGS";
        self.tableHeaderView.caretButton.hidden = YES;
        [self.tableHeaderView updateConstraints]; 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    self.songs = [query items];
    self.tableData = [self _partitionObjects:self.songs collationStringSelector:@selector(title)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tableData objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJMTableHeaderView *tableHeaderView = [[CJMTableHeaderView alloc] init];
    BOOL showSection = [[self.tableData objectAtIndex:section] count] != 0;
    NSString *header;
    if (showSection) {
        header = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    } else {
        header = nil;
    }
    tableHeaderView.sectionTitleLabel.text = [header stringByReplacingOccurrencesOfString:@" " withString:@""];
    return tableHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMTableViewCell *cell = (CJMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    // MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    MPMediaItem *song = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSNumber *duration = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    int songDuration = [duration intValue];
    int minutes = songDuration / 60;
    int seconds = songDuration % 60;
    NSNumber *year = [song valueForProperty:@"year"];
    NSString *yearString;
    if (year) {
        yearString = [NSString stringWithFormat:@"%@", year];
    } else {
        yearString = @"2004";
    }
    cell.songLabel.text = [NSString stringWithFormat:@"%@ (%@)", [song valueForProperty:MPMediaItemPropertyTitle], yearString];
    cell.trackLengthLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    
    if (song == [[CJMAudioController sharedController] currentItem]) {
        cell.trackLengthLabel.hidden = YES;
        cell.speakerImageView.hidden = NO;
    } else {
        cell.trackLengthLabel.hidden = NO;
        cell.speakerImageView.hidden = YES;
    }
    
    return cell;
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
    
    [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"pause"]
                                      forState:UIControlStateNormal];
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
