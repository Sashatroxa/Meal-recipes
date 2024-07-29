//
//  IngredientsPresenter.swift
//  MealRecipes
//
//  Created by Oleksandr on 7/28/24.
//

import Foundation

protocol IngredientsPresenterProtocol: AnyObject {
    func getRows(meal: MealDetailModel) -> [(String, String)]
}

final class IngredientsPresenter {
    private weak var view: IngredientsViewProtocol?
    
    init(view: IngredientsViewProtocol) {
        self.view = view
    }
    
    private func getRowsForIngredients(meal: MealDetailModel) -> [(String, String)] {
        guard let mealDetails = meal.mealsIngredients?.meals.first else { return [] }
        
        let ingredients = (1...maxNumberOfIngredients).compactMap { index in
            mealDetails["\(nameKeyOfIngredient)\(index)"] as? String
        }
        
        let measures = (1...maxNumberOfIngredients).compactMap { index in
            mealDetails["\(nameKeyOfMeasure)\(index)"] as? String
        }
        
        let nonEmptyIngredients = ingredients.enumerated().compactMap { index, ingredient in
            ingredient.isEmpty ? nil : (ingredient, measures[index])
        }
        
        return nonEmptyIngredients
    }
}

//MARK: - IngredientsPresenterProtocol
extension IngredientsPresenter: IngredientsPresenterProtocol {
    func getRows(meal: MealDetailModel) -> [(String, String)] {
        return getRowsForIngredients(meal: meal)
    }
}
