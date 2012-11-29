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


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.window setAlphaValue:0.0f];
    
    [self.imageTable setIntercellSpacing:NSMakeSize(30.0, 0)];
    [self.imageTable setBackgroundColor:[NSColor clearColor]];
    [self.imageTable setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
    
    
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    
    [self goFullScreen:screenFrame];
    [self positionScrollView];
    [self loadImages:workspace screen:screen imageFrame:[self getImageFrame]];

    
    customWindow = (CustomWindow *)self.window;
    [customWindow fadeInAndMakeKeyAndOrderFront:YES];
    
    [self displayUserBackground:workspace screen:screen];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 1;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {

    NSURL *url = [self.dictionary objectForKey:[tableColumn identifier]];
    
    NSLog(@"Get image for %@", [url path]);
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
    NSImageView *imageView = [[NSImageView alloc] init];
    
    NSRect imageSize;
    imageSize.origin = CGPointMake(0.0, 0.0);
    imageSize.size = NSMakeSize(300.0, 275.0);
    
//    [image setSize:NSMakeSize(300.0, 275.0)];
    [imageView setFrame:imageSize];
    [imageView setImage:image];

    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor blackColor]];
    [shadow setShadowBlurRadius:4.0f];
    [shadow setShadowOffset:CGSizeMake(4.0f, 4.0f)];
    
    [imageView setShadow:shadow];
    

    return imageView;
    
    
//    // get an existing cell with the MyView identifier if it exists
//    NSTextField *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
//    
//    // There is no existing cell to reuse so we will create a new one
//    if (result == nil) {
//        
//        // create the new NSTextField with a frame of the {0,0} with the width of the table
//        // note that the height of the frame is not really relevant, the row-height will modify the height
//        // the new text field is then returned as an autoreleased object
//        result = [[[NSTextField alloc] initWithFrame:...] autorelease];
//        
//        // the identifier of the NSTextField instance is set to MyView. This
//        // allows it to be re-used
//        result.identifier = @"MyView";
//    }
//    
//    // result is now guaranteed to be valid, either as a re-used cell
//    // or as a new cell, so set the stringValue of the cell to the
//    // nameArray value at row
//    result.stringValue = [self.nameArray objectAtIndex:row];
//    
//    // return the result.
//    return result;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 275.0;
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

- (void)displayUserBackground:(NSWorkspace *)workspace screen:(NSScreen *)screen
{
    NSURL *currentBackgroundUrl = [workspace desktopImageURLForScreen:screen];    
    NSImage *background = [[NSImage alloc]initByReferencingURL:currentBackgroundUrl];
    
    [self.imageView setImage:background];
    [self.imageView setFrame:[screen frame]];
}

- (void)positionScrollView
{
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];
    
    NSRect scrollViewFrame;
    scrollViewFrame.size = CGSizeMake(screenFrame.size.width, screenFrame.size.height / 6);
    scrollViewFrame.origin = CGPointMake(0, screenFrame.size.height /6);
    
    [self.wallpaperScrollView setFrame:scrollViewFrame];
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
    
    self.dictionary = [[NSMutableDictionary alloc] init];
    
    for (NSURL *theURL in contents)
    {
        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        if([isDirectory boolValue] == YES)
        {
            
        }
        else
        {
            NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
            NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:identifier];
            [column setWidth:300.0];
            
            [self.dictionary setObject:theURL forKey:identifier];
            [self.imageTable addTableColumn:column];
            
        }
        
//        [self.tableArrayController addObjects:dictionary];
    }
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
