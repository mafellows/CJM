//
//  CJMGenreMenuTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 8/19/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMGenreMenuTableViewController.h"
#import "CJMMenuTableViewController.h"
#import "CJMSidePanelTableViewCell.h"
#import "JASidePanelController.h"
#import <MediaPlayer/MediaPlayer.h>

static NSString * const CellIdentifier = @"CellIdentifier";

@interface CJMGenreMenuTableViewController ()

@property (nonatomic, copy) NSArray *genres;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;

@end

@implementation CJMGenreMenuTableViewController

- (instancetype)initWithMenuController:(CJMMenuTableViewController *)menuController
{
    if ((self = [super init])) {
        _menuController = menuController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[CJMSidePanelTableViewCell class]
           forCellReuseIdentifier:CellIdentifier];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, 400.0f, 25.0f);
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MPMediaQuery *genresQuery = [MPMediaQuery genresQuery];
    NSArray *genres = [genresQuery items];
    
    NSMutableArray *allGenres = [NSMutableArray array];
    for (MPMediaItem *item in genres) {
        NSString *genre = [item valueForKey:MPMediaItemPropertyGenre];
        if (genre) [allGenres addObject:genre];
    }
    
    self.genres = [[NSSet setWithArray:allGenres] allObjects];    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.genres.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMSidePanelTableViewCell *cell = (CJMSidePanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CJMSidePanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.itemLabel.text = [[self.genres objectAtIndex:indexPath.row] uppercaseString];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuController.genreSidePanelController showCenterPanelAnimated:YES];
    NSString *genre = [self.genres objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedGenre"
                                                        object:@{ @"genre" : genre }];
}

@end
