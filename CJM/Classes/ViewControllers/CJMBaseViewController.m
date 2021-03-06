 //
//  CJMBaseViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMBaseViewController.h"
#import "CJMMenuTableViewController.h"
#import "CJMSearchResultsDataSource.h"
#import "CJMSearchControllerDelegate.h"
#import "JTSImageViewController.h"
#import "CJMQueryStore.h"
#import "CJMAppDelegate.h"

NSString * const CJMButtonPressedKey = @"imageButtonPressed";

@interface CJMBaseViewController() <UISearchDisplayDelegate, UISearchBarDelegate, UIPopoverControllerDelegate, CJMSearchSelectedDelegate> {
    NSTimer *_timer;
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self populateTrackView];
    
    AVAudioPlayer *sharedPlayer = [[CJMAudioController sharedController] audioPlayer];
    if (sharedPlayer.isPlaying) {
        [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"pause"]
                                          forState:UIControlStateNormal];
    } else {
        [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"play"]
                                          forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self _registerForNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self _unregisterForNotifications];
}

#pragma mark - CJMSearchSelectedDelegate

- (void)selectedSongFromSearch:(MPMediaItem *)song
{
    [[CJMAudioController sharedController] setCurrentItem:song];
    [self populateTrackView];
    
    [self.tableHeaderView.searchBar resignFirstResponder];
    [self.searchPopoverController dismissPopoverAnimated:YES];
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UITableViewController *popoverTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.dataSource = [[CJMSearchResultsDataSource alloc] init];
    self.dataSource.tableView = popoverTableViewController.tableView;
    self.delegate = [[CJMSearchControllerDelegate alloc] init];
    self.delegate.delegate = self;
    popoverTableViewController.tableView.delegate = self.delegate;
    popoverTableViewController.tableView.dataSource = self.dataSource;
    _popoverTableViewcontroller = popoverTableViewController;
    self.searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverTableViewController];
    self.searchPopoverController.delegate = self;
    self.searchPopoverController.passthroughViews = @[ self.tableHeaderView.searchBar ];
    
    [self.searchPopoverController presentPopoverFromRect:self.tableHeaderView.searchBar.bounds
                                                  inView:self.tableHeaderView.searchBar
                                permittedArrowDirections:UIPopoverArrowDirectionAny
                                                animated:YES];
    
    if (![searchBar.text isEqualToString:@""]) {
        NSArray *results = [[CJMQueryStore sharedStore] resultsForQuery:searchBar.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:CJMQueryNotificationSearchChanged
                                                            object:results];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSArray *results = [[CJMQueryStore sharedStore] resultsForQuery:searchText];
    [[NSNotificationCenter defaultCenter] postNotificationName:CJMQueryNotificationSearchChanged
                                                        object:results];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.searchPopoverController = nil;
    [self.tableHeaderView.searchBar resignFirstResponder]; 
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Selector

- (void)scrollToTop:(UITapGestureRecognizer *)aRecognizer
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    if (indexPath) {
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

- (void)imageButtonPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:CJMButtonPressedKey];
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.trackPlayingView.trackImageView.image; 
    imageInfo.referenceRect = self.trackPlayingView.trackImageView.bounds;
    imageInfo.referenceView = self.trackPlayingView;
    JTSImageViewController *imageViewController = [[JTSImageViewController alloc] initWithImageInfo:imageInfo
                                                                                               mode:JTSImageViewControllerMode_Image
                                                                                    backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    [imageViewController showFromViewController:self.splitViewController transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (void)updateTimeSlider:(id)sender
{
    AVAudioPlayer *player = [[CJMAudioController sharedController] audioPlayer];
    NSTimeInterval remaining = player.duration - player.currentTime;
    double minutes = floor(remaining / 60);
    double seconds = floor(remaining - minutes * 60);
    NSString *timeString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutes, seconds];
    self.trackPlayingView.secondsRemainingLabel.text = timeString;
    
    
    CGFloat percentage = player.currentTime / player.duration;
    self.trackPlayingView.timeSlider.value = percentage;
}

- (void)playPressed:(NSNotification *)aNotification
{
    if ([[aNotification name] isEqualToString:Play_Pressed_Notification]) {
        AVAudioPlayer *controller = [[CJMAudioController sharedController] audioPlayer];
        if ([controller isPlaying]) {
            [controller pause];
            [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"play"]
                                              forState:UIControlStateNormal];
        } else {
            [controller play];
            [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"pause"]
                                              forState:UIControlStateNormal];
        }
    }
}

