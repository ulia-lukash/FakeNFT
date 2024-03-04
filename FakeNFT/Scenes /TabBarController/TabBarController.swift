import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogViewModel = CatalogViewModel(
            service: CollectionServiceImpl(networkClient: DefaultNetworkClient(),
            storage: CollectionStorageImpl()))
        let rootController = CatalogViewController(viewModel: catalogViewModel)
        let catalogController = UINavigationController(rootViewController: rootController)
        catalogController.modalPresentationStyle = .fullScreen
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController]

        view.backgroundColor = .systemBackground
    }
}
