//
//  FFMemory.m
//  Footprint
//
//  Created by Marcos Trovilho on 3/22/11.
//  see LICENSE for details
//

#import "FFMemory.h"
#import <mach/mach.h> 
#import <mach/mach_host.h>

@interface FFMemory (private)
unsigned long memoryFree(void);
unsigned long memoryTotal(void);
unsigned long memoryUsed(void);
@end

@implementation FFMemory

#pragma mark - Public Methods

+(MEMSTATUS)memoryStatus {
	MEMSTATUS mStatus;
	mStatus.memFree = memoryFree();
	mStatus.memUsed = memoryUsed();
	mStatus.memTotal = memoryTotal();
	return mStatus;
}

+(int)memoryFree {
	return (int)memoryFree();
}

+(int)memoryUsed {
	return (int)memoryUsed();
}

+(int)memoryTotal {
	return (int)memoryTotal();
}

unsigned long memoryFree(void) {
    mach_port_t				host_port = mach_host_self();
    mach_msg_type_number_t	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t				pagesize;
    vm_statistics_data_t	vm_stat;
	
    host_page_size(host_port, &pagesize);
	
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
		NSLog(@"oops, failed to get vmstatistics");
	
    return (vm_stat.free_count * pagesize / 1024 / 1024);
}

unsigned long memoryUsed(void) {
    mach_port_t				host_port = mach_host_self();
    mach_msg_type_number_t  host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t    vm_stat;
	
    host_page_size(host_port, &pagesize);
	
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
		NSLog(@"oops, failed to get vmstatistics");
	
    return ((vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize / 1024 / 1024);
}

unsigned long memoryTotal(void) {
    mach_port_t				host_port = mach_host_self();
    mach_msg_type_number_t  host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t    vm_stat;
	
    host_page_size(host_port, &pagesize);
	
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
		NSLog(@"oops, failed to get vmstatistics");
	
    unsigned long mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    unsigned long mem_free = vm_stat.free_count * pagesize;
	
    return ((mem_used + mem_free) / 1024 / 1024);
}

@end