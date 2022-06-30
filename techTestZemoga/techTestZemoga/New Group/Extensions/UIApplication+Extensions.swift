//
//  UIApplication+Extensions.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import UIKit

extension UIApplication {
    /// Function to get the view controllers that is showing at the moment
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
