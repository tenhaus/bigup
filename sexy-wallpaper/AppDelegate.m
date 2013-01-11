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
    [NSApp setPresentationOptions:NSApplicationPresentationHideDock | NSApplicationPresentationDisableProcessSwitching | NSApplicationPresentationDisableHideApplication |
     NSApplicationPresentationAutoHideMenuBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserSelectedBackground:)
                                                 name:@"userSelectedBackground"
                                               object:nil];
    
    [self registerDefaultPreferences];
    [self.window setAlphaValue:0.0f];
    
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];

    [self.shadowView setFrame:screenFrame];
    [self.helpView setFrame:screenFrame];
    
    [self.imageView addSubview:self.shadowView];
    [self.imageView addSubview:self.browserScrollView];
    [self.imageView addSubview:self.menuBar];
    [self.imageView addSubview:self.helpView];
    
    [self goFullScreen:screenFrame];
    [self configureBrowserView];
    [self updateLocationsMenu];
    
    [self loadImages];
    [self displayUserBackground:workspace screen:screen];
    
    self.imageView.browser = self.browserView;
    
    CustomWindow *customWindow = (CustomWindow *)self.window;
    [customWindow fadeInAndMakeKeyAndOrderFront:YES];
}

- (void)configureBrowserView
{
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];
    
    int maxImageHeight = screenFrame.size.height / 6;
    
    NSRect scrollViewFrame;
    scrollViewFrame.size = CGSizeMake(screenFrame.size.width, maxImageHeight + 100);
    scrollViewFrame.origin = CGPointMake(0, screenFrame.size.height /10);
    
    [self.wallpaperScrollView setFrame:scrollViewFrame];
    [self.browserView setFrame:scrollViewFrame];
    
    [self.browserView setContentResizingMask:NSViewWidthSizable];
    [self.browserView setAnimates:YES];

    [self.browserView setCellsStyleMask:IKCellsStyleOutlined | IKCellsStyleShadowed];

    [self.browserView setValue:[NSColor colorWithSRGBRed:1 green:216 blue:216 alpha:216] forKey:IKImageBrowserCellsOutlineColorKey];
    [self.browserView setValue:[NSColor clearColor] forKey:IKImageBrowserSelectionColorKey];
    [self.browserView setValue:[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.0] forKey:IKImageBrowserBackgroundColorKey];

    [self.browserView setIntercellSpacing:NSMakeSize(40.0, 0)];
    [self.browserView setCellSize:NSMakeSize(16*24, 9*24)];

    NSRect buttonRect;
    buttonRect.origin = NSMakePoint(scrollViewFrame.origin.x + 20, scrollViewFrame.origin.y + maxImageHeight + 30);
    buttonRect.size = NSMakeSize(200, 25);

    [self.browserScrollView setHasVerticalScroller:NO];
}

-(void)updateLocationsMenu
{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *locations = [defaults arrayForKey:@"Locations"];
    
    int i;
    self.locationsMenu = [[NSMenu alloc] initWithTitle:@"Locations"];
    [self.locationsMenu setAutoenablesItems:NO];
    
    
    NSMenuItem *addDirectoryItem = [[NSMenuItem alloc] initWithTitle:@"Add New Location" action:@selector(locationSelected:) keyEquivalent:@""];
    [addDirectoryItem setTag:666];
    
    [self.locationsMenu addItem:addDirectoryItem];
    [self.locationsMenu addItem:[NSMenuItem separatorItem]];
    
    NSImage *locationsIcon = [NSImage imageNamed:@"locations"];
    
    for(i = 0; i < [locations count]; i++)
    {
        NSMenuItem *item = [self createMenuItemForLocation:[locations objectAtIndex:i]];
        [item setImage:locationsIcon];

        NSString *currentLocation = [defaults stringForKey:@"CurrentLocation"];

        if([currentLocation isEqualToString:item.title])
        {
            [item setState:NSOnState];
            [self.locationTitle setTitleWithMnemonic:[self getTitleForLocation:item.title]];
        }
        
        [self.locationsMenu addItem:item];
    }
}

