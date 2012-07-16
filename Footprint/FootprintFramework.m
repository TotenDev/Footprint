//
//  FootprintFramework.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/17/11.
//  see LICENSE for details
//

#import "FootprintFramework.h"


@implementation FootprintFramework
@synthesize target , selector ;

- (id)initWithTarget:(id)_target andSelector:(SEL)_selector {
    if ((self = [super init])){
        target = _target ;
        selector = _selector ;
        return self ;
    }
    return nil ;
}

-(void)startMonitoring {

}

-(void)stopMonitoring {
	
}

- (void)dealloc {
    [target release];
    [super dealloc];
}

@end
