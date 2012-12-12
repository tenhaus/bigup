//
//  WallpaperImageView.m
//  Walled
//
//  Created by Christopher Hayen on 12/12/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "WallpaperImageView.h"

@implementation WallpaperImageView

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
    NSScreen *screen = [NSScreen mainScreen];

    CGFloat wZoomRatio, hZoomRatio, zoomRatio = 0.0;
    
    NSRect screenFrame = [screen frame];

    NSArray *reps = [self.image representations];
    
    CGFloat imageWidth = 0.0;
    CGFloat imageHeight = 0.0;
    
    CGFloat newImageWidth = 0.0;
    CGFloat newImageHeight = 0.0;
    
    CGFloat hBoundAdjustment = 0.0;
    
    for (NSImageRep * imageRep in reps)
    {
        if ([imageRep pixelsWide] > imageWidth) imageWidth = [imageRep pixelsWide];
        if ([imageRep pixelsHigh] > imageHeight) imageHeight = [imageRep pixelsHigh];
    }
    
    wZoomRatio = screenFrame.size.width / imageWidth;
    hZoomRatio = screenFrame.size.height / imageHeight;
    
    zoomRatio = MAX(wZoomRatio, hZoomRatio);
    
    newImageHeight = imageHeight * zoomRatio;
    newImageWidth = imageWidth * zoomRatio;
    hBoundAdjustment = (newImageHeight - imageHeight) / 2;

    CGRect imageRect = NSMakeRect((screenFrame.size.width - newImageWidth)/2, (screenFrame.size.height - newImageHeight)/2, newImageWidth, newImageHeight);

    [self.image drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
}

@end
