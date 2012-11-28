//
//  CustomWindow.h
//  sexy-wallpaper
//
//  Created by Christopher Hayen on 11/27/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "CustomView.h"

@interface CustomWindow : NSWindow

@property (weak) IBOutlet CustomView *customView;

@end
