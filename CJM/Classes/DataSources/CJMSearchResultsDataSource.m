//
//  CJMSearchResultsDataSource.m
//  CJM
//
//  Created by Michael Fellows on 7/31/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSearchResultsDataSource.h"
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
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItem *item = [self.songs objectAtIndex:indexPath.row];
    cell.textLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
    NSLog(@"%@", [item valueForProperty:MPMediaItemPropertyTitle]); 
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
