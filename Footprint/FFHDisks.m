//
//  FFHDisks.m
//  Footprint
//
//  Created by Marcos Trovilho on 3/30/11.
//  see LICENSE for details
//

#import "FFHDisks.h"
#include <libproc.h>
#import <mach/mach.h> 
#import <mach/mach_host.h>

#include <mach/mach_port.h>
#include <mach/mach_interface.h>
#include <mach/mach_init.h>


@implementation FFHDisks

- (id)initWithTarget:(id)_target andSelector:(SEL)_selector
{
    self = [super initWithTarget:_target andSelector:_selector];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)myCallbackFunction {
	NSLog(@"hello");
}

+(void)hd {
	/* Define variables and create a CFArray object containing
	 CFString objects containing paths to watch.
     */
//    CFStringRef mypath = CFSTR("/");
//    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&mypath, 1, NULL);
//    void *callbackInfo = NULL; // could put stream-specific data here.
//    FSEventStreamRef stream;
//    CFAbsoluteTime latency = 3.0; /* Latency in seconds */
	
    /* Create the stream, passing in a callback */
//    stream = FSEventStreamCreate(NULL,&myCallbackFunction,callbackInfo,pathsToWatch,
//								 kFSEventStreamEventIdSinceNow, /* Or a previous event ID */
//								 latency,kFSEventStreamCreateFlagNone /* Flags explained in reference */);
	int pid = 4934;
	int a = proc_name(pid, NULL, 0);
	printf("HD: %i\n",a);
	
	/*
	struct rusage r_usage;
	
	if (fs_usage(RUSAGE_SELF, &r_usage)) {
	//... error handling ...
	} else {
		printf("Total User CPU = %ld.%d\n",r_usage.ru_utime.tv_sec,r_usage.ru_utime.tv_usec);
		printf("Total System CPU = %ld.%d\n",r_usage.ru_stime.tv_sec,r_usage.ru_stime.tv_usec);
	}
	*/
}


@end
