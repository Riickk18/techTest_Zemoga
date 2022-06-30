//
//  PostViewCell.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import UIKit
import RxSwift

class PostViewCell: UITableViewCell {
    
    //MARK: - Static items
    static let identifier: String = "PostViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "PostViewCell", bundle: nil)
    }
    
    //MARK: - Outlets
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - ViewModel
    var viewModel: PostViewModel!
    let disposeBag = DisposeBag()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusIcon.image = nil
        titleLabel.text = nil
    }
    
    func configure(with viewModel: PostViewModel){
        self.viewModel = viewModel
        viewModel.output.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.status
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (wasRead, isFavorite) in
                self?.statusIcon.image = {
                    if isFavorite && !wasRead {
                        return UIImage(systemName: "star.circle.fill")
                    } else if isFavorite && wasRead {
                        return UIImage(systemName: "star.circle")
                    } else if !isFavorite && !wasRead {
                        return UIImage(systemName: "circle.fill")
                    } else {
                        return nil
                    }
                }()
            }).disposed(by: disposeBag)
    }
    
    func updateStateToSeen(postId: Int) {
        viewModel.updateStateToSeen(postId: postId)
    }
    
}
