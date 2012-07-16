//
//  NSString_Additions.h
//  Footprint
//
//  Created by Gabriel Pacheco on 3/24/11.
//  see LICENSE for details
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_Additions)
- (BOOL)hasSubstring:(NSString *)searchString ;
- (BOOL)canCompare:(NSString *)searchString ;

#pragma mark String Network Helpers

+ (NSString *)stringFromPercentage:(float)_percentage andFileSize:(float)_bytesSize andBandwidthPerSecond:(float)bandwidth ;
+ (NSString *)stringFromPercentage:(float)_percentage andFileSize:(float)_bytesSize ;
+ (NSString *)stringFromFileSize:(float)floatSize ;
+ (NSString *)SizeFromFileBytes:(float)floatSize ;

@end
