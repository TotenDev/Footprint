//
//  FFMouseDistance.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/18/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>
#import "FootprintFramework.h"

@interface FFMouseDistance : FootprintFramework {
@private
    id monitoringEventGlobal ;
}

//Public methods
- (void)startMonitoring ;
- (void)stopMonitoring ;
@end
