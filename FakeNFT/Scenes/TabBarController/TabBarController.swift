import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    let basketViewModel = BasketViewModel(
        service: BasketService(
            networkClient: DefaultNetworkClient()
        ),
        storage: StorageManager()
    )
    
    let paymentViewModel = PaymentViewModel(
        service: PaymentService(
            networkClient: DefaultNetworkClient()
        )
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString(ConstLocalizable.tabProfile, comment: ""),
        image: UIImage(named: "profilActive"),
        tag: 0
    )

    let catalogViewModel = CatalogViewModel(
            service: CollectionServiceImpl(networkClient: DefaultNetworkClient(),
            storage: CollectionStorageImpl()))
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.fill"),
        tag: 1
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: ConstLocalizable.basket,
        image: UIImage(named: "BasketNoActive"),
        tag: 2
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = createCatalogController()
        
        let profileViewModel = ProfileViewModel(service: ProfileServiceImpl(networkClient: DefaultNetworkClient(),
                                                                     storage: ProfileStorageImpl()))
        let profileController = ProfileViewController(viewModel: profileViewModel)
        
        profileController.tabBarItem = profileTabBarItem
        
        viewControllers = [profileController, catalogController, createBasketViewController()]
        
        view.backgroundColor = .systemBackground
    }
    
    func createBasketViewController() -> UINavigationController {
        let basketController = BasketViewController(viewModel: basketViewModel, paymentViewModel: paymentViewModel)
        basketController.tabBarItem = basketTabBarItem
        return UINavigationController(rootViewController: basketController)
    }

    func createCatalogController() -> UINavigationController {
        let rootController = CatalogViewController(viewModel: catalogViewModel)
        let catalogController = UINavigationController(rootViewController: rootController)
        catalogController.modalPresentationStyle = .fullScreen
        catalogController.tabBarItem = catalogTabBarItem
        return catalogController
    }
}
