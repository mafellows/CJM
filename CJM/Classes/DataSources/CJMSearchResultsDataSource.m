//
//  CJMSearchResultsDataSource.m
//  CJM
//
//  Created by Michael Fellows on 7/31/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSearchResultsDataSource.h"
#import "CJMQueryStore.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CJMSearchResultsDataSource ()

@property (nonatomic, copy) NSArray *songs;

@end

@implementation CJMSearchResultsDataSource

- (id)init
{
    if ((self = [super init])) {
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        _songs = [query items];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resultsChanged:)
                                                     name:CJMQueryNotificationSearchChanged
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CJMQueryNotificationSearchChanged
                                                  object:nil];
}

#pragma mark - Selectors

- (void)resultsChanged:(NSNotification *)aNotification
{
    if ([aNotification.name isEqualToString:CJMQueryNotificationSearchChanged]) {
        self.songs = [aNotification object];
        [[CJMQueryStore sharedStore] setCurrentResults:self.songs]; 
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItem *item = [self.songs objectAtIndex:indexPath.row];
    cell.textLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [item valueForProperty:MPMediaItemPropertyAlbumArtist]; 
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songs.count;
}

@end
