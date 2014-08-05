//
//  CJMQueryStore.h
//  CJM
//
//  Created by Michael Fellows on 8/4/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CJMQueryNotificationSearchChanged @"searchChanged"

@interface CJMQueryStore : NSObject
@property (nonatomic, copy) NSArray *currentResults; 
+ (instancetype)sharedStore;
- (NSArray *)resultsForQuery:(NSString *)query;

@end
