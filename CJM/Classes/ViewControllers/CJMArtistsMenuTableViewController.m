//
//  CJMArtistsMenuTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 8/24/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMArtistsMenuTableViewController.h"
#import "CJMMenuTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CJMArtistsMenuTableViewController ()

@property (nonatomic, copy) NSArray *artists;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;

@end

@implementation CJMArtistsMenuTableViewController

- (instancetype)initWithMenu:(CJMMenuTableViewController *)menuController
{
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _menuController = menuController;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithMenu:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    NSArray *artists = [artistsQuery items];
    
    NSMutableArray *allArtists = [NSMutableArray array];
    for (MPMediaItem *item in artists) {
        NSString *song = [item valueForKey:MPMediaItemPropertyAlbumArtist];
        if (song) [allArtists addObject:song];
    }
    
    NSArray *uniqueArtists = [[NSSet setWithArray:allArtists] allObjects];
    NSMutableArray *sortedArtists = [NSMutableArray arrayWithArray:uniqueArtists];
    [sortedArtists sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.artists = [sortedArtists copy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.artists[indexPath.row]; 
    return cell;
}

@end
