//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 18.02.2024.
//

import UIKit

protocol SortAlertPresenterProtocol: AnyObject {
    func showAlert(model: SortAlertModel)
}

final class SortAlertPresenter: SortAlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(model: SortAlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .actionSheet
        )
        let actionSheetFirst = UIAlertAction(
            title: model.actionSheetTextFirst,
            style: .default) { _ in
                model.completionFirst()
            }
        let actionSheetSecond = UIAlertAction(
            title: model.actionSheetTextSecond,
            style: .default) { _ in
                model.completionSecond()
            }
        let actionSheetThird = UIAlertAction(
            title: model.actionSheetTextThird,
            style: .default) { _ in
                model.completionThird()
            }
        let actionSheetCancel = UIAlertAction(
            title: model.actionSheetTextCancel,
            style: .cancel)
    
        alert.addAction(actionSheetFirst)
        alert.addAction(actionSheetSecond)
        alert.addAction(actionSheetThird)
        alert.addAction(actionSheetCancel)
        
        delegate?.present(alert, animated: true)
    }
}
