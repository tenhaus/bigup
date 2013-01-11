//
//  HelpView.m
//  Walled
//
//  Created by Christopher Hayen on 1/11/13.
//  Copyright (c) 2013 Christopher Hayen. All rights reserved.
//

#import "HelpView.h"

@implementation HelpView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.locationLabel = [self createHelpLabelWithString:@"Add or change locations here"];
        [self addSubview:self.locationLabel];
        
        self.helpLabel = [self createHelpLabelWithString:@"Toggle this help screen here"];
        [self addSubview:self.helpLabel];
        
        self.exitLabel = [self createHelpLabelWithString:@"Exit here"];
        [self addSubview:self.exitLabel];
        
        self.imageLabel = [self createHelpLabelWithString:@"Scroll to browse and select background here"];
        [self addSubview:self.imageLabel];
    }
    
    return self;
}

-(NSTextField *)createHelpLabelWithString:(NSString *)title
{
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(100.0, 100.0, 2000.0, self.frame.size.height / 12)];
    [textField setStringValue:title];

    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    [textField setTextColor:[NSColor yellowColor]];
    [textField setFont:[NSFont systemFontOfSize:self.frame.size.height / 14]];
    
    return textField;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self.locationLabel setFrameOrigin:NSMakePoint(0.0, 0.0)];
}

@end
