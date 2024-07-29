//
//  MealCell.swift
//  MealRecipes
//
//  Created by Oleksandr on 7/28/24.
//

import UIKit

final class MealCell: UITableViewCell {
    @IBOutlet private weak var mealImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
}

//MARK: - Open methods
extension MealCell {
    func setupData(image: UIImage?, title: String) {
        mealImageView.image = image
        titleLabel.text = title
    }
}

//MARK: - Setup
private extension MealCell {
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        selectionStyle = .none
        
        activityIndicator.startAnimating()
        mealImageView.layer.cornerRadius = 5
    }
}
