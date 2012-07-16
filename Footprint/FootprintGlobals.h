//
//  FootprintGlobals.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/18/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>
#import "NSString_Additions.h"

// Update time for FFMemory in SECONDS!
#define kUpdateInterval_High (15*60)
#define kUpdateInterval_Medium (1*60)
#define kUpdateInterval_Low 5

//Definitions
#define ShouldLog [[[[NSBundle mainbundle]infoDict]objectForKey:@"PrintLog"]boolValue]

#ifdef ShouldLog
//#define FootprintLog(s, ...)NSLog( @"< Function:%s (Line:%d) > %@",__FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define FootprintLog(s, ...)NSLog( @"%@", [NSString stringWithFormat:(s), ##__VA_ARGS__])
#endif