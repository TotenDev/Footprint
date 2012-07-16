//
//  FFWLan.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/31/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>

//WLan Interface - Return response in query on FFWLAN
@interface WLan : NSObject {
@private
    BOOL connected ;

    NSString * ssid ;
    NSString * channel ;
    NSString * security ;
    NSString * phyMode ;

}

//Properties
@property(nonatomic) BOOL connected ;
@property(nonatomic,retain) NSString * ssid ;
@property(nonatomic,retain) NSString * channel ;
@property(nonatomic,retain) NSString * security ;
@property(nonatomic,retain) NSString * phyMode ;

//Ultils Class Methods
+ (NSString*)returnStringBySecurityMode:(NSNumber *)securityMode ;
+ (NSString *)returnStringByPhyMode:(NSNumber *)phyMode  ;

//Init Class Method
+ (id)initWithInterfaceState:(NSNumber *)interfaceState 
                securityMode:(NSNumber *)securityMode 
              currentChannel:(NSNumber *)channel 
                     phyMode:(NSNumber *)phyMode
               interfaceSSID:(NSString *)ssid ;

//Ultils
- (void)logWLAN ;

@end

@interface FFWLan : NSObject

+ (WLan *)getWLAN  ;
+ (void)logWLAN:(WLan *)wlan ;

@end
