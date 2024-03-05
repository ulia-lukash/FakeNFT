//
//  ErrorAlertPresenter.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 23.02.2024.
//

import UIKit

protocol ErrorAlertPresenterProtocol: AnyObject {
    func showAlert(model: ErrorAlertModel)
}

final class ErrorAlertPresenter: ErrorAlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(model: ErrorAlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let actionFirst = UIAlertAction(
            title: model.actionSheetTextFirst,
            style: .cancel) { _ in
                model.completionFirst()
            }
        
        let actionSecond = UIAlertAction(
            title: model.actionSheetTextSecond,
            style: .default) { _ in
                model.completionSecond()
            }
        alert.addAction(actionFirst)
        alert.addAction(actionSecond)
        alert.preferredAction = actionSecond
        delegate?.present(alert, animated: true)
    }
}
