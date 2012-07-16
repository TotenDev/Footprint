//
//  FootprintAppDelegate.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/17/11.
//  see LICENSE for details
//

#import "FootprintAppDelegate.h"

@implementation FootprintAppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //Mouse distance event
    mouserDistance = [[FFMouseDistance  alloc]initWithTarget:self andSelector:@selector(mouseEventWithDistance:)];
    centimeters = 0 ;
    [mouserDistance startMonitoring];
    
    //Mouse Clicks event
    mouser = [[FFMouse alloc]initWithTarget:self andSelector:@selector(mouseEventWithType:)];
    [mouser startMonitoring];
    
	//Memory
	NSLog(@"[FFMemory] Free Memory: %d MB", [FFMemory memoryFree]);
	NSLog(@"[FFMemory] Used Memory: %d MB", [FFMemory memoryUsed]);
	NSLog(@"[FFMemory] Total Memory: %d MB", [FFMemory memoryTotal]);
    
    // HD
	[FFHDisks hd];

	//Cpu
	FFCPUInfo *cpu = [[FFCPUInfo alloc] initWithTarget:nil andSelector:nil];
	[cpu startMonitoring];

    //Network bandwidth
    [self performSelector:@selector(printNetworkStatus) withObject:nil afterDelay:1];

    //In Case of non network , it returns 
    WLan * currentLan = [FFWLan getWLAN];
    [currentLan logWLAN];

    //User name logged in
    FootprintLog(@"[FFUser] User name :%@",[FFUser getFullUserName]);

    [FFUSBDevices runTest];
}

- (void)printNetworkStatus {
    NetStatus * status = [FFNetwork returnInterfacesStatus] ;
    FootprintLog(@"[FFNetwork] Net-In: %@",[NSString SizeFromFileBytes:status.bytesIn]);
    FootprintLog(@"[FFNetwork] Net-Out: %@",[NSString SizeFromFileBytes:status.bytesOut]);  
    [self performSelector:@selector(printNetworkStatus) withObject:nil afterDelay:10];
}

- (void)printRPM {
    //RPM Cooler
    RPM_STATUS currentStatus = [FFRPMCooler returnRPM];
    switch (currentStatus.response_status) {
        case kErrorRPM :
            FootprintLog(@"[FFRPMCooler] error in getting RPM ");
            break;
        case kErrorNoFans :
            FootprintLog(@"[FFRPMCooler] do not found FUNS to get RPM");            
            break;
        case kSucessRPM :
            FootprintLog(@"[FFRPMCooler] with sucess %lu RPM",currentStatus.RPM);
            break;
            
        default:
            break;
    }
}

#pragma mark FFMouse.. Delegates
//Mouse clicks
- (void)mouseEventWithType:(NSNumber *)_eventType {
    switch ([_eventType intValue]) {
        case FFMouseLeft :
            FootprintLog(@"[FFMouse] Left mouse action");
            break;
        case FFMouseRight :
            FootprintLog(@"[FFMouse] Right mouse action");
            break;
        case FFMouseUnknown :
            FootprintLog(@"[FFMouse] Unknown mouse action");
            break;
    }
    FootprintLog(@"[FFMouseDistance] Distance %1.2f centimetros", centimeters);
}
//Mouse Distance 
- (void)mouseEventWithDistance:(NSNumber *)_distance {
    centimeters += [_distance floatValue];
}

#pragma mark - FFMemoryDelegate

-(void)memoryStatus:(MEMSTATUS)mStat {
	FootprintLog(@"[FFMemoryDelegate]: Free: %lu MB, Used: %lu MB, Total: %lu MB", mStat.memFree, mStat.memUsed, mStat.memTotal);
}

- (void)dealloc {
    [mouserDistance release];
    [mouser release];
    [super dealloc];
}

@end
