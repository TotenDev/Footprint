//
//  FFUSBDevices.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/31/11.
//  see LICENSE for details
//

#import "FFUSBDevices.h"


@implementation FFUSBDevices

+ (void)runTest {
    NSLog(@"%@",[[NSWorkspace sharedWorkspace]mountedLocalVolumePaths]);
    NSLog(@"%@",[[NSWorkspace sharedWorkspace]mountedRemovableMedia]);
}

@end
