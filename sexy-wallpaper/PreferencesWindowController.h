//
//  PreferencesWindowController.h
//  Walled
//
//  Created by Christopher Hayen on 12/10/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController <NSOutlineViewDataSource>

@property NSUserDefaults *userDefaults;
@property (weak) IBOutlet NSOutlineView *locationsView;

@end
