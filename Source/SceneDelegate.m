#import "SceneDelegate.h"
#import "IPFTestRunnerViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }

    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    IPFTestRunnerViewController *viewController = [[IPFTestRunnerViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    window.rootViewController = navigationController;
    self.window = window;
    [window makeKeyAndVisible];
}

@end
