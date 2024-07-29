//
//  IngredientsController.swift
//  MealRecipes
//
//  Created by Oleksandr on 7/28/24.
//

import UIKit

protocol IngredientsViewProtocol: AnyObject {
}

final class IngredientsController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private var meal: MealDetailModel?
    
    var presenter: IngredientsPresenterProtocol?
    
    init(meal: MealDetailModel?) {
        self.meal = meal
        super.init(nibName: "IngredientsController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

//MARK: - Setup
private extension IngredientsController {
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTable()
        
        titleLabel.text = "sdfsd"
    }
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IngredientsCell", bundle: nil), forCellReuseIdentifier: "IngredientsCell")
        tableView.showsVerticalScrollIndicator = false
    }
}

//MARK: - UITableViewDelegate
extension IngredientsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Sections.allCases[indexPath.section] {
        case .instructions: return UITableView.automaticDimension
        case .ingredients: return 60
        }
    }
}

//MARK: - UITableViewDataSource
extension IngredientsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections.allCases[section] {
        case .instructions: return 1
        case .ingredients:
            guard let meal = self.meal else { return 0 }
            
            return self.presenter?.getRows(meal: meal).count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath) as? IngredientsCell else { return UITableViewCell() }
        
        switch Sections.allCases[indexPath.section] {
        case .instructions:
            if let instruction = self.meal?.mealsIngredients?.meals.first?[nameKeyOfInstructions] {
                cell.titleLabel.text = instruction ?? "No data"
            }
        case .ingredients:
            if let meal = meal, let details = self.presenter?.getRows(meal: meal)[indexPath.row] {
                let ingredient = details.0
                let measure = details.1
                
                cell.titleLabel.text = "\(ingredient): \(measure)"
            } else {
                cell.titleLabel.text = "No data"
            }

        }
        
        return cell
    }
}

//MARK: - IngredientsViewProtocol
extension IngredientsController: IngredientsViewProtocol {

}

//MARK: - Sections
private extension IngredientsController {
    enum Sections: Int, CaseIterable {
        case instructions, ingredients
        
        var title: String {
            switch self {
            case .instructions: return "Instructions"
            case .ingredients: return "Ingredients/measurements"
            }
        }
    }
}

