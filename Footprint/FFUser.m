//
//  FFUser.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/31/11.
//  see LICENSE for details
//

#import "FFUser.h"

@implementation FFUser

+(NSString *)getUserName {
    return NSUserName() ;
}

+(NSString *)getFullUserName {
    return NSFullUserName() ;
}

@end
