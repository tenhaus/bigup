//
//  HelpView.h
//  Walled
//
//  Created by Christopher Hayen on 1/11/13.
//  Copyright (c) 2013 Christopher Hayen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HelpView : NSView

@property (retain) NSTextField *locationLabel;
@property (retain) NSTextField *helpLabel;
@property (retain) NSTextField *exitLabel;
@property (retain) NSTextField *imageLabel;

@property (atomic) NSRect exitButtonLocation;
@property (atomic) NSRect helpButtonLocation;
@property (atomic) NSRect locationButtonLocation;
@property (atomic) NSRect imageViewLocation;

@end
