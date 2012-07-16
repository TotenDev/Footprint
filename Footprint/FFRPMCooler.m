//
//  FFRPMCooler.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/22/11.
//  see LICENSE for details
//

#import "FFRPMCooler.h"
#import "FootprintFramework.h"


@implementation FFRPMCooler

#pragma Routines
//return current RPM 
+ (RPM_STATUS)returnRPM {
    NSTask * task = [[NSTask alloc]init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle * readHandler = [pipe fileHandleForReading];

    [task setLaunchPath:[NSString stringWithFormat:@"%@/smc",[[NSBundle mainBundle]resourcePath]]];
    [task setArguments:[NSArray arrayWithObjects:@"-f", nil]];

    [task setStandardOutput:pipe];
    [task launch];

    //Make file read
    NSData * readData = [[readHandler readDataToEndOfFile] retain];
    //Close I/O acess manually
    close([readHandler fileDescriptor]);
    //Wait until finished !
    [task waitUntilExit];

    NSInteger finishStatus = [task terminationStatus];
    RPM_STATUS returnStatus ;
    //Process Error
    if  (finishStatus != 0) { 
        returnStatus.response_status = kErrorRPM ;
        returnStatus.RPM = 0 ;
    }
    else {
        NSString * readString = [[NSString alloc]initWithData:readData encoding:NSUTF8StringEncoding];
        NSArray * vector = [[readString componentsSeparatedByString:@"\n"] retain];
        
        int Fans = [[[vector objectAtIndex:0] substringWithRange:NSMakeRange([[vector objectAtIndex:0]length]-2, 2)] intValue] ;
        //NO FANS AVAILABLE
        if (Fans == 0){
            returnStatus.response_status = kErrorNoFans ;
            returnStatus.RPM = 0 ;
        }
        else {
            returnStatus.response_status = kSucessRPM ;
            returnStatus.RPM = [FFRPMCooler returnRPMWithThisVector:vector] ;
        }

        [readString release];
        [vector release];
    }

    //Release 
    [task release];
    [pipe release];
    [readData release];

    return returnStatus ;
}

#pragma Helpers

//Retorna o MAIOR RPM achado no vetor 
+ (unsigned long)returnRPMWithThisVector:(NSArray *)_array {
    NSMutableArray * array = [[[NSMutableArray alloc]init] autorelease];
    for (NSString * _id in _array) {
        if ([_id hasSubstring:@"Actual speed :"]) {
            NSString * str = @"Actualspeed:";
            NSString * strNonScapes = [_id stringByReplacingOccurrencesOfString:@" " withString:@""] ;
            NSString * rpmString = [strNonScapes substringWithRange:NSMakeRange([str length], [strNonScapes length]-[str length])];
            [array addObject:rpmString];
        }
    }

    if ([array count]>0) {
        if ([array count]==1) {return [[array objectAtIndex:0] intValue];}
        else {return [FFRPMCooler biggerValueIntoArray:array];}
    }
    
    return NO ;
}

+ (unsigned long)biggerValueIntoArray:(NSArray *)_vector {
    int bigger = -1 ;
    for (NSString * string in _vector){
        if ([string intValue] > bigger) {bigger = [string intValue];}
    }
    return bigger ;
}

@end
