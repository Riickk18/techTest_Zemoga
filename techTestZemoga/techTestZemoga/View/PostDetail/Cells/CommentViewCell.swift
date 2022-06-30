//
//  CommentViewCell.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import UIKit
import RxSwift

class CommentViewCell: UITableViewCell {

    //MARK: - Static items
    static let identifier: String = "CommentViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "CommentViewCell", bundle: nil)
    }

    //MARK: - Outlets
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //MARK: - ViewModel
    var viewModel: CommentViewModel!
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
        commentLabel.text = nil
        emailLabel.text = nil
    }
    
    func configure(with viewModel: CommentViewModel){
        self.viewModel = viewModel
        viewModel.output.comment.drive(commentLabel.rx.attributedText).disposed(by: disposeBag)
        viewModel.output.email.drive(emailLabel.rx.text).disposed(by: disposeBag)
    }
}
