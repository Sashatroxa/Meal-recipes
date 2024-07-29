//
//  MealsModel.swift
//  MealRecipes
//
//  Created by Oleksandr on 7/28/24.
//

import Foundation

struct MealsModel: Codable {
    var meals: [MealDetailModel]
}

struct MealDetailModel: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    var imageMealData: Data? = nil
    var mealsIngredients: IngredientsModel? = nil
}
