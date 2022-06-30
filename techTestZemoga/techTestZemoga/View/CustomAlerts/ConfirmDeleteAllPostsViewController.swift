//
//  ConfirmDeleteAllPostsViewController.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import UIKit

protocol ConfirmDeleteAllPostsViewControllerDelegate: AnyObject {
    func acceptPressed()
}

class ConfirmDeleteAllPostsViewController: UIViewController {

    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var alertContainerView: UIView!
    @IBOutlet weak var alertContainerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptButton: UIButton!
    
    weak var delegate: ConfirmDeleteAllPostsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initOutlets()
        // Do any additional setup after loading the view.
    }
    
    func initOutlets() {
        visualEffect.effect = nil
        alertContainerView.layer.cornerRadius = 10
        acceptButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if alertContainerYConstraint.constant != 0 {
            alertContainerYConstraint.constant = UIScreen.main.bounds.height
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if alertContainerYConstraint.constant == 0 {
            self.alertContainerYConstraint.constant = 0
            if animated {
                UIView.animate(withDuration: 0.4) {
                    self.visualEffect.effect = UIBlurEffect(style: .systemThinMaterialDark)
                }
                UIView.animate(withDuration: 0.6,
                               delay: 0,
                               usingSpringWithDamping: 1.0,
                               initialSpringVelocity: 0.1,
                               options: [.allowUserInteraction, .beginFromCurrentState],
                               animations: {
                                self.view.layoutIfNeeded()
                               }, completion: nil)
            }
        }
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        delegate?.acceptPressed()
        animateOutAndDismiss()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        animateOutAndDismiss()
    }
    
    func animateOutAndDismiss() {
        self.alertContainerYConstraint.constant = self.view.frame.height * 1.5
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
            self.visualEffect.effect = nil
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    

}
