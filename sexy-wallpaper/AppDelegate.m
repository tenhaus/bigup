//
//  AppDelegate.m
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/21/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomWindow.h"
#import "WallpaperImageView.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Initialize

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserSelectedBackground:)
                                                 name:@"userSelectedBackground"
                                               object:nil];
    
    [self registerDefaultPreferences];
    [self.window setAlphaValue:0.0f];
    
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];

    [self.imageView addSubview:self.locationsPopUpButton];
    [self.imageView addSubview:self.browserScrollView];
    
    [self goFullScreen:screenFrame];
    [self configureBrowserView];
    [self updateLocationsMenu];
    
    [self loadImages];
    [self displayUserBackground:workspace screen:screen];
    
    CustomWindow *customWindow = (CustomWindow *)self.window;
    [customWindow fadeInAndMakeKeyAndOrderFront:YES];
}

- (void)configureBrowserView
{
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];
    
    int maxImageHeight = screenFrame.size.height / 6;
    
    NSRect scrollViewFrame;
    scrollViewFrame.size = CGSizeMake(screenFrame.size.width, maxImageHeight + 20);
    scrollViewFrame.origin = CGPointMake(0, screenFrame.size.height /6);
    
    [self.wallpaperScrollView setFrame:scrollViewFrame];
    [self.browserView setFrame:scrollViewFrame];
    
    [self.browserView setContentResizingMask:NSViewWidthSizable];
    [self.browserView setAnimates:YES];

//    [self.browserView setCellsStyleMask:IKCellsStyleOutlined | IKCellsStyleShadowed];

//    [self.browserView setValue:[NSColor colorWithSRGBRed:1 green:216 blue:216 alpha:216] forKey:IKImageBrowserCellsOutlineColorKey];
//    [self.browserView setValue:[NSColor clearColor] forKey:IKImageBrowserSelectionColorKey];
    [self.browserView setValue:[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.0] forKey:IKImageBrowserBackgroundColorKey];

    [self.browserView setCellSize:NSMakeSize(400, maxImageHeight)];

    NSRect buttonRect;
    buttonRect.origin = NSMakePoint(scrollViewFrame.origin.x + 20, scrollViewFrame.origin.y + maxImageHeight + 30);
    buttonRect.size = NSMakeSize(200, 25);
    [self.locationsPopUpButton setFrame:buttonRect];
}

-(void)updateLocationsMenu
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *locations = [defaults arrayForKey:@"Locations"];
    
    int i;
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Locations"];
    
    for(i = 0; i < [locations count]; i++)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[locations objectAtIndex:i] action:@selector(locationSelected) keyEquivalent:@""];
        [menu addItem:item];
    }
    
    [self.locationsPopUpButton setMenu:menu];
    [self.locationsPopUpButton selectItemWithTitle:[defaults stringForKey:@"CurrentLocation"]];
}

-(void)locationSelected
{
    NSString *newLocation = [[self.locationsPopUpButton selectedItem] title];
    [[NSUserDefaults standardUserDefaults] setValue:newLocation forKey:@"CurrentLocation"];
    [self loadImages];
}

-(void)registerDefaultPreferences
{
    NSString *url = @"/Library/Desktop Pictures";
    
    NSArray *wallDirectories = [[NSArray alloc] initWithObjects:url, nil];
    
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObjectsAndKeys:wallDirectories, @"Locations", url, @"CurrentLocation", nil];

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

#pragma mark - Set Background

-(void)handleUserSelectedBackground:(NSNotification *)notification
{
    NSScreen *curScreen = [NSScreen mainScreen];
    NSDictionary *screenOptions = [[NSWorkspace sharedWorkspace] desktopImageOptionsForScreen:curScreen];

    NSURL *imageUrl = [[notification userInfo] objectForKey:@"url"];
    
    NSError *error = nil;
    [[NSWorkspace sharedWorkspace] setDesktopImageURL:imageUrl
                                            forScreen:curScreen
                                              options:screenOptions
                                                error:&error];
    if (error)
    {
        [NSApp presentError:error];
    }
    else
    {
        [self displayImageAtURL:imageUrl onScreen:curScreen];
    }
}


- (NSRect)getImageFrame
{
    NSRect rect;
    
    rect.origin = CGPointMake(0.0, 0.0);
    rect.size = CGSizeMake(300.0, 275.00);
    
    return rect;
}

- (void)goFullScreen:(NSRect)screenFrame
{   
    [self.window setFrame:screenFrame display:YES];
}

- (void)displayImageAtURL:(NSURL *)url onScreen:(NSScreen *)screen
{
    NSImage *image = [[NSImage alloc] initByReferencingURL:url];
    [self.imageView setImage:image];
}

- (void)displayUserBackground:(NSWorkspace *)workspace screen:(NSScreen *)screen
{
    
    NSURL *currentBackgroundUrl = [workspace desktopImageURLForScreen:screen];
    [self displayImageAtURL:currentBackgroundUrl onScreen:screen];
}

#pragma mark - Change Directory

- (void)loadImages
{  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *currentLocation = [defaults URLForKey:@"CurrentLocation"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *contents = [fileManager enumeratorAtURL:currentLocation
                                        includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLContentModificationDateKey, NSURLIsDirectoryKey, nil]
                                                           options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSURL *theURL in contents)
    {
        NSNumber *isDirectory;

        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        if([isDirectory boolValue] == YES)
        {
        }
        else
        {
            [images addObject:theURL];
        }
    }
    
    [self.imageBrowserController updateDatasource:images];
}

#pragma mark - Misc.

- (IBAction)handlePreferencesSelected:(id)sender
{
    self.preferenceWindow = [[PreferencesWindowController alloc] initWithWindowNibName:@"Preferences"];
    
    [self.preferenceWindow showWindow:self];
}


#pragma mark - Stock app code


// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.tenhaus.sexy_wallpaper" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.tenhaus.sexy_wallpaper"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sexy_wallpaper" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"sexy_wallpaper.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
