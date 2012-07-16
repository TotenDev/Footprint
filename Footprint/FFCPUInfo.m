//
//  FFCPUInfo.m
//  Footprint
//
//  Created by Marcos Trovilho on 3/23/11.
//  see LICENSE for details
//

#import "FFCPUInfo.h"
#include <sys/resource.h>
#import <mach/mach.h> 
#import <mach/mach_host.h>

#include <mach/mach_port.h>
#include <mach/mach_interface.h>
#include <mach/mach_init.h>

#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>

kern_return_t result;
io_connect_t conn;

@interface FFCPUInfo (private)
-(void)reportCPUInfoEvery:(NSNumber*)seconds;
- (void)powerMessageReceived:(natural_t)messageType withArgument:(void *) messageArgument;
unsigned long cpuInfo(void);
@end

@implementation FFCPUInfo

- (id)initWithTarget:(id)_target andSelector:(SEL)_selector
{
    self = [super initWithTarget:_target andSelector:_selector];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Public Methods

-(void)startMonitoring {
	[self performSelectorInBackground:@selector(reportCPUInfoEvery:) withObject:[NSNumber numberWithInt:15]];
}

-(void)stopMonitoring {
	
}

#pragma mark - Private Methods

-(void)reportCPUInfoEvery:(NSNumber*)seconds {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	while (YES) {
		
		struct rusage r_usage;
		
		if (getrusage(RUSAGE_SELF, &r_usage)) {
			/* ... error handling ... */
		} else {
			printf("Total User CPU = %ld.%d\n",r_usage.ru_utime.tv_sec,r_usage.ru_utime.tv_usec);
			printf("Total System CPU = %ld.%d\n",r_usage.ru_stime.tv_sec,r_usage.ru_stime.tv_usec);
		}
		
		[NSThread sleepForTimeInterval:[seconds intValue]];
	}
	[pool release];
}

unsigned long cpuInfo(void) {
	/*
    //mach_port_t				host_port = mach_host_self();
    mach_msg_type_number_t	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t				pagesize;
    vm_statistics_data_t	vm_stat;
    //host_page_size(host_port, &pagesize);
	
	mach_port_t host_port = mach_host_self();
	processor_flavor_t flavor;
	natural_t procCount;
	processor_info_array_t outInfoArray;
	mach_msg_type_number_t outinfoCount;
	
	host_processor_info(<#host_t host#>, <#processor_flavor_t flavor#>, <#natural_t *out_processor_count#>, <#processor_info_array_t *out_processor_info#>, <#mach_msg_type_number_t *out_processor_infoCnt#>);
	
	host_statistics(<#host_t host_priv#>, <#host_flavor_t flavor#>, <#host_info_t host_info_out#>, <#mach_msg_type_number_t *host_info_outCnt#>);
    if (host_statistics(host_port, HOST_CPU_LOAD_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
		NSLog(@"oops, failed to get vmstatistics");
	
    return 0;//(vm_stat);
	 */
	return 0;
}

//-(void)showTemp {
//	int i=0;
//	UInt32Char_t key;
//	sprintf(key, "TC%dD", i);
//	result = SMCReadKey2(key, &val,conn);
//	float c_temp= ((val.bytes[0] * 256 + val.bytes[1]) >> 2)/64;
//	NSLog(@"===temp: %f",c_temp);
//}

void SleepWatchDog( void * refCon, io_service_t service, natural_t messageType, void * messageArgument ){
	[(FFCPUInfo *)refCon powerMessageReceived: messageType withArgument: messageArgument];
}

- (void)registerForSleepWakeNotification
{
	IONotificationPortRef notificationPort;
	root_port = IORegisterForSystemPower(self, &notificationPort, SleepWatchDog, &notifier);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(notificationPort), kCFRunLoopDefaultMode);
}

- (void)deregisterForSleepWakeNotification
{
	IODeregisterForSystemPower(&notifier);
}

- (void)powerMessageReceived:(natural_t)messageType withArgument:(void *) messageArgument
{
	NSLog(@"hello: %iu",messageType);
	switch (messageType)
	{
		case kIOMessageSystemWillSleep:
			IOAllowPowerChange(root_port, (long)messageArgument);
			break;
		case kIOMessageCanSystemSleep:
			IOAllowPowerChange(root_port, (long)messageArgument);
			break; 
		case kIOMessageSystemHasPoweredOn:
			NSLog(@"system did wake from sleep");
			//[self apply:nil];
			break;
		case kIOMessageSystemWillPowerOn:
			NSLog(@"power on");
			break;
	}
}

@end
