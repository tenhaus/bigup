//
//  LocationMenuItemView.m
//  Walled
//
//  Created by Christopher Hayen on 1/3/13.
//  Copyright (c) 2013 Christopher Hayen. All rights reserved.
//

#import "LocationMenuItemView.h"

@implementation LocationMenuItemView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
//        self.cursor = [NSCursor pointingHandCursor];
//        [self addCursorRect:self.bounds cursor:self.cursor];
    }
    
    return self;
}

-(void)setLocation:(NSString *)location
{
    [self.locationLabel setTitleWithMnemonic:location];
    NSLog(@"%f", self.locationLabel.bounds.size.width);
}

- (void)viewDidMoveToWindow
{
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:NO];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    [self.deleteButton setHidden:NO];
    [self.cursor setOnMouseEntered:YES];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    [self.deleteButton setHidden:YES];
    [self.cursor setOnMouseExited:YES];
}

-(void)mouseDown:(NSEvent *)theEvent
{
//    [[self.enclosingMenuItem target] performSelector:[self.enclosingMenuItem action]];
//    [self performSelector:[self.enclosingMenuItem action]];
//    [self.enclosingMenuItem action];
}

-(void)drawRect:(NSRect)rect
{
    if ([[self enclosingMenuItem] isHighlighted])
    {
        [[NSColor selectedMenuItemColor] set];
        [self.locationLabel setTextColor:[NSColor selectedMenuItemTextColor]];
         NSRectFill(rect);
    }
    else
    {
        [self.locationLabel setTextColor:[NSColor textColor]];
        [super drawRect:rect];
    }
    

}

@end
