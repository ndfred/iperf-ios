#import "AppDelegate.h"
#import "IPFTestRunnerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Window setup moved to SceneDelegate
	
  return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application
		configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
																	 options:(UISceneConnectionOptions *)options {
	UISceneConfiguration *config =
			[[UISceneConfiguration alloc] initWithName:@"Default Configuration"
																		 sessionRole:connectingSceneSession.role];
	return config;
}

- (void)application:(UIApplication *)application
		didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
}

@end
