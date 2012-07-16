//
//  FFNetwork.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/25/11.
//  see LICENSE for details
//

#import "FFNetwork.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <sys/un.h>
#import <stdio.h>
#import <unistd.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <net/if_var.h>
#import <net/route.h>
#import <limits.h>

@implementation FFNetwork

- (void)dealloc {
    [super dealloc];
}

#pragma mark Helpers 

+ (NetStatus *)returnInterfacesStatus {
    
    int mib[] = {CTL_NET,PF_ROUTE,0,0,NET_RT_IFLIST2,0};
    size_t len;

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        fprintf(stderr, "sysctl: %s\n", strerror(errno));
        return [NSArray array];
    }
    char *buf = (char *)malloc(len);
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        fprintf(stderr, "sysctl: %s\n", strerror(errno));
        return [NSArray array];
    }
    char *lim = buf + len;
    char *next = NULL;

    u_int64_t totalibytes = 0;
    u_int64_t totalobytes = 0;

    for (next = buf; next < lim; ) {
        struct if_msghdr *ifm = (struct if_msghdr *)next;
        next += ifm->ifm_msglen;
        if (ifm->ifm_type == RTM_IFINFO2) {
            struct if_msghdr2 *if2m = (struct if_msghdr2 *)ifm;
            totalibytes += if2m->ifm_data.ifi_ibytes;
            totalobytes += if2m->ifm_data.ifi_obytes;
        }
    }
    
    return [NetStatus statusWithBytesIn:totalibytes bytesOut:totalobytes];
}

@end

@implementation NetStatus  
@synthesize bytesIn,bytesOut ;

+ (NetStatus *)statusWithBytesIn:(u_int64_t)_bytesIn bytesOut:(u_int64_t)bytesOut {

    NetStatus * status ;
    if ((status = [[super alloc] init])) {

        [status setBytesIn:_bytesIn];
        [status setBytesOut:bytesOut];

        return [status autorelease] ;
    }
    return nil ;
}

@end
