//
//  CJMDetailTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMDetailTableViewController.h"

typedef NS_ENUM(NSInteger, RowTitle) {
    RowSongs,
    RowArtists,
    RowGenre,
    RowYear,
    RowCount
};

@interface CJMDetailTableViewController ()

@end

@implementation CJMDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden
{
    return YES; 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor]; 
    
    cell.textLabel.text = [self _titleForIndexPath:indexPath];
    return cell;
}

#pragma mark - Private

- (void)_initialize
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"detail-background"];
    self.tableView.backgroundView = imageView;
}

- (NSString *)_titleForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case RowSongs:
            return NSLocalizedString(@"Songs", nil);
            break;
            
        case RowArtists:
            return NSLocalizedString(@"Artists", nil);
            break;
            
        case RowGenre:
            return NSLocalizedString(@"Genres", nil);
            break;
            
        case RowYear:
            return NSLocalizedString(@"Performance Year", nil);
            break;
            
        default:
            return nil;
            break;
    }
}

@end
