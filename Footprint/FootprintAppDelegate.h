//
//  FootprintAppDelegate.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/17/11.
//  see LICENSE for details
//

#import <Cocoa/Cocoa.h>
#import "FootprintFrameworkImports.h"

@interface FootprintAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    FFMouse * mouser ;
    FFMouseDistance * mouserDistance ;
    float centimeters ;
}
 
@property (assign) IBOutlet NSWindow *window;

@end
