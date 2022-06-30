//
//  TitleAndDescriptionViewCell.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import UIKit
import RxSwift

class TitleAndDescriptionViewCell: UITableViewCell {
    
    //MARK: - Static items
    static let identifier: String = "TitleAndDescriptionViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "TitleAndDescriptionViewCell", bundle: nil)
    }

    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    //MARK: - ViewModel
    var viewModel: TitleAndDescriptionViewModel!
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
        titleLabel.text = nil
        bodyLabel.text = nil
    }
    
    func configure(with viewModel: TitleAndDescriptionViewModel){
        self.viewModel = viewModel
        viewModel.output.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.body.drive(bodyLabel.rx.text).disposed(by: disposeBag)
    }
    
}
