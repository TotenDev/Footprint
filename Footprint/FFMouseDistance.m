//
//  FFMouseDistance.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/18/11.
//  see LICENSE for details
//

#import "FFMouseDistance.h"
#import <IOKit/IOKitLib.h>
#import <IOKit/graphics/IOGraphicsLib.h>

@implementation FFMouseDistance

//Used on handlers blocks
static FFMouseDistance * mySelfDistance ;
static float DPI ;
NSPoint lastGlobalPoint ;

#pragma Mains
//Selector in FFMouseDistance receives an NSNumber parameter that is Centimeter moved by mouse
- (id)initWithTarget:(id)_target andSelector:(SEL)_selector {
    if ((self = [super initWithTarget:_target andSelector:_selector])) {
        monitoringEventGlobal = nil ;
        lastGlobalPoint = [NSEvent mouseLocation] ;
        return self ;
    } 
    return nil ;
}

//Dealloc
- (void)dealloc {
    if (monitoringEventGlobal != nil) {[self stopMonitoring];}
    [super dealloc];
}

#pragma DPI Functions
//    Handy utility function for retrieving an int from a CFDictionaryRef
static int GetIntFromDictionaryForKey( CFDictionaryRef desc, CFStringRef key ) {
    CFNumberRef value;
    int num = 0;
    if ( (value = CFDictionaryGetValue(desc, key)) == NULL
        || CFGetTypeID(value) != CFNumberGetTypeID())
        return 0;
    CFNumberGetValue(value, kCFNumberIntType, &num);
    return num;
}

//Acess I/O and populate doubles
// ATENCAO
// troquei o <CGDictionaryRef displayModeDict> por <CGDisplayModeRef displayMode>
// porque sim... estava sendo usado nas linhas comentadas. -Marcos. 
CGDisplayErr GetDisplayDPI(CGDisplayModeRef displayMode,CGDirectDisplayID displayID,double *horizontalDPI, double *verticalDPI ) {
    CGDisplayErr err = kCGErrorFailure;
    io_connect_t displayPort;
    CFDictionaryRef displayDict;
    
    //    Grab a connection to IOKit for the requested display
    displayPort = CGDisplayIOServicePort( displayID );
    if ( displayPort != MACH_PORT_NULL )
    {
        //    Find out what IOKit knows about this display
        displayDict = IODisplayCreateInfoDictionary(displayPort, 0);
        if ( displayDict != NULL )
        {
            const double mmPerInch = 25.4;
            double horizontalSizeInInches =
            (double)GetIntFromDictionaryForKey(displayDict,
                                               CFSTR(kDisplayHorizontalImageSize)) / mmPerInch;
            double verticalSizeInInches =
            (double)GetIntFromDictionaryForKey(displayDict,
                                               CFSTR(kDisplayVerticalImageSize)) / mmPerInch;
            
            //    Make sure to release the dictionary we got from IOKit
            CFRelease(displayDict);
            
            // Now we can calculate the actual DPI
            // with information from the displayModeDict
            /* see for details: (double)GetIntFromDictionaryForKey( displayModeDict, kCGDisplayWidth ) */
            *horizontalDPI = (double)CGDisplayModeGetWidth(displayMode)  / horizontalSizeInInches;
            *verticalDPI   = (double)CGDisplayModeGetHeight(displayMode) / verticalSizeInInches;
            err = CGDisplayNoErr;
        }
    }
	CGDisplayModeRelease(displayMode);
    return err;
}

#pragma mark Handlers

//Global Handler
void (^globalMouseDistanceBlock)(NSEvent * ) = ^(NSEvent * event){
    //Check if target is available and if it's responds to current selector
    if (mySelfDistance.target && [mySelfDistance.target respondsToSelector:mySelfDistance.selector]) {
        //Mouse moved action
        if ([event type] == NSMouseMoved) {
            //Distancia andada deste do ultimo ponto
            int x = ([NSEvent mouseLocation].x < lastGlobalPoint.x ? [NSEvent mouseLocation].x - lastGlobalPoint.x : lastGlobalPoint.x-[NSEvent mouseLocation].x);
            int y = ([NSEvent mouseLocation].y < lastGlobalPoint.y ? [NSEvent mouseLocation].y - lastGlobalPoint.y : lastGlobalPoint.y-[NSEvent mouseLocation].y);
            
            // pitagora - distance in pixels
            float totalPixels = sqrtf(powf(x,2)+(powf(y, 2)));
            
            // inches moved
            float inchesWalked = totalPixels/DPI ;
            float centimetros = inchesWalked * 2.54 ;
            
            //Record last point 
            lastGlobalPoint = [NSEvent mouseLocation];
            
            //Invoke
            [mySelfDistance.target performSelector:mySelfDistance.selector withObject:[NSNumber numberWithFloat:centimetros]];
        }
        //UNKNOW Type of action in mouse
        else {
            //Invoke
            [mySelfDistance.target performSelector:mySelfDistance.selector withObject:[NSNumber numberWithInt:0]];
        }
    } 
    else {[[NSException exceptionWithName:@"FFMouseDistance handler exception !" reason:@"Target in FFMouseDistance instance is nil !" userInfo:nil] raise];}
};

#pragma mark Public Methods

- (void)startMonitoring {
    FootprintLog(@"[FFMouseDistance] Start monitoring distance mouse events");
    //If already monitored 
    if (monitoringEventGlobal != nil ) {[self stopMonitoring];}
	
    //Update DPI
    double horizontalDPI, verticalDPI;
    CGDisplayErr err = GetDisplayDPI( //CGDisplayCurrentMode(kCGDirectMainDisplay),
									 CGDisplayCopyDisplayMode(kCGDirectMainDisplay),	
                                     kCGDirectMainDisplay,
                                     &horizontalDPI, &verticalDPI );
    if ( err == CGDisplayNoErr )
    {
        // horizontalDPI and verticalDPI are the same value in all mac hardwares !
        DPI = horizontalDPI ;
    }
    else{
        FootprintLog(@"[FFMouseDistance] Unable do get hardware DPI ");
        DPI = 72 ;
    }
    
    //Used on blocks
    mySelfDistance = self ;
    
    //Global monitoring
    monitoringEventGlobal = [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:globalMouseDistanceBlock];
    
}

- (void)stopMonitoring {
    FootprintLog(@"[FFMouseDistance] Stop monitoring mouse distance events");
    [NSEvent removeMonitor:monitoringEventGlobal]; 
    monitoringEventGlobal = nil ;
}

@end
