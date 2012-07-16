//
//  FFNetwork.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/25/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>

/********************NetStatus Return Class************************/

@interface NetStatus : NSObject {
@private
    u_int64_t bytesOut;
    u_int64_t bytesIn;
}

//Helper
+ (NetStatus *)statusWithBytesIn:(u_int64_t)_bytesIn bytesOut:(u_int64_t)bytesOut ;

//Bytes
@property (nonatomic) u_int64_t bytesOut;
@property (nonatomic) u_int64_t bytesIn;

@end

/********************FFNetwork************************/

@interface FFNetwork : NSObject

+ (NetStatus *)returnInterfacesStatus ;

@end

