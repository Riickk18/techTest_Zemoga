//
//  UIViewController+Extensions.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import UIKit

extension UIViewController {
    /// Function to show an UIAlert from anywhere
    func showAlert(title: String = "ERROR", message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Accept", style: .cancel, handler: nil)
            alert.addAction(action)
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
