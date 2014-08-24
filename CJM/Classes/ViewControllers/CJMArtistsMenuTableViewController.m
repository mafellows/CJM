//
//  CJMArtistsMenuTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 8/24/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMArtistsMenuTableViewController.h"
#import "CJMMenuTableViewController.h"
#import "CJMSidePanelTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

static NSString * const CellIdentifier = @"MenuCellIdentifier";

@interface CJMArtistsMenuTableViewController ()

@property (nonatomic, copy) NSArray *artists;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;

@end

@implementation CJMArtistsMenuTableViewController

- (instancetype)initWithMenu:(CJMMenuTableViewController *)menuController
{
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _menuController = menuController;
        [self.tableView registerClass:[CJMSidePanelTableViewCell class] forCellReuseIdentifier:CellIdentifier];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 25.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *artist = self.artists[indexPath.row];
    return [self _heightForString:artist]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMSidePanelTableViewCell *cell = (CJMSidePanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CJMSidePanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.itemLabel.text = self.artists[indexPath.row];
    return cell;
}

#pragma mark - Private

- (CGFloat)_heightForString:(NSString *)string
{
    CGFloat labelWidth = 290.0f;
    CGSize labelConstraints = CGSizeMake(labelWidth, 9999.0f);
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGRect labelRect = [string boundingRectWithSize:labelConstraints
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName : [UIFont cellHeaderFont]}
                                            context:context];
    if (labelRect.size.height + 30 > 60) {
        return labelRect.size.height + 30;
    }
    return 60.0f;
}

@end
