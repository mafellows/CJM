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
    return [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:17.0f];
}

+ (UIFont *)menuHeaderFont
{
    return [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:18.0f];
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
    return [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:30.0f];
}

+ (UIFont *)nowPlayingArtistFont
{
    return [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:18.0f];
}

+ (UIFont *)nowPlayingTitleFont
{
    return [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:18.0f];
}

+ (UIFont *)cellFont
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
}

+ (UIFont *)cellHeaderFont
{
    return [UIFont fontWithName:@"IowanOldStyle-Bold" size:20.0f];
}

@end
