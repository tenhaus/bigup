//
//  CustomIkImageBrowserView.m
//  Walled
//
//  Created by Christopher Hayen on 12/13/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "CustomIkImageBrowserView.h"
#import "CustomImageBrowserCell.h"

@implementation CustomIkImageBrowserView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (IKImageBrowserCell *)newCellForRepresentedItem:(id)anItem
{
    CustomImageBrowserCell *cell = [[CustomImageBrowserCell alloc]init];
    return cell;
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(BOOL)becomeFirstResponder
{
    return YES;
}

-(void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"keydown");
}

@end
