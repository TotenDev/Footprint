//
//  FFMemory.h
//  Footprint
//
//  Created by Marcos Trovilho on 3/22/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>
#import "FootprintFramework.h"

typedef struct {
	unsigned long memFree;
	unsigned long memUsed;
	unsigned long memTotal;
} MEMSTATUS;

@interface FFMemory : FootprintFramework {}

//Public Metohds
+(MEMSTATUS)memoryStatus;
+(int)memoryFree;
+(int)memoryUsed;
+(int)memoryTotal;

@end