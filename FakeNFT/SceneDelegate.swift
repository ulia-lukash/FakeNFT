import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        
        configureInitialViewController()
    }
    
    private func configureInitialViewController() {

        let defaults = UserDefaults.standard
        let initialViewController: UIViewController

        if !defaults.bool(forKey: "SkippedUnboarding") {
                        
            let transitionStyle = UIPageViewController.TransitionStyle.scroll
            let navOrientation = UIPageViewController.NavigationOrientation.horizontal
            let onboardingController = OnboardingViewController(transitionStyle: transitionStyle, navigationOrientation: navOrientation, options: nil)
            initialViewController = onboardingController
        } else {
            let tabBarController = TabBarController()
            tabBarController.servicesAssembly = servicesAssembly
            initialViewController = tabBarController
        }
        self.window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}
