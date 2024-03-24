//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 03.03.2024.
//

import Foundation
import UIKit

final class OnboardingViewController: UIPageViewController {
    lazy private var pages: [UIViewController] = {
        
        let button: UIButton = {
            let button = UIButton()
            button.setTitle(NSLocalizedString("What's inside?", comment: ""), for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = 16
            button.backgroundColor = Asset.Colors.blackUniversal.color
            button.setTitleColor(Asset.Colors.whiteUniversal.color, for: .normal)
            return button
        }()
        let first = OnboardingViewControllerBase(imageName: "onboarding-1", titleLabelText: NSLocalizedString("OnboardingTitle1", comment: ""), labelText: NSLocalizedString("OnboardingCaption1", comment: ""), button: nil)
        let second = OnboardingViewControllerBase(imageName: "onboarding-2", titleLabelText: NSLocalizedString("OnboardingTitle2", comment: ""), labelText: NSLocalizedString("OnboardingCaption2", comment: ""), button: nil)
        let third = OnboardingViewControllerBase(imageName: "onboarding-3", titleLabelText: NSLocalizedString("OnboardingTitle3", comment: ""), labelText: NSLocalizedString("OnboardingCaption3", comment: ""), button: button)
        
        return [first, second, third]
    }()
    
    lazy private var pageControl = LinePageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        pageControl.numberOfItems = pages.count
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        setUpPageControl()
    }
    
    private func setUpPageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            pageControl.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.selectedItem = currentIndex
        }
    }
}
