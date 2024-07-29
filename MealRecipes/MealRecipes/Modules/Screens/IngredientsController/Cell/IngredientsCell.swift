//
//  IngredientsCell.swift
//  MealRecipes
//
//  Created by Oleksandr on 7/28/24.
//

import UIKit

final class IngredientsCell: UITableViewCell {
    @IBOutlet private(set) weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
}

//MARK: - Setup
private extension IngredientsCell {
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        titleLabel.textColor = .black
    }
}
