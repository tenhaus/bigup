//
//  CustomWindow.m
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/27/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "CustomWindow.h"

@implementation CustomWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{    
    // Using NSBorderlessWindowMask results in a window without a title bar.
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    
    if (self != nil)
    {
        // Start with no transparency for all drawing into the window
        [self setAlphaValue:1.0];
        
        // Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
    }
 
    return self;
}

@end
