//
//  ShadowView.m
//  Walled
//
//  Created by Christopher Hayen on 12/21/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

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
    NSRect screenFrame = [screen frame];
    
//    NSMutableArray *colors = [[NSMutableArray alloc] init];
//    
//    [colors addObject:[NSColor color]]
    
//    NSGradient* borderGradient = [[NSGradient alloc] initWithColorsAndLocations:[NSColor blackColor], 0.0, [NSColor colorWithSRGBRed:0.0 green:0.0 blue:0.0 alpha:0.8], 0.5, [NSColor clearColor], 0.8, nil];
//
    NSGradient *borderGradient = [[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.6], 0.0, [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.1], 0.6, [NSColor clearColor], 1.0, nil];

    NSRect topGradientBounds = NSMakeRect(0, screenFrame.size.height, screenFrame.size.width, (screenFrame.size.height/12)*-1);
    [borderGradient drawInRect:topGradientBounds angle:90];
    
    
    //    NSRect gradientBounds = NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height);
    //    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:[NSColor clearColor] endingColor:[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:1]];
    
    //    [gradient drawInRect:gradientBounds relativeCenterPosition:NSMakePoint(0, 0)];
    //
    //    NSRect topGradientBounds = NSMakeRect(0, self.bounds.size.height, self.bounds.size.width, (self.bounds.size.height/8)*-1);
    //    NSGradient* topGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:0.7] endingColor:[NSColor clearColor]];
    //    [topGradient drawInRect:topGradientBounds angle:90];
    //
    //    NSRect bottomGradientBounds = NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height/2.5);
    //    NSGradient* bottomGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:.5] endingColor:[NSColor clearColor]];
    //	[bottomGradient drawInRect:bottomGradientBounds angle:90.0];
    
    //    NSBezierPath *ellipse = [NSBezierPath bezierPathWithRoundedRect:screenFrame xRadius:400 yRadius:400];
    
    
    
//    NSAffineTransform *transform = [NSAffineTransform transform];
//    [transform scaleXBy:screenFrame.size.width yBy:screenFrame.size.height];
//    [transform concat];
//    
//    NSBezierPath *leftShadow = [NSBezierPath bezierPath];
//    [leftShadow appendBezierPathWithRect:NSMakeRect(0.0, 0.0, 0.1, 1)];
//    [borderGradient drawInBezierPath:leftShadow angle:0];
//    
//    NSBezierPath *rightShadow = [NSBezierPath bezierPath];
//    [rightShadow appendBezierPathWithRect:NSMakeRect(0.9, 0.0, 0.1, 1)];
//    [borderGradient drawInBezierPath:rightShadow angle:180];
//    
//    
//    NSBezierPath *topShadow = [NSBezierPath bezierPath];
//    
//    [topShadow moveToPoint:NSMakePoint(0.0, 1.0)];
//    [topShadow lineToPoint:NSMakePoint(0.0, 0.8)];
//    
//    [topShadow curveToPoint:NSMakePoint(0.5, 0.7) controlPoint1:NSMakePoint(0.2, 1.0) controlPoint2:NSMakePoint(0.4, 1.0)];
//    [topShadow curveToPoint:NSMakePoint(1.0, 0.8) controlPoint1:NSMakePoint(0.6, 1.0) controlPoint2:NSMakePoint(0.8, 1.0)];
//    
//    [topShadow lineToPoint:NSMakePoint(1.0, 1.0)];
//    [borderGradient drawInBezierPath:topShadow angle:-90];
    
    
}

@end
