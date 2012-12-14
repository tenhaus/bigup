//
//  ImageBrowserScrollView.m
//  Walled
//
//  Created by Christopher Hayen on 12/14/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "ImageBrowserScrollView.h"

@implementation ImageBrowserScrollView

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
    // Drawing code here.
}

-(void)scrollWheel:(NSEvent *)theEvent
{
    [super scrollWheel:theEvent];
}

@end
