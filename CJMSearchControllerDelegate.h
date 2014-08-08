//
//  CJMSearchControllerDelegate.h
//  CJM
//
//  Created by Michael Fellows on 7/31/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPMediaItem;

@protocol CJMSearchSelectedDelegate

- (void)selectedSongFromSearch:(MPMediaItem *)song;

@end

@interface CJMSearchControllerDelegate : NSObject <UITableViewDelegate>
@property (nonatomic, assign) id<CJMSearchSelectedDelegate> delegate; 
@end
