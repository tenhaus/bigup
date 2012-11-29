//
//  ImageBrowserControllerController.m
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/29/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "ImageBrowserControllerController.h"

/* Our datasource object */
@interface myImageObject : NSObject
{
    NSString *_path;
}
@end

@implementation myImageObject


/* our datasource object is just a filepath representation */
- (void)setPath:(NSString *)path
{
    if(_path != path)
    {
        _path = path;
    }
}


/* required methods of the IKImageBrowserItem protocol */
#pragma mark -
#pragma mark item data source protocol

/* let the image browser knows we use a path representation */
- (NSString *)imageRepresentationType
{
	return IKImageBrowserPathRepresentationType;
}

/* give our representation to the image browser */
- (id)imageRepresentation
{
	return _path;
}

/* use the absolute filepath as identifier */
- (NSString *)imageUID
{
    return _path;
}

@end


@interface ImageBrowserControllerController ()

@end

@implementation ImageBrowserControllerController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if (self)
    {
        self.mImages = [[NSMutableArray alloc] init];
        [self.imageBrowser setAnimates:YES];
        [self.imageBrowser setContentResizingMask:NSViewWidthSizable];
    }
    
    return self;
}

- (void)updateDatasource:(NSMutableArray *)images
{
    NSEnumerator *e = [images objectEnumerator];
    
    NSURL *url;
    
    while (url = [e nextObject])
    {
        [self addAnImageWithPath:[url path]];
    }
    
    [self.imageBrowser reloadData];

    /* update the zoom value to scale images */
    [self.imageBrowser setZoomValue:2.0];
    [self.imageBrowser setNeedsDisplay:YES];
}

- (void) addAnImageWithPath:(NSString *) path
{
    myImageObject *p;
    
    p = [[myImageObject alloc] init];
    [p setPath:path];
    [self.mImages addObject:p];
}

- (int) numberOfItemsInImageBrowser:(IKImageBrowserView *) view
{
    return (int)self.mImages.count;
}

- (id) imageBrowser:(IKImageBrowserView *) view itemAtIndex:(int) index
{
    return [self.mImages objectAtIndex:index];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end


