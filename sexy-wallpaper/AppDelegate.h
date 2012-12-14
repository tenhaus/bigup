//
//  AppDelegate.h
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/21/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "ImageBrowserController.h"
#import "PreferencesWindowController.h"
#import "WallpaperImageView.h"
#import "CustomIkImageBrowserView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSWindowController *preferenceWindow;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@property (weak) IBOutlet NSScrollView *wallpaperScrollView;
@property (weak) IBOutlet NSArrayController *tableArrayController;
@property (weak) IBOutlet CustomIkImageBrowserView *browserView;
@property (weak) IBOutlet NSScrollView *browserScrollView;

@property (unsafe_unretained) IBOutlet ImageBrowserController *imageBrowserController;
@property (weak) IBOutlet NSPopUpButton *locationsPopUpButton;
@property (weak) IBOutlet WallpaperImageView *imageView;

@end
