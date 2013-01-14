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
        [self.locationLabel setAlignment:NSLeftTextAlignment];
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
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(100.0, 100.0, 400.0, self.frame.size.height / 12)];
    [textField setStringValue:title];

    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    [textField setTextColor:[NSColor yellowColor]];
    [textField setFont:[NSFont systemFontOfSize:self.frame.size.height / 14]];
    [textField setAlignment:NSRightTextAlignment];
    [textField sizeToFit];
    
    return textField;
}


- (void)drawRect:(NSRect)dirtyRect
{
    
    // Position Labels
    NSPoint exitLabelLocation;
    exitLabelLocation.x = self.exitButtonLocation.origin.x - self.frame.size.width / 6 - self.exitLabel.frame.size.width;
    exitLabelLocation.y = self.exitButtonLocation.origin.y - self.frame.size.height / 3.5;

    [self.exitLabel setFrameOrigin:exitLabelLocation];
    
    NSPoint helpLabelLocation;
    helpLabelLocation.x = self.helpButtonLocation.origin.x - self.frame.size.width / 6 - self.helpLabel.frame.size.width;;
    helpLabelLocation.y = self.helpButtonLocation.origin.y - self.frame.size.height / 5;

    [self.helpLabel setFrameOrigin:helpLabelLocation];
    
    NSPoint locationLabelLocation;
    locationLabelLocation.x = self.locationButtonLocation.origin.x + self.frame.size.width / 6;
    locationLabelLocation.y = self.locationButtonLocation.origin.y - self.frame.size.height / 10;
    
    [self.locationLabel setFrameOrigin:locationLabelLocation];
    
    NSPoint imageLabelLocation;
    imageLabelLocation.x = (self.frame.size.width / 2) - (self.imageLabel.frame.size.width / 2);
    imageLabelLocation.y = self.imageViewLocation.origin.y + self.imageViewLocation.size.height + self.frame.size.height / 6;
    
    [self.imageLabel setFrameOrigin:imageLabelLocation];
    
    // Draw lines
    NSPoint labelBeginPoint;
    NSPoint labelEndPoint;
    
    labelBeginPoint = [self lineBeginPointForLabel:self.imageLabel];
    labelEndPoint = [self lineEndPointForLabel:self.imageLabel];
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:labelBeginPoint];
    [path lineToPoint:NSMakePoint(self.frame.size.width / 10, imageLabelLocation.y + (self.imageLabel.frame.size.height / 2))];
    [path lineToPoint:NSMakePoint(self.frame.size.width / 10, (imageLabelLocation.y + (self.imageLabel.frame.size.height / 2) - 30))];
    
    [path moveToPoint:labelEndPoint];
    [path lineToPoint:NSMakePoint((self.frame.size.width / 10)*9, imageLabelLocation.y + (self.imageLabel.frame.size.height / 2))];
    [path lineToPoint:NSMakePoint((self.frame.size.width / 10)*9, (imageLabelLocation.y + (self.imageLabel.frame.size.height / 2) - 30))];
    
    labelBeginPoint = [self lineBeginPointForLabel:self.locationLabel];
    labelEndPoint = [self lineEndPointForLabel:self.locationLabel];
    
    [path moveToPoint:labelBeginPoint];
    [path lineToPoint:NSMakePoint(self.locationButtonLocation.origin.x + (self.locationButtonLocation.size.width / 2), labelBeginPoint.y)];
    [path lineToPoint:NSMakePoint(self.locationButtonLocation.origin.x + (self.locationButtonLocation.size.width/2), self.locationButtonLocation.origin.y - 30)];
    
    labelBeginPoint = [self lineBeginPointForLabel:self.helpLabel];
    labelEndPoint = [self lineEndPointForLabel:self.helpLabel];
    
    [path moveToPoint:labelEndPoint];
    [path lineToPoint:NSMakePoint(self.helpButtonLocation.origin.x + (self.helpButtonLocation.size.width/2), labelEndPoint.y)];
    [path lineToPoint:NSMakePoint(self.helpButtonLocation.origin.x + (self.helpButtonLocation.size.width/2), self.helpButtonLocation.origin.y - 30)];
    
    labelBeginPoint = [self lineBeginPointForLabel:self.exitLabel];
    labelEndPoint = [self lineEndPointForLabel:self.exitLabel];
    
    [path moveToPoint:labelEndPoint];
    [path lineToPoint:NSMakePoint(self.exitButtonLocation.origin.x + (self.exitButtonLocation.size.width/2), labelEndPoint.y)];
    [path lineToPoint:NSMakePoint(self.exitButtonLocation.origin.x + (self.exitButtonLocation.size.width/2), self.exitButtonLocation.origin.y - 30)];
    
    [[NSColor yellowColor] setStroke];
    [path setLineWidth:2.0];
    [path stroke];
    
}

-(NSPoint)lineBeginPointForLabel:(NSTextField *)label
{
    return NSMakePoint(label.frame.origin.x - 10, label.frame.origin.y + (label.frame.size.height / 2));
}

-(NSPoint)lineEndPointForLabel:(NSTextField *)label
{
    return NSMakePoint(label.frame.origin.x +  label.frame.size.width + 10, label.frame.origin.y + (label.frame.size.height / 2));
}

@end
