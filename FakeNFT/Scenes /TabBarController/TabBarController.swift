import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: "Корзина",
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
        let basketController = BasketViewController(
            servicesAssembly: servicesAssembly
        )
        basketController.tabBarItem = basketTabBarItem
        return UINavigationController(rootViewController: basketController)
    }
}
