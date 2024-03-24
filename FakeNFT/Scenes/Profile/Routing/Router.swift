//
//  Router.swift
//  FakeNFT
//
//  Created by Григорий Машук on 1.03.24.
//

import UIKit

final class Router: BaseRouter {
    /*коментарий для ревью: не совсем уверен в правильности всего,
     что написано в этих методах. буду благодарен за пару советов)*/
    func showMyNft(profile: Profile) {
        guard let sourceVc = sourceViewController as? ProfileViewController
        else { return }
        let service = MyNFTServiceIml(networkClient: DefaultNetworkClient(),
                                      storage: MyNftStorageImpl())
        let viewModel = MyNftViewModel(service: service)
        let rootController = MyNFTViewController(viewModel: viewModel)
        rootController.delegate = sourceVc
        sourceVc.myNftDelegate = rootController
        sourceVc.myNftDelegate?.setProfile(model: profile, vc: sourceVc)
        sourceVc.navigationController?.pushViewController(rootController, animated: true)
    }
    
    func showFavarite() {
        let favoriteAssembly = FavoriteAssembly(
            service: FavoriteNftServiceImp(networkClient: DefaultNetworkClient()))
        guard let vc = favoriteAssembly.build() as? FavoriteViewController,
            let sourceVc = sourceViewController as? ProfileViewController
              else { return }
        sourceVc.favoriteDelegate = vc
        vc.delegate = sourceVc
        sourceVc.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showWebView(request: URLRequest) {
        guard let soursVc = sourceViewController else { return }
        let webViewController = ProfileWebViewController()
        webViewController.load(request: request)
        let navController = UINavigationController(rootViewController: webViewController)
        navController.modalPresentationStyle = .fullScreen
        webViewController.showIndicator()
        soursVc.present(navController, animated: true)
    }
}
