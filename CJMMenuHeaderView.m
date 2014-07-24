//
//  CJMMenuHeaderView.m
//  CJM
//
//  Created by Michael Fellows on 7/23/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMMenuHeaderView.h"

@implementation CJMMenuHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
    imageView.center = self.center;
    imageView.image = [UIImage imageNamed:@"logo"];
    imageView.backgroundColor = [UIColor clearColor]; 
    [self addSubview:imageView];
    
    self.backgroundColor = [UIColor clearColor];
}

@end
