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

@property (nonatomic, copy) NSArray *songs;

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
    
    self.navigationItem.title = @"Performance Year";
}

#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"PerformanceYearCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    
    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    cell.textLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
    // cell.detailTextLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
    
    NSString *yearString = @"Year Unavailable";
    NSNumber *year = [song valueForProperty:@"year"];
    if (year && [year isKindOfClass:[NSNumber class]]) {
        int y = [year intValue];
        if (y != 0) {
            yearString = [NSString stringWithFormat:@"Year: %i", y];
        }
    }
    cell.detailTextLabel.text = yearString; 
    return cell;
}

#pragma mark - Private

- (void)_initialize
{
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query setGroupingType:MPMediaGroupingAlbum];
    _songs = [query items];
}

@end
