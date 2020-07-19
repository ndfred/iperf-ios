import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    let store: IPFTestResultsStoreType = IPFTestResultsStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var window: UIWindow?

        let testRunner = IPFTestRunnerViewController()
        testRunner.store = store
        testRunner.tabBarItem = UITabBarItem(title: NSLocalizedString("TestRunner.title", comment: ""), image: UIImage(named: "speedometer"), tag: 0)

        let testResults = IPFTestResultsViewController()
        testResults.store = store
        testResults.tabBarItem = UITabBarItem(title: NSLocalizedString("TestResults.title", comment: ""), image: UIImage(named: "clock"), tag: 1)

        let settings = IPFSettingsViewController()
        settings.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings.title", comment: ""), image: UIImage(named: "gear"), tag: 2)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [testRunner, testResults, settings].map { UINavigationController(rootViewController: $0) }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        store.save()
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        store.save()
    }

}
