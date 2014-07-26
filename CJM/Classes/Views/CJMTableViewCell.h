//
//  CJMTableViewCell.h
//  CJM
//
//  Created by Michael Fellows on 7/25/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJMTableViewCell : UITableViewCell

@property (nonatomic, weak) UILabel *songLabel;
@property (nonatomic, weak) UILabel *trackLengthLabel;
@property (nonatomic, assign, getter = isPlaying) BOOL playing;

@end
