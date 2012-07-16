//
//  FFCPUInfo.h
//  Footprint
//
//  Created by Marcos Trovilho on 3/23/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>
#import "FootprintFramework.h"

@interface FFCPUInfo : FootprintFramework {
	io_connect_t root_port;
	io_object_t notifier;
}
@end