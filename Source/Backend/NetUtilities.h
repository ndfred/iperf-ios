//
//  NetUtilities.h
//  iperf
//
//  Created by Andy Peterman on 12/2/22.
//

#ifndef NetUtilities_h
#define NetUtilities_h

#import <UIKit/UIKit.h>

#import <arpa/inet.h>
#import <ifaddrs.h>

@interface NetUtilities : NSObject

+(UITextField*)getBestAddr:(UITextField*)addr
				 localAddr:(UITextField*)localAddr
					  port:(int)port;

+ (void)showError:(NSString*)title
		formatStr:(NSString*)formatStr
		  message:(NSString*)message
			 code:(NSInteger)code
popViewController:(BOOL)popViewController;

@end


#endif /* NetUtilities_h */
