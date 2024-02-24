import UIKit

final class TabBarController: UITabBarController {
    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "statisticsTabBarItem"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        let userModel = RatingModel()
        let ratingViewModel = RatingViewModel(for: userModel)
        let ratingViewController = UINavigationController(
            rootViewController: RatingViewController(
                viewModel: ratingViewModel
            )
        )
        ratingViewController.tabBarItem = statisticsTabBarItem

        viewControllers = [catalogController, ratingViewController]

        view.backgroundColor = .systemBackground
    }
}
