//
//  FavoriteAssembly.swift
//  FakeNFT
//
//  Created by Григорий Машук on 27.02.24.
//

import UIKit

public final class FavoriteAssembly {
    private let service: FavoriteNftServiceProtocol
    
    init(service: FavoriteNftServiceProtocol) {
        self.service = service
    }
    
    public func build() -> UIViewController {
        let viewModel = FavoriteViewModel(
            service: FavoriteNftServiceImp(networkClient: DefaultNetworkClient()))
        let viewController = FavoriteViewController(viewModel: viewModel)
        return viewController
    }
}
