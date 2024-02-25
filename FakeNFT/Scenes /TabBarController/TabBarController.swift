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
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: ConstLocalizable.basket,
        image: UIImage(named: "BasketNoActive"),
        tag: 1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [catalogController, createBasketViewController()]
        
        view.backgroundColor = .systemBackground
    }
    
    func createBasketViewController() -> UINavigationController {
        let basketController = BasketViewController(viewModel: basketViewModel, paymentViewModel: paymentViewModel)
        basketController.tabBarItem = basketTabBarItem
        return UINavigationController(rootViewController: basketController)
    }
}
