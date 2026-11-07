//
//  SceneDelegate.m
//  iperf
//
//  Created by Andy Peterman on 11/6/26.
//

#import "SceneDelegate.h"
#import "IPFTestRunnerViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
	if (![scene isKindOfClass:[UIWindowScene class]])
	{
		return;
	}
	UIWindowScene *windowScene = (UIWindowScene *)scene;

	UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
	IPFTestRunnerViewController *viewController =
			[[IPFTestRunnerViewController alloc] initWithNibName:@"ViewController"
																										bundle:[NSBundle mainBundle]];
	UINavigationController *navigationController =
			[[UINavigationController alloc] initWithRootViewController:viewController];

	window.rootViewController = navigationController;
	[window makeKeyAndVisible];
	self.window = window;
}

@end
