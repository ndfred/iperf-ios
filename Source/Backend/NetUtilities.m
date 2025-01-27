//
//  NetUtilities.m
//  iperf
//
//  Created by Andy Peterman on 12/2/22.
//

#import "NetUtilities.h"

#include <netdb.h>
#include <sys/time.h>

@implementation NetUtilities

// getBestAddr
// Determine which address is best
// If a local address is given and it matches the local network, then use that
// Otherwise, use the regular address
// This also tests each address for validity and displays any errors
// Returns nil if neither address is any good

+(UITextField*)getBestAddr:(UITextField*)addrField
				 localAddr:(UITextField*)localAddrField
					  port:(int)port
{
	NSString* addr = addrField.text;
	NSString* localAddr = localAddrField.text;
	UITextField* result = nil;
	NSString* alertTitle = nil;
	NSString* alertFormatStr = nil;
	NSString* alertMessage = nil;
	int error1 = 0, error2 = 0;

	// First check for valid addresses

	if (addr.length == 0 && localAddr.length == 0)
	{
		alertTitle = @"Configuration Error";
		alertMessage = @"You must specify at least one address.";
		goto exit;
	}
	
	// Now check validity of the address by attempting to create an NSURL
	
	if (addr.length > 0 && [NSURL URLWithString:addr] == nil)
	{
		alertTitle = @"Address Error";
		alertFormatStr = @"The address '%@' is not valid.";
		alertMessage = addr;
		goto exit;
	}
	
	if (localAddr.length > 0 && [NSURL URLWithString:localAddr] == nil)
	{
		alertTitle = @"Local Address Error";
		alertFormatStr = @"The address '%@' is not valid.";
		alertMessage = localAddr;
		goto exit;
	}
	
	// If we have a local address, check that it matches our network and if so,
	// see if the host is really there, using a timeout of 1 second for our local network

	if (localAddr.length > 0 && [NetUtilities isIPAddressOnLocalNetwork:localAddr])
	{
		error1 = [NetUtilities isHostValid:localAddr port:port timeout:1];
		
		if (error1 == 0)
			result = localAddrField;
	}
	
	// If no valid local device, try our main host address and test it too
	
	if (result == nil && addr.length > 0)
	{
		error2 = [NetUtilities isHostValid:addr port:port timeout:5];
		
		if (error2 == 0)
			result = addrField;
	}
	
	// If neither address worked, show error
	
	if (result == nil)
	{
		if (error2 != 0)
		{
			alertTitle = @"Address Error";
			alertMessage = addr;
	}
		
		else if (error1 != 0)
		{
			alertTitle = @"Local Address Error";
			alertMessage = localAddr;
		}

		alertFormatStr = @"The address '%@' is not responding.";
		goto exit;
	}

exit:
	if (alertMessage)
	{
		[NetUtilities showError:alertTitle
		 formatStr:alertFormatStr
		   message:alertMessage
			  code:0 		// errorCode
 popViewController:YES];
	}
	
	return result;
}
	
// isIPAddressOnLocalNetwork
// Return YES if the specified address is on any active network interface.
// We look at any of the "enN" interfaces, which should cover any ethernet or wifi connections

+(BOOL)isIPAddressOnLocalNetwork:(NSString*)testIpAddr
{
//	CFTimeInterval startTime = CACurrentMediaTime();

	BOOL retVal = NO;
	struct in_addr inAddr, ipAddr, netMask;
	struct ifaddrs* interfaces = NULL;
	struct ifaddrs* tempAddr = NULL;
	
	// First strip out port number if it's there
	
	NSUInteger index = [testIpAddr rangeOfString:@":"].location;
	if (index != NSNotFound)
		testIpAddr = [testIpAddr substringToIndex:index];
	
	// Now convert our address (only ip4 addresses here) to binary form
	
	if (inet_aton (testIpAddr.UTF8String, &inAddr) != 0)		// If 0, then failed
	{
		// Retrieve the current interfaces - returns 0 on success
		
		if (getifaddrs (&interfaces) == 0)
		{
			tempAddr = interfaces;
			
			while (tempAddr != NULL)
			{
				// Check if interface is any of the "enX" ones which would be in use
				
				if (tempAddr->ifa_addr->sa_family == AF_INET)
				{
					if (tempAddr->ifa_name[0] == 'e' && tempAddr->ifa_name[1] == 'n')
					{
						// Using the net mask, see if this ip is the same as input address
						
						ipAddr = (((struct sockaddr_in*)tempAddr->ifa_addr)->sin_addr);
						netMask = (((struct sockaddr_in*)tempAddr->ifa_netmask)->sin_addr);

						if ((inAddr.s_addr & netMask.s_addr) == (ipAddr.s_addr & netMask.s_addr))
						{
							retVal = YES;
							break;
						}
					}
				}
				
				tempAddr = tempAddr->ifa_next;
			}
			
			freeifaddrs (interfaces);
		}
	}
	
//	CFTimeInterval endTime = CACurrentMediaTime();
//	NSLog(@"isIPAddressOnLocalNetwork Runtime: %g usec", (endTime - startTime) * 1e6);

	return retVal;
}

