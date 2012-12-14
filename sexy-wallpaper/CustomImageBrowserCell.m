//
//  CustomImageBrowserCell.m
//  Walled
//
//  Created by Christopher Hayen on 12/13/12.
//  Copyright (c) 2012 Christopher Hayen. All rights reserved.
//

#import "CustomImageBrowserCell.h"

@implementation CustomImageBrowserCell

- (CALayer *)layerForType:(NSString *)type
{

    if(type == IKImageBrowserCellForegroundLayer)
    {
        CALayer *layer = [CALayer layer];
        [layer setBorderColor:CGColorGetConstantColor(kCGColorWhite)];
        [layer setBorderWidth:2.0];
        return layer;
    }
    else if(type == IKImageBrowserCellSelectionLayer)
    {
        return [CALayer layer];
    }
    else
    {
        return [super layerForType:type];
    }
}


@end
