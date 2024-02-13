import UIKit
import ProgressHUD

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        setUpProgreeHUD()
        let tabBarController = window?.rootViewController as? TabBarController
        tabBarController?.servicesAssembly = servicesAssembly
    }

    private func setUpProgreeHUD() {
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.colorAnimation = .blueUniversal
    }
}
