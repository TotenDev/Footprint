//
//  FFRPMCooler.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/22/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>

//RPM_response_Status
typedef enum {
    kErrorRPM = 0 ,
    kErrorNoFans = 1 ,
    kSucessRPM = 2 
    
}RPM_response_Status;

//Response Structure
typedef struct {
    RPM_response_Status response_status ;
    unsigned long RPM ;
} RPM_STATUS ;

@interface FFRPMCooler : NSObject

//Helpers !!
+ (unsigned long)returnRPMWithThisVector:(NSArray *)_array ;
+ (unsigned long)biggerValueIntoArray:(NSArray *)_vector ; 

#pragma mark Routine

//Main routine !
+ (RPM_STATUS)returnRPM ;

@end
