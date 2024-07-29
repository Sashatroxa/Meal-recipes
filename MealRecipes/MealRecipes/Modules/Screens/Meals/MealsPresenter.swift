//
//  MealsPresenter.swift
//  MealRecipes
//
//  Created by Oleksandr on 7/28/24.
//

import Foundation

protocol MealsPresenterProtocol: AnyObject {
    func loadMeals()
}

final class MealsPresenter {
    private weak var view: MealsViewProtocol?
    
    init(view: MealsViewProtocol) {
        self.view = view
    }
    
    private func fetchMealsByCategory(category: String) async throws -> MealsModel? {
        let mealsStringURL = "https://themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        
        guard let url = URL(string: mealsStringURL) else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let jsonData = try JSONDecoder().decode(MealsModel.self, from: data)
        
        return jsonData
    }
    
    private func fetchMealImage(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    private func fetchIngredientsByMealId(id: String) async throws -> IngredientsModel? {
        let mealIngredientsStringURL = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        
        guard let url = URL(string: mealIngredientsStringURL) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let jsonData = try JSONDecoder().decode(IngredientsModel.self, from: data)
        
        return jsonData
    }
    
    @MainActor
    private func updateData(data: MealsModel?) {
        view?.updateDataTable(data: data)
    }
    
    @MainActor
    private func updateMealIngredientsById(id: String) {
        view?.updateCellMealIngredients(id: id)
    }
}

//MARK: - MealsPresenterProtocol
extension MealsPresenter: MealsPresenterProtocol {
    func loadMeals() {
        Task {
            do {
                guard var data = try await fetchMealsByCategory(category: mealsCategory) else { return }
                
                data.meals = data.meals.sorted{ $0.strMeal < $1.strMeal }
                
                for index in 0..<data.meals.count {
                    let imageData = try await fetchMealImage(urlString: data.meals[index].strMealThumb)
                    data.meals[index].imageMealData = imageData
                }
                
                await updateData(data: data)
                
                for (index, meal) in data.meals.enumerated() {
                    guard let mealIngredients = try await fetchIngredientsByMealId(id: meal.idMeal) else { return }
                    data.meals[index].mealsIngredients = mealIngredients
                    
                    await updateData(data: data)
                    await updateMealIngredientsById(id: meal.idMeal)
                }
            } catch {
                print("Failed to fetch meals: \(error)")
            }
        }
    }
}
