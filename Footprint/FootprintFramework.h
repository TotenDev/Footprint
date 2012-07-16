//
//  FootprintFramework.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/17/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>
#import "NSString_Additions.h"

@interface FootprintFramework : NSObject {
     id target ;
     SEL selector ;
}

@property (nonatomic)SEL selector ;
@property (nonatomic,retain)id target ;

- (id)initWithTarget:(id)_target andSelector:(SEL)_selector ;

-(void)startMonitoring;
-(void)stopMonitoring;

@end
