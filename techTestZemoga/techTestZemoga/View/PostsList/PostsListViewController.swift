//
//  PostsListViewController.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import UIKit
import RxSwift

class PostsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteAllPostsButton: UIButton!
    
    let viewModel: PostsListViewModel = PostsListViewModel()
    let disposeBag = DisposeBag()
    let originalInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    var refreshControl: UIRefreshControl?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initOutlets()
        bindViewModel()
        handleViewModelErrors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getPostsFromDb()
    }
    
    private func initOutlets(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostViewCell.nib(), forCellReuseIdentifier: PostViewCell.identifier)
        tableView.contentInset = originalInsets
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        deleteAllPostsButton.layer.cornerRadius = deleteAllPostsButton.bounds.width / 2
    }
    
    private func bindViewModel(){
        viewModel.output.isAnimating
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if value{
                    self?.refreshControl?.beginRefreshing()
                }else{
                    self?.refreshControl?.endRefreshing()
                }
            }).disposed(by: disposeBag)
        viewModel.output.updateTable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.deleteAllPostsButton.isHidden = self?.viewModel.cells.count == 0
            }).disposed(by: disposeBag)
        viewModel.getPosts()
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

    @objc
    func refreshPosts(refreshControl: UIRefreshControl) {
        viewModel.getPosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PostDetailViewController":
            guard let destinationVC = segue.destination as? PostDetailViewController, let viewModel = sender as? PostDetailViewModel else {return}
            destinationVC.viewModel = viewModel
        case "ConfirmDeleteAllPostsViewController":
            guard let destinationVC = segue.destination as? ConfirmDeleteAllPostsViewController else {return}
            destinationVC.delegate = self
        default: break
        }
    }
    
    @IBAction func deleteAllPosts(_ sender: Any) {
        performSegue(withIdentifier: "ConfirmDeleteAllPostsViewController", sender: nil)
    }
}

extension PostsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostViewCell.identifier, for: indexPath) as! PostViewCell
        cell.configure(with: viewModel.cells[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? PostViewCell, let postId = cell.viewModel.postId else { return }
        cell.updateStateToSeen(postId: postId)
        self.performSegue(withIdentifier: "PostDetailViewController", sender: PostDetailViewModel(postId: postId))
    }
}

extension PostsListViewController: ConfirmDeleteAllPostsViewControllerDelegate {
    func acceptPressed() {
        viewModel.deleteAllPosts()
    }
}
