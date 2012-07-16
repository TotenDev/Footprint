//
//  NSString_Additions.m
//  Footprint
//
//  Created by Gabriel Pacheco on 3/24/11.
//  see LICENSE for details
//

#import "NSString_Additions.h"


@implementation NSString (NSString_Additions)

- (BOOL)hasSubstring:(NSString *)searchString {
	if ([self canCompare:searchString]) {
		for (int i = 0 ; i <= ([self length]-[searchString length]); i++) {
			NSComparisonResult RESULT = [[self substringWithRange:NSMakeRange(i, [searchString length])] compare:searchString options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
			if (RESULT == NSOrderedSame) {
				return YES ;
			}
		}
		return NO ;
	}
	else {
		return NO ;
	}
}

- (BOOL)canCompare:(NSString *)searchString {
	if ([self length]>=[searchString length]) return YES ;
	else return NO ;
}

#pragma mark String Network Helpers

+ (NSString *)SizeFromFileBytes:(float)floatSize {
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.2f bytes",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.2f MB",floatSize]);
	floatSize = floatSize / 1024;
	
	return([NSString stringWithFormat:@"%1.3f GB",floatSize]);
}

+ (NSString *)stringFromFileSize:(float)floatSize {
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.2f bytes/seg",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB/seg",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.2f MB/seg",floatSize]);
	floatSize = floatSize / 1024;
	
	return([NSString stringWithFormat:@"%1.3f GB/seg",floatSize]);
}
//Supporting just KB and MB !
+ (NSString *)stringFromPercentage:(float)_percentage andFileSize:(float)_bytesSize {
    //KB
	if ((_bytesSize/1024) < 1024) {
		float kBytes = (_bytesSize/1024) ;
		NSString * returnString = [NSString stringWithFormat:@"%1.2f KB of %1.2f KB",(kBytes*(_percentage/100)),kBytes];
		return returnString ;
	}
    //MB
	else {
		float megaBytes = ((_bytesSize/1024)/1024) ;
		NSString * returnString = [NSString stringWithFormat:@"%1.2f MB of %1.2f MB",(megaBytes*(_percentage/100)),megaBytes];
		return returnString ;
	}
}
//Return ETA 
+ (NSString *)stringFromPercentage:(float)_percentage andFileSize:(float)_bytesSize andBandwidthPerSecond:(float)bandwidth {
	float bytesUploaded = (_bytesSize*(_percentage/100)) ;
	float bytesRemaining = _bytesSize - bytesUploaded ;
	int secondsETA ;
    
	if (bandwidth <= 0) { 
		return [NSString stringWithFormat:@"∞ seconds"];
	} else if (bytesRemaining < 10) {
		return [NSString stringWithFormat:@"0 second"];
	}
    //Normal
	else if (bandwidth <= bytesRemaining) {
		secondsETA = bytesRemaining/bandwidth ;
        //second
		if (secondsETA < 60) {
			return [NSString stringWithFormat:@"%i second(s)",secondsETA];
		}
        //minutes
		else if (secondsETA/60 < 60){
			return [NSString stringWithFormat:@"%i minute(s) and %i second(s)",(secondsETA/60),((int)(secondsETA%60))];			
		}
        //hours
		else {	
			return [NSString stringWithFormat:@"%i hour(s) and %i minute(s)",((secondsETA/60)/60),((int)((secondsETA/60)%60))];	
		}
	}
    else {
		return [NSString stringWithFormat:@"1 second"];
	}
}

@end
