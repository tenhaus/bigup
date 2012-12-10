//
//  PreferencesWindowController.m
//  Walled
//
//  Created by Christopher Hayen on 12/10/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self)
    {
        [[NSApp mainWindow] makeKeyAndOrderFront:self];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSArray *locations = [self.userDefaults arrayForKey:@"Locations"];
    return [locations count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSArray *locations = [self.userDefaults arrayForKey:@"Locations"];
    NSString *location = [locations objectAtIndex:index];
    return location;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    NSURL *url = [[NSURL alloc] initFileURLWithPath:item isDirectory:YES];
    NSArray *pathComponents = [url pathComponents];
    return [pathComponents objectAtIndex:[pathComponents count ]-1];
}

- (IBAction)addButtonClicked:(id)sender
{
    int i;
    
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"Locations"]];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];

    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    
    if ( [openPanel runModal] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* urls = [openPanel URLs];
        
        // Loop through all the files and process them.
        for( i = 0; i < [urls count]; i++ )
        {
            NSURL* url = [urls objectAtIndex:i];
            [locations addObject:[url path]];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:locations forKey:@"Locations"];
    [self.locationsView reloadData];
}

@end