// isHostValid
// Test to see if the host at addr/port is valid by attempting to open a
// TCP connection to it.  A time error (ETIMEDOUT) is returned if no connection
// can be made with timeout seconds.
// This is done with low level socket type calls.
// Returns 0 if successful or an positive errno type error if there's a problem or
// possibly -1 if other errors occur.  Errors of 1000+ are from gethostbyname

+(int)isHostValid:(NSString*)addr port:(int)port timeout:(int)timeout;
{
	int result = 0;
	int socketfd;
	struct sockaddr_in serverAddr;
	struct hostent* server;
	struct timeval timeoutVal;
	int options;

	// Set up timeval
	
	timeoutVal.tv_sec = timeout;
	timeoutVal.tv_usec = 0;
	
	// Create a socket point
	
	socketfd = socket (AF_INET, SOCK_STREAM, 0);

	if (socketfd < 0)
	{
		result = -1;
		goto exit;
	}
	
	// Set socket to be non-blocking by setting its option via fcntl

	if ((options = fcntl (socketfd, F_GETFL, NULL)) < 0)
	{
		result = errno;
		goto exit;
	}

	if (fcntl (socketfd, F_SETFL, options | O_NONBLOCK) < 0)
	{
		result = errno;
		goto exit;
	}

	// Set up our hostent for use by

	server = gethostbyname (addr.UTF8String);

	if (server == NULL)
	{
		result = 1000 + h_errno;
		goto exit;
	}

	bzero ((char*) &serverAddr, sizeof(serverAddr));
	serverAddr.sin_family = AF_INET;
	bcopy ((char*)server->h_addr, (char*)&serverAddr.sin_addr.s_addr, server->h_length);
	serverAddr.sin_port = htons (port);

	// Now try to connect to the server, waiting until it connects (writable) or times out
	
	if ((result = connect (socketfd, (struct sockaddr*)&serverAddr, sizeof(serverAddr))) < 0)
	{
		if (errno == EINPROGRESS)		// This would be the normal condition
		{
			fd_set wait_set;

			// Make file descriptor set with socket
			
			FD_ZERO (&wait_set);
			FD_SET (socketfd, &wait_set);

			// Wait for socket to be writable; return after given timeout
			
			result = select (socketfd + 1, NULL, &wait_set, NULL, &timeoutVal);

			// Set our result based on select result
			
			if (result == 0)			// Timeout
				result = ETIMEDOUT;
			
			else if (result < 0)		// Error
				result = errno;
			
			else						// Positive number (probably 1) is success
				result = 0;
		}
	}
	
	// Reset socket flags
	
	if (fcntl (socketfd, F_SETFL, options) < 0)
	{
		result = errno;
		goto exit;
	}

	// If successful, check for errors in socket layer
	
	if (result == 0)
	{
		socklen_t len = sizeof (options);
		
		if (getsockopt (socketfd, SOL_SOCKET, SO_ERROR, &options, &len) < 0)
		{
			result = errno;
			goto exit;
		}

		// There was an error
		
		if (options)
		{
			result = options;
			goto exit;
		}
	}

exit:
	
	if (socketfd > 0)
		close (socketfd);
	
	return result;
}

//	showError
//	Show an error alert.
//	If formatStr is nil, then just use message for message/informative text.
//	Otherwise, create a string using format string, message, and code.

+ (void)showError:(NSString*)title
		formatStr:(NSString*)formatStr
		  message:(NSString*)message
			 code:(NSInteger)code
popViewController:(BOOL)popViewController	// iOS only
{
	// For iOS, use UIAlertController, which requires the source UIViewController to present it

	UIViewController* rootViewController = [NetUtilities rootViewController];

	// If we have a format string, use that to create the message

	if (formatStr)
	{
		message = [NSString stringWithFormat:formatStr, message, code];
	}

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
																   message:message
															preferredStyle:UIAlertControllerStyleAlert];

	// Our single Dismiss action will optionaly pop the view controller

	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Dismiss"
													   style:UIAlertActionStyleCancel
													 handler:^(UIAlertAction *action)
	{
		if (popViewController)
			[rootViewController.navigationController popViewControllerAnimated:YES];
	}];

	[alert addAction:okAction];

	// Use calculated view controller to present this

	[rootViewController presentViewController:alert
									 animated:YES
								   completion:nil];
}

+ (UIViewController *)rootViewController
{
	UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
	if([rootViewController isKindOfClass:[UINavigationController class]])
		rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
	if([rootViewController isKindOfClass:[UITabBarController class]])
		rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
	if (rootViewController.presentedViewController != nil)
		rootViewController = rootViewController.presentedViewController;
	return rootViewController;
}

@end
