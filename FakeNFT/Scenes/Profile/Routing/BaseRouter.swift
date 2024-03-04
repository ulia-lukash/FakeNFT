//
//  BaseRouter.swift
//  FakeNFT
//
//  Created by Григорий Машук on 1.03.24.
//

import UIKit

class BaseRouter{
    weak var sourceViewController: UIViewController?
    
    init(sourceViewController: UIViewController) {
        self.sourceViewController = sourceViewController
    }
}
 
