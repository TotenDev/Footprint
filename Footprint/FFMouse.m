//
//  FFMouse.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/17/11.
//  see LICENSE for details
//

#import "FFMouse.h"


@implementation FFMouse
FFMouse * mySelf ;

//Selector in FFMouse receives an NSNumber parameter
- (id)initWithTarget:(id)_target andSelector:(SEL)_selector {
    if ((self = [super initWithTarget:_target andSelector:_selector])) {
        monitoringEventGlobal = nil ;
        monitoringEventLocal = nil ;

        return self ;
    } 
    return nil ;
}

- (void)dealloc {
    if (monitoringEventGlobal != nil || monitoringEventLocal != nil) {[self stopMonitoring];}
    [super dealloc];
}

#pragma mark Handlers

//Global Handler
void (^globalMouseBlock)(NSEvent * ) = ^(NSEvent * event){
    //Check if target is available and if it's responds to current selector
    if (mySelf.target && [mySelf.target respondsToSelector:mySelf.selector]) {
        //RIGHT MOUSE ACTION
        if ([event type] == NSRightMouseDown) {
            //Invoke
            [mySelf.target performSelector:mySelf.selector withObject:[NSNumber numberWithInt:FFMouseRight]];
        }
        
        //LEFT MOUSE ACTION
        else if ([event type] == NSLeftMouseDown) {
            //Invoke
            [mySelf.target performSelector:mySelf.selector withObject:[NSNumber numberWithInt:FFMouseLeft]];
        }
        
        //UNKNOW Type of action in mouse
        else {
            //Invoke
            [mySelf.target performSelector:mySelf.selector withObject:[NSNumber numberWithInt:FFMouseUnknown]];
        }
    } 
    else {[[NSException exceptionWithName:@"FFMouse handler exception !" reason:@"Target in FFMouse instance is nil !" userInfo:nil] raise];}
};

//Local Handler
NSEvent* (^localMouseBlock)(NSEvent *) = ^(NSEvent * event){
    //Check if target is available and if it's responds to current selector
    if (mySelf.target && [mySelf.target respondsToSelector:mySelf.selector]) {
        //RIGHT MOUSE ACTION
        if ([event type] == NSRightMouseDown) {
            //Invoke
            [mySelf.target performSelector:mySelf.selector withObject:[NSNumber numberWithInt:FFMouseRight]];
        }
        
        //LEFT MOUSE ACTION
        else if ([event type] == NSLeftMouseDown) {
            //Invoke
            [mySelf.target performSelector:mySelf.selector withObject:[NSNumber numberWithInt:FFMouseLeft]];
        }
        
        //UNKNOW Type of action in mouse
        else {
            //Invoke
            [mySelf.target performSelector:mySelf.selector withObject:[NSNumber numberWithInt:FFMouseUnknown]];
        }
    } 
    else {[[NSException exceptionWithName:@"FFMouse handler exception !" reason:@"Target in FFMouse instance is nil !" userInfo:nil] raise];}
    
    //Return event - if is isn't in exception !
    return event ;
};

#pragma mark Public Methods

//Start Monitoring - add monitor to events - 
// if called two or more times in same instance , just one call is made in selector
- (void)startMonitoring {
    FootprintLog(@"[FFMouse] Start monitoring mouse events");
    //If already monitored 
    if (monitoringEventGlobal != nil || monitoringEventLocal != nil) {[self stopMonitoring];}
    
    //Used on blocks
    mySelf = self ;

    //Global monitoring
    monitoringEventGlobal = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDown handler:globalMouseBlock];

    //Local Monitoring
    monitoringEventLocal = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDown handler:localMouseBlock];
}
//Stop monitoring events
- (void)stopMonitoring {
    FootprintLog(@"[FFMouse] Stop monitoring mouse events");

    [NSEvent removeMonitor:monitoringEventGlobal]; 
    [NSEvent removeMonitor:monitoringEventLocal];

    monitoringEventGlobal = nil ;
    monitoringEventLocal = nil ;
}

@end
