//
//  LocationMenuItemView.h
//  Walled
//
//  Created by Christopher Hayen on 1/3/13.
//  Copyright (c) 2013 Christopher Hayen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LocationMenuItemView : NSView

@property NSString *title;

-(void)setCanDelete:(BOOL)value;
-(void)setLocation:(NSString *)location;

@property (nonatomic, assign) SEL deleteAction;
@property (retain) NSCursor *cursor;

@property (weak) IBOutlet NSButton *deleteButton;
@property (weak) IBOutlet NSTextField *locationLabel;

- (IBAction)deleteButtonSelected:(id)sender;

@end
