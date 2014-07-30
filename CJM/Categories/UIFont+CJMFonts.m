//
//  UIFont+CJMFonts.m
//  CJM
//
//  Created by Michael Fellows on 7/25/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "UIFont+CJMFonts.h"

@implementation UIFont (CJMFonts)

+ (UIFont *)menuFont
{
    return [UIFont fontWithName:@"" size:20.0f];
}

+ (UIFont *)tableViewFont
{
    return [UIFont fontWithName:@"Avenir-Medium" size:18.0f];
}

+ (UIFont *)tableViewHeaderFont
{
    return [UIFont fontWithName:@"Avenir-Black" size:20.0f];
}

+ (UIFont *)titleFont
{
    return [UIFont fontWithName:@"Avenir-Medium" size:36.0f];
}

@end
