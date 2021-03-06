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
#import "WallpaperImageView.h"
#import "CustomIkImageBrowserView.h"
#import "ShadowView.h"
#import "MenuItemViewController.h"
#import "LocationMenuItemView.h"
#import "HelpView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSWindowController *preferenceWindow;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
- (IBAction)deleteLocationSelected:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;

@property (weak) IBOutlet NSScrollView *wallpaperScrollView;
@property (weak) IBOutlet NSArrayController *tableArrayController;
@property (weak) IBOutlet CustomIkImageBrowserView *browserView;

@property (unsafe_unretained) IBOutlet ImageBrowserController *imageBrowserController;
@property (weak) IBOutlet NSView *menuBar;

@property (weak) IBOutlet WallpaperImageView *imageView;

@property (retain) NSMenu *locationsMenu;
@property (weak) IBOutlet NSTextField *locationTitle;
@property (weak) IBOutlet ShadowView *shadowView;
@property (weak) IBOutlet HelpView *helpView;


@property (weak) IBOutlet NSButton *exitButton;
@property (weak) IBOutlet NSButton *helpButton;
@property (weak) IBOutlet NSButton *locationsButton;
@property (weak) IBOutlet NSScrollView *browserScrollView;

@end
