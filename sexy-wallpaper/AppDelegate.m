//
//  AppDelegate.m
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/21/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomWindow.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

CustomWindow *customWindow;

//CGGradientRef myGradient;
//CGColorSpaceRef myColorspace;
//size_t num_locations = 2;
//CGFloat locations[2] = { 0.0, 1.0 };
//CGFloat components[8] = { 1.0, 0.5, 0.4, 1.0,  // Start color
//    0.8, 0.8, 0.3, 1.0 }; // End color


//CGContextRef myContext = [[NSGraphicsContext // 1
//                           currentContext] graphicsPort];
//
//CGPoint myStartPoint, myEndPoint;
//myStartPoint.x = 0.0;
//myStartPoint.y = 0.0;
//myEndPoint.x = 1000.0;
//myEndPoint.y = 1000.0;
//CGContextDrawLinearGradient(myContext, myGradient, myStartPoint, myEndPoint, 0);


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserSelectedBackground:)
                                                 name:@"userSelectedBackground"
                                               object:nil];

//    myColorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
//    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
//                                                      locations, num_locations);
    [self.window setAlphaValue:0.0f];

//    [self.browserView setIntercellSpacing:NSMakeSize(30.0, 0)];
    
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    
    [self goFullScreen:screenFrame];
    [self configureBrowserView];
    [self loadImages:workspace screen:screen imageFrame:[self getImageFrame]];
    
    [self.browserView setValue:[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.0] forKey:IKImageBrowserBackgroundColorKey];
    

    
    customWindow = (CustomWindow *)self.window;
    [customWindow fadeInAndMakeKeyAndOrderFront:YES];
    
    [self displayUserBackground:workspace screen:screen];
}

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
    CGFloat wZoomRatio, hZoomRatio, zoomRatio = 0.0;
    
    NSRect screenFrame = [screen frame];
    
    NSImage *tmpImage = [[NSImage alloc] initByReferencingURL:url];
    NSArray *reps = [tmpImage representations];

    CGFloat imageWidth = 0.0;
    CGFloat imageHeight = 0.0;

    CGFloat newImageWidth = 0.0;
    CGFloat newImageHeight = 0.0;
    
    CGFloat hBoundAdjustment = 0.0;
    
    for (NSImageRep * imageRep in reps)
    {
        if ([imageRep pixelsWide] > imageWidth) imageWidth = [imageRep pixelsWide];
        if ([imageRep pixelsHigh] > imageHeight) imageHeight = [imageRep pixelsHigh];
    }
    
    wZoomRatio = screenFrame.size.width / imageWidth;
    hZoomRatio = screenFrame.size.height / imageHeight;
    
    zoomRatio = MAX(wZoomRatio, hZoomRatio);
    
    newImageHeight = imageHeight * zoomRatio;
    newImageWidth = imageWidth * zoomRatio;
    hBoundAdjustment = (newImageHeight - imageHeight) / 2;

    [self.imageView setImageWithURL:url];
    [self.imageView setImageZoomFactor:zoomRatio centerPoint:NSMakePoint(0.0, 0.0)];
    [self.imageView setFrame:NSMakeRect((screenFrame.size.width - newImageWidth)/2, (screenFrame.size.height - newImageHeight)/2, newImageWidth, newImageHeight)];
}

- (void)displayUserBackground:(NSWorkspace *)workspace screen:(NSScreen *)screen
{
    NSURL *currentBackgroundUrl = [workspace desktopImageURLForScreen:screen];
    [self displayImageAtURL:currentBackgroundUrl onScreen:screen];
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
    [self.browserView setCellsStyleMask:IKCellsStyleShadowed];
    [self.browserView setCellSize:NSMakeSize( 400, maxImageHeight)];
}


- (void)loadImages:(NSWorkspace *)workspace screen:(NSScreen *)screen imageFrame:(NSRect)imageFrame
{
    NSURL *currentBackgroundUrl = [workspace desktopImageURLForScreen:screen];
    NSArray *pathParts = [currentBackgroundUrl pathComponents];

    NSMutableArray *directoryPathParts = [[NSMutableArray alloc] initWithArray:pathParts];
    [directoryPathParts removeObject:[directoryPathParts lastObject]];
    
    NSURL *directoryUrl = [[NSURL alloc] initFileURLWithPath:[directoryPathParts componentsJoinedByString:@"/"] isDirectory:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSDirectoryEnumerator *contents = [fileManager enumeratorAtURL:directoryUrl includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSURL *theURL in contents)
    {
        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
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
