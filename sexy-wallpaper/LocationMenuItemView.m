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
    self.title = location;
    [self.locationLabel setTitleWithMnemonic:location];
}

-(void)setCanDelete:(BOOL)value
{
    [self.deleteButton setHidden:value];
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
    NSMenuItem *mi = [self enclosingMenuItem];
    [[mi target] performSelector:[mi action] withObject:self];
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

- (IBAction)deleteButtonSelected:(id)sender
{
    NSMenuItem *mi = [self enclosingMenuItem];
    [[mi target] performSelector:self.deleteAction withObject:self];
}

@end