-(NSMenuItem *)createMenuItemForLocation:(NSString *)location
{
    MenuItemViewController *controller = [[MenuItemViewController alloc] initWithNibName:@"MenuItemViewController" bundle:nil];

    LocationMenuItemView *view = (LocationMenuItemView *)[controller view];
    [view setLocation:location];
    [view setDeleteAction:@selector(deleteLocationSelected:)];
    
    NSMenuItem *tmp = [[NSMenuItem alloc] initWithTitle:location action:@selector(locationSelected:) keyEquivalent:@""];
    [tmp setTarget:self];
    [tmp setView:view];
    
    return tmp;
}


-(NSString *)getTitleForLocation:(NSString *)location
{
    return location;
}

- (IBAction)locationButtonSelected:(id)sender
{   
    // 2. Construct fake event.
    
    int eventType = NSLeftMouseDown;
    
    NSEvent *fakeMouseEvent = [NSEvent mouseEventWithType:eventType
                                                 location:self.menuBar.frame.origin
                                            modifierFlags:0
                                                timestamp:0
                                             windowNumber:[self.window windowNumber]
                                                  context:nil
                                              eventNumber:0
                                               clickCount:0
                                                 pressure:0];
    // 3. Pop up menu
    [NSMenu popUpContextMenu:self.locationsMenu withEvent:fakeMouseEvent forView:[self.window contentView]];
}

-(IBAction)locationSelected:(id)sender
{
    NSMenuItem *selectedMenuItem = (NSMenuItem *)sender;
    
    if(selectedMenuItem.tag == 666)
    {
        [self addLocationClicked];
    }
    else
    {
        [self setLocation:[selectedMenuItem title]];
    }
    
    [self.locationsMenu cancelTracking];
}

-(void)setLocation:(NSString *)location
{
    [[NSUserDefaults standardUserDefaults] setValue:location forKey:@"CurrentLocation"];
    [self loadImages];
    
    int i;
    
    for(i=0; i<self.locationsMenu.numberOfItems; i++)
    {
        NSMenuItem *tmpItem = [self.locationsMenu itemAtIndex:i];
        [tmpItem setState:NSOffState];
    }
    
    [self.locationTitle setTitleWithMnemonic:[self getTitleForLocation:location]];
}

-(IBAction)deleteLocationSelected:(id)sender
{
    LocationMenuItemView *view = (LocationMenuItemView *)sender;
    [self deleteLocation:view.title];
}

-(void)deleteLocation:(NSString *)location
{
    [self.locationsMenu cancelTracking];
    
    int i;
    
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"Locations"]];
    
 
    for(i = 0; i < [locations count]; i++)
    {
        NSString *url = [locations objectAtIndex:i];
        
        if([url isEqualToString:location])
        {
            [locations removeObjectAtIndex:i];
        }
    }

    [[NSUserDefaults standardUserDefaults] setValue:locations forKey:@"Locations"];

    [self updateLocationsMenu];
    
    NSString *currentLocation = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLocation"];
    
    if([location isEqualToString:currentLocation])
    {
        [self setLocation:[locations objectAtIndex:0]];
    }
}


- (void)addLocationClicked
{   
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"Locations"]];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];

    if([openPanel runModal] == NSOKButton)
    {
        NSURL *selectedURL = [openPanel URL];
        [locations addObject:[selectedURL path]];
        
       [[NSUserDefaults standardUserDefaults] setValue:locations forKey:@"Locations"];
        [self updateLocationsMenu];
        
        [self setLocation:[selectedURL path]];
    }
}

-(void)registerDefaultPreferences
{
    NSString *url = @"/Library/Desktop Pictures";
    
    NSArray *wallDirectories = [[NSArray alloc] initWithObjects:url, nil];
    
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObjectsAndKeys:wallDirectories, @"Locations", url, @"CurrentLocation", nil];

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (IBAction)quitApplication:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
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