- (void)nextPressed:(NSNotification *)aNotification
{
    if ([[aNotification name] isEqualToString:Next_Pressed_Notification]) {
        [[CJMAudioController sharedController] nextItem];
        [self populateTrackView];
        [self.tableView reloadData];
    }
}

- (void)backPressed:(NSNotification *)aNotification
{
    if ([[aNotification name] isEqualToString:Back_Pressed_Notification]) {
        [[CJMAudioController sharedController] previousItem];
        [self populateTrackView];
        [self.tableView reloadData];    
    }
}

#pragma mark - Helper Methods

- (NSString *)timeRemainingForDuration:(NSNumber *)duration
{
    int songDuration = [duration intValue];
    int minutes = songDuration / 60;
    int seconds = songDuration % 60;
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

- (void)populateTrackView
{
    MPMediaItem *song = [[CJMAudioController sharedController] currentItem];
    if (song) {
        NSString *artist = [song valueForProperty:MPMediaItemPropertyAlbumArtist];
        if (!artist) {
            artist = [song valueForProperty:MPMediaItemPropertyArtist];
        }
        self.trackPlayingView.artistLabel.text = artist; 
        self.trackPlayingView.songTitleLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
        NSNumber *year = [song valueForProperty:@"year"];
        NSString *imageFileString = [NSString stringWithFormat:@"%@.png", year];
        UIImage *image = [UIImage imageNamed:imageFileString];
        if (!image) {
            image = [UIImage imageNamed:@"HELLMAN_icon_01"]; 
        }
        self.trackPlayingView.trackImageView.image = image;
    }
    self.trackPlayingView.volumeSlider.value = [[CJMAudioController sharedController] currentVolume];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeSlider:) userInfo:nil repeats:YES];
    [_timer fire];
    
    [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal]; 
}

#pragma mark - Private

- (void)_initialize
{
    self.view.backgroundColor = [UIColor whiteColor]; 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds]; 
    imageView.image = [UIImage imageNamed:@"detail-background"];
    [self.view addSubview:imageView];
    
    
    CGRect tableViewFrame;
    
    // Tableview hack for iOS7 and earlier
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f) {
        tableViewFrame = CGRectMake(CGRectGetMinX(self.view.frame), 80.0f, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) - 230.0f);
    } else {
        tableViewFrame = CGRectMake(CGRectGetMinX(self.view.frame), 80.0f, CGRectGetWidth(self.view.frame),
                                    CGRectGetHeight(self.view.frame) - 230.0f);
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CJMTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    _tableView = tableView;
    
    CGRect tableHeaderViewFrame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f) {
        tableHeaderViewFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 80.0f);
    } else {
        tableHeaderViewFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame) - 254.0f, 80.0f);
    }
    
    CJMSearchHeaderView *tableHeaderView = [[CJMSearchHeaderView alloc] initWithFrame:tableHeaderViewFrame];
    tableHeaderView.searchBar.delegate = self;
    [tableHeaderView.scrollToTopTapRecognizer addTarget:self
                                                 action:@selector(scrollToTop:)];
    [self.view addSubview:tableHeaderView];
    _tableHeaderView = tableHeaderView;
    
    CGFloat height = 150.0f;
    CGRect frame;
    
    // Frame hack
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f) {
        frame = CGRectMake(40.0f,
                           [[UIScreen mainScreen] bounds].size.width - height,
                           610.0f,
                           height);
    } else {
        frame = CGRectMake(40.0f,
                           [[UIScreen mainScreen] bounds].size.height - height,
                           610.0f,
                           height);
    }

    CJMTrackPlayingView *trackPlayingView = [[CJMTrackPlayingView alloc] initWithFrame:frame];
    [trackPlayingView.imagePressedButton addTarget:self
                                            action:@selector(imageButtonPressed:)
                                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trackPlayingView];
    _trackPlayingView = trackPlayingView;
    
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:_tableHeaderView.searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDelegate = self;
    searchController.searchResultsDataSource = self;
    _searchController = searchController;
}

- (void)_registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backPressed:)
                                                 name:Back_Pressed_Notification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playPressed:)
                                                 name:Play_Pressed_Notification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nextPressed:)
                                                 name:Next_Pressed_Notification
                                               object:nil];
}

- (void)_unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:Back_Pressed_Notification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:Play_Pressed_Notification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:Next_Pressed_Notification
                                                  object:nil];
}

@end
