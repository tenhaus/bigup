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
    if(theEvent.scrollingDeltaX == 0)
    {
        NSLog(@"MINE %f", theEvent.scrollingDeltaY/100);
        
        CGWheelCount wheelCount = 2; // 1 for Y-only, 2 for Y-X, 3 for Y-X-Z
        int32_t xScroll = theEvent.scrollingDeltaY * -1; // Negative for right
        int32_t yScroll = 0; // Negative for down
        CGEventRef cgEvent = CGEventCreateScrollWheelEvent(NULL, kCGScrollEventUnitPixel, wheelCount,yScroll, xScroll);

        
        NSEvent *event = [NSEvent eventWithCGEvent:cgEvent];
        CFRelease(cgEvent);

        if(xScroll != 0)
        {
            [super scrollWheel:event];
        }
    }
    else
    {
        NSLog(@"REAL %f", theEvent.scrollingDeltaX);
        [super scrollWheel:theEvent];
    }
}

@end
