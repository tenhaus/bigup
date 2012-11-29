//
//  AppDelegate.h
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/21/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet CustomView *customView;
@property (weak) IBOutlet NSScrollView *wallpaperScrollView;
@property (weak) IBOutlet NSTableView *imageTable;
@property (weak) IBOutlet NSArrayController *tableArrayController;

@property NSMutableDictionary *dictionary;

@end
