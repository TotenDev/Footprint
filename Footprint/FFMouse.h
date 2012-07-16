//
//  FFMouse.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/17/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>
#import "FootprintFramework.h"

//types of event sent this class
typedef enum {
    FFMouseRight = 0 ,
    FFMouseLeft = 1 ,
    FFMouseUnknown = 2
}FFMouseEventType ;

@interface FFMouse : FootprintFramework {
@private
    id monitoringEventGlobal ;   
    id monitoringEventLocal ;  
}
//Public Metohds
- (void)startMonitoring ;
- (void)stopMonitoring ;

//Handlers
//void (^globalMouseBlock)(NSEvent * ) = ^(NSEvent * event) ;
//NSEvent* (^localMouseBlock)(NSEvent *) = ^(NSEvent * event) ;


@end
