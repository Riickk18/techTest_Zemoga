//
//  PostDetailViewController.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import UIKit
import RxSwift

class PostDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButtonBar: UIBarButtonItem!
    
    //MARK: - ViewModel
    var viewModel: PostDetailViewModel!
    let disposeBag = DisposeBag()
    
    //MARK: - Variables
    let originalInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initOutlets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
        handleViewModelErrors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.initCells()
        viewModel.getUserData()
    }
    
    private func initOutlets(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TitleAndDescriptionViewCell.nib(), forCellReuseIdentifier: TitleAndDescriptionViewCell.identifier)
        tableView.register(CommentViewCell.nib(), forCellReuseIdentifier: CommentViewCell.identifier)
        tableView.contentInset = originalInsets
    }
    
    private func bindViewModel(){
        viewModel.output.isAnimating
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if value{
                    self?.activityIndicator?.startAnimating()
                }else{
                    self?.activityIndicator?.stopAnimating()
                }
            }).disposed(by: disposeBag)
        viewModel.output.updateTable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        viewModel.output.favoriteIcon
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.favoriteButtonBar.image = image
            }).disposed(by: disposeBag)
    }
    
    private func handleViewModelErrors() {
        viewModel.onShowInfoAlert = { [weak self] message, title in
            if let alertTitle = title {
                self?.showAlert(title: alertTitle, message: message)
            } else {
                self?.showAlert(message: message)
            }
        }
    }
    
    @IBAction func updateFavoriteStatus(_ sender: Any) {
        viewModel.updateFavoriteStatus()
    }

    @IBAction func deleteAction(_ sender: Any) {
        viewModel.deletePost {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.dataCells.count
        }
        return viewModel.commentsCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndDescriptionViewCell.identifier, for: indexPath) as! TitleAndDescriptionViewCell
            cell.configure(with: viewModel.dataCells[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewCell.identifier, for: indexPath) as! CommentViewCell
        cell.configure(with: viewModel.commentsCells[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || viewModel.commentsCells.count == 0 { return nil }
        let stackView = UIStackView.init(frame: CGRect.init(x: 10, y: 10, width: tableView.frame.width - 10, height: 30))
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .systemBackground
        stackView.spacing = 10
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 15, height: 15))
        imageView.image = UIImage(systemName: "text.bubble.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 129, green: 46, blue: 222, alpha: 1)
        stackView.addArrangedSubview(imageView)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30)
        stackView.addConstraints([widthConstraint])

        let label = UILabel()
        label.text = "Comments"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: "tintNavBarColor")
        
        stackView.addArrangedSubview(label)
        
        return stackView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || viewModel.commentsCells.count == 0 { return 0 }
        return 50
    }
}
