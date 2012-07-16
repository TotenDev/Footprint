//
//  FFWLan.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/31/11.
//  see LICENSE for details
//
#import "FFWLan.h"
#import <CoreWLAN/CoreWLAN.h>

@implementation FFWLan

+ (WLan *)getWLAN {
    CWInterface* wifi = [CWInterface interface];
    return [WLan initWithInterfaceState:wifi.interfaceState securityMode:wifi.securityMode currentChannel:wifi.channel phyMode:wifi.phyMode interfaceSSID:wifi.ssid];
}

@end

@implementation WLan
@synthesize connected,ssid,channel,security,phyMode ;

+ (id)initWithInterfaceState:(NSNumber *)interfaceState 
                securityMode:(NSNumber *)securityMode 
                currentChannel:(NSNumber *)channel 
                phyMode:(NSNumber *)phyMode
                interfaceSSID:(NSString *)ssid {

    WLan * lanner = [[WLan alloc]init];

    switch ([interfaceState intValue]) {
        case kCWInterfaceStateRunning:
            [lanner setConnected:YES];
            [lanner setSsid:ssid];
            [lanner setChannel:[channel stringValue]];
            [lanner setSecurity:[WLan returnStringBySecurityMode:securityMode]];
            [lanner setPhyMode:[WLan returnStringByPhyMode:phyMode]];
            break;
        default:
            [lanner setConnected:NO];
            [lanner setSsid:nil];
            [lanner setChannel:nil];
            [lanner setSecurity:nil];
            [lanner setPhyMode:nil];
            break;
    }

    return [lanner autorelease];
}

//Helpers
+ (NSString*)returnStringBySecurityMode:(NSNumber *)securityMode {
    switch ([securityMode intValue]) {
        case kCWSecurityModeOpen:
            return @"Mode Open";
            break;
        case kCWSecurityModeWEP:
            return @"Mode WEP";
            break;
        case kCWSecurityModeWPA_PSK:
            return @"Mode WPA PSK";
            break;
        case kCWSecurityModeWPA2_PSK:
            return @"Mode WPA2 PSK";
            break;
        case kCWSecurityModeWPA_Enterprise:
            return @"Mode WPA Enterprise";
            break;
        case kCWSecurityModeWPA2_Enterprise:
            return @"Mode WPA2 Enterprise";
            break;
        case kCWSecurityModeWPS:
            return @"Mode WPS";
            break;
        case kCWSecurityModeDynamicWEP:
            return @"Mode Dynamic WEP";
            break;            
        default:
            return @"Mode Not Found";
            break;
    }  
}

+ (NSString *)returnStringByPhyMode:(NSNumber *)phyMode {
    switch ([phyMode intValue]) {
        case kCWPHYMode11A :
            return @"A";
            break;
        case kCWPHYMode11B :
            return @"B";
            break;
        case kCWPHYMode11G :
            return @"G";
            break;
        case kCWPHYMode11N :
            return @"N";
            break;
        default:
            return @"Not Found";
            break;
    }
}

//Log
- (void)logWLAN {
    NSLog(@"[FFWLan] Connected: %@",[NSNumber numberWithBool:self.connected]);
    if (!self.connected) {return ;}

    NSLog(@"[FFWLan] WI-FI Name: %@",self.ssid);
    NSLog(@"[FFWLan] Channel: %@",self.channel);
    NSLog(@"[FFWLan] Security: %@",self.security);
    NSLog(@"[FFWLan] Wi-Fi Mode: %@",self.phyMode);
}

@end
