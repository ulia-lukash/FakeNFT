import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let tabBarController = window?.rootViewController as? TabBarController
        tabBarController?.servicesAssembly = servicesAssembly
        window?.rootViewController = tabBarController
    }
}
