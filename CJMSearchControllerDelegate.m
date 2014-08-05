//
//  CJMSearchControllerDelegate.m
//  CJM
//
//  Created by Michael Fellows on 7/31/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSearchControllerDelegate.h"
#import "CJMQueryStore.h"
#import "CJMAudioController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation CJMSearchControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *songs = [[CJMQueryStore sharedStore] currentResults];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    CJMAudioController *controller = [CJMAudioController sharedController];
    controller.currentItem = song;
    [controller playItem];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0; 
}



@end
