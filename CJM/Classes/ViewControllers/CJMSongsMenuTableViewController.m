//
//  CJMSongsMenuTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 9/8/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSongsMenuTableViewController.h"
#import "CJMSidePanelTableViewCell.h"
#import "CJMMenuTableViewController.h"
#import "JASidePanelController.h"
#import <MediaToolbox/MediaToolbox.h> 

static NSString * const CJMSongMenuCellIdentifier = @"SongMenuCellIdentifier";

@interface CJMSongsMenuTableViewController ()

@property (nonatomic, copy) NSArray *songLetters;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;

@end

@implementation CJMSongsMenuTableViewController

- (instancetype)initWithMenuController:(CJMMenuTableViewController *)menuController
{
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _menuController = menuController;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithMenuController:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songLetters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMSidePanelTableViewCell *cell = (CJMSidePanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CJMSongMenuCellIdentifier];
    if (!cell) {
        cell = [[CJMSidePanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CJMSongMenuCellIdentifier];
    }
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.menuController.yearSidePanelController showCenterPanelAnimated:YES];
//    NSNumber *year = [self.years objectAtIndex:indexPath.row];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedYear"
//                                                        object:@{ @"year" : year }];
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
