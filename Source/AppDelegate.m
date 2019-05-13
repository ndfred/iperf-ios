#import "AppDelegate.h"
#import "IPFTestRunnerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  CGRect windowFrame = [[UIScreen mainScreen] bounds];
  UIWindow *window = [[UIWindow alloc] initWithFrame:windowFrame];
  IPFTestRunnerViewController *viewController = [[IPFTestRunnerViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

  window.rootViewController = navigationController;
  [window makeKeyAndVisible];
  self.window = window;

  return YES;
}

@end
