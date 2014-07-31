 //
//  CJMBaseViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMBaseViewController.h"

@interface CJMBaseViewController() <UISearchDisplayDelegate>

@end

@implementation CJMBaseViewController

- (id)init
{
    if ((self = [super init])) {
        [self _initialize];
    }
    return self; 
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

#pragma mark - Helper Methods

- (NSString *)timeRemainingForDuration:(NSNumber *)duration
{
    int songDuration = [duration intValue];
    int minutes = songDuration / 60;
    int seconds = songDuration % 60;
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    
}

#pragma mark - Private

- (void)_initialize
{
    self.view.backgroundColor = [UIColor whiteColor]; 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds]; 
    imageView.image = [UIImage imageNamed:@"detail-background"];
    [self.view addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    CGRect newFrame = tableView.frame;
    newFrame.size.height = [[UIScreen mainScreen] bounds].size.width - 150.0f;
    tableView.frame = newFrame;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CJMTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    _tableView = tableView;
    
    CJMSearchHeaderView *tableHeaderView = [[CJMSearchHeaderView alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 550.0f, 80.0f)];
    tableView.tableHeaderView = tableHeaderView;
    _tableHeaderView = tableHeaderView;
    
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:_tableHeaderView.searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    
    _trackPlayingView = [[CJMTrackPlayingView alloc] init];
    if (![_trackPlayingView isDescendantOfView:self.view]) {
        [self.view addSubview:_trackPlayingView];
    } else {
        [_trackPlayingView removeFromSuperview];
    }
}



@end
