//
//  ImageTable.m
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/28/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "ImageTable.h"

@implementation ImageTable

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (void)awakeFromNib {
    
    [[self enclosingScrollView] setDrawsBackground: NO];
}

- (BOOL)isOpaque {
    
    return NO;
}

- (void)drawBackgroundInClipRect:(NSRect)clipRect {
    
    // don't draw a background rect
}

@end
