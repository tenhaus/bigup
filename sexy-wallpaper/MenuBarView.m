//
//  MenuBarView.m
//  Walled
//
//  Created by Christopher Hayen on 12/15/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "MenuBarView.h"

@implementation MenuBarView

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    NSRect gradientBounds = NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height);
    NSGradient* aGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:1.0] endingColor:[NSColor clearColor]];
    [aGradient drawInRect:gradientBounds angle:270.0];
    
//    [[NSColor colorWithSRGBRed:0.0 green:0.0 blue:0.0 alpha:0.5] set];
//    NSRectFill(self.bounds);
}

@end