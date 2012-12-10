//
//  ImageBrowserControllerController.h
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/29/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface ImageBrowserController : NSWindowController

- (void)updateDatasource:(NSMutableArray *)images;

@property NSMutableArray *mImages;

@property (weak) IBOutlet IKImageBrowserView *imageBrowser;

@end