//
//  FFKeyboard.m
//  Footprint
//
//  Created by Marcos Trovilho on 3/17/11.
//  see LICENSE for details
//

#import "FFKeyboard.h"


@implementation FFKeyboard

-(id)initWithTarget:(id)_target andSelector:(SEL)_selector {
	self = [super initWithTarget:_target andSelector:_selector];
    if (self) {
		NSLog(@"%@", [[NSWorkspace sharedWorkspace] mountedLocalVolumePaths]);
		
//		id k = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyUp handler:^(NSEvent *evnt) {
//			NSLog(@"%@",evnt);
//		}];
		
    }
    return self;
}

-(void)startMonitoring {
	
}


@end