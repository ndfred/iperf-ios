import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var window: UIWindow?

        let testRunner = UINavigationController(rootViewController: IPFTestRunnerViewController())
        testRunner.tabBarItem = UITabBarItem(title: NSLocalizedString("TestRunner.title", comment: ""), image: UIImage(named: "SpeedTest"), tag: 0)
        let testResults = UINavigationController(rootViewController: IPFTestResultsViewController())
        testResults.tabBarItem = UITabBarItem(title: NSLocalizedString("TestResults.title", comment: ""), image: UIImage(named: "Results"), tag: 1)
        let settings = UINavigationController(rootViewController: IPFSettingsViewController())
        settings.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings.title", comment: ""), image: UIImage(named: "Settings"), tag: 2)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [testRunner, testResults, settings]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()

        return true
    }

}
