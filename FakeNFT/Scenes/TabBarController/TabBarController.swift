import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString(ConstLocalizable.tabProfile, comment: ""),
        image: UIImage(named: "profilActive"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let profileViewModel = ProfileViewModel(service: ProfileServiceImpl(networkClient: DefaultNetworkClient(),
                                                                     storage: ProfileStorageImpl()))
        let profileController = ProfileViewController(viewModel: profileViewModel)
        
        catalogController.tabBarItem = catalogTabBarItem
        profileController.tabBarItem = profileTabBarItem

        viewControllers = [profileController, catalogController]

        view.backgroundColor = .systemBackground
    }
}
