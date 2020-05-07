#import "AppDelegate.h"
#import "iperf-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    UIWindow *window = [[UIWindow alloc] initWithFrame:windowFrame];

    // Tab 1
    IPFTestRunnerViewController *testRunnerViewController = [IPFTestRunnerViewController new];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:testRunnerViewController];
    navigationController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TestRunner.title", nil) image:[UIImage imageNamed:@"SpeedTest"] tag:0];

    // Tab 2
    IPFTestResultsViewController *testResultsViewController = [IPFTestResultsViewController new];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:testResultsViewController];
    navigationController2.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TestResults.title", nil) image:[UIImage imageNamed:@"Results"] tag:1];

    // Tab 3
    IPFSettingsViewController *settingsViewController = [IPFSettingsViewController new];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    navigationController3.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Settings.title", nil) image:[UIImage imageNamed:@"Settings"] tag:1];

    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[navigationController1, navigationController2, navigationController3];

    window.rootViewController = tabBarController;
    [window makeKeyAndVisible];
    self.window = window;

    return YES;
}

@end
