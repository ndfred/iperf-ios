#import "AppDelegate.h"
#import "IPFTestRunnerViewController.h"
#import "iperf-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    UIWindow *window = [[UIWindow alloc] initWithFrame:windowFrame];

    // Tab 1
    IPFTestRunnerViewController *testRunnerViewController = [[IPFTestRunnerViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:testRunnerViewController];
    navigationController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SpeedTest" image:[UIImage imageNamed:@"SpeedTest"] tag:0];

    IPFTestRunnerViewControllerV2 *testRunnerViewControllerv2 = [IPFTestRunnerViewControllerV2 new];
    UINavigationController *navigationController1v2 = [[UINavigationController alloc] initWithRootViewController:testRunnerViewControllerv2];
    navigationController1v2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SpeedTest" image:[UIImage imageNamed:@"SpeedTest"] tag:0];

    // Tab 2
    IPFTestResultsViewController *testResultsViewController = [IPFTestResultsViewController new];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:testResultsViewController];
    navigationController2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Results" image:[UIImage imageNamed:@"Results"] tag:1];

    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[navigationController1, navigationController1v2, navigationController2];

    window.rootViewController = tabBarController;
    [window makeKeyAndVisible];
    self.window = window;

    return YES;
}

@end
