//
//  MealsController.swift
//  MealRecipes
//
//  Created by Oleksandr on 7/28/24.
//

import UIKit
import Combine

protocol MealsViewProtocol: AnyObject {
    func updateDataTable(data: MealsModel?)
    func updateCellMealIngredients(id: String)
}

final class MealsController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @Published private var mealsData: MealsModel?
    private var cancellables = Set<AnyCancellable>()
    
    private var isMainDataDownloaded = false
    
    var presenter: MealsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        presenter?.loadMeals()
    }
}

//MARK: - Setup
private extension MealsController {
    func setup() {
        setupUI()
        bindTableView()
    }
    
    func setupUI() {
        setupTableView()
        
        activityIndicator.startAnimating()
        
        titleLabel.text = "Meals"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MealCell", bundle: nil), forCellReuseIdentifier: "MealCell")
        tableView.showsVerticalScrollIndicator = false
    }
    
    func bindTableView() {
        $mealsData.receive(on: DispatchQueue.main).dropFirst().sink { [weak self] _ in
            if !(self?.isMainDataDownloaded ?? false) {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.isMainDataDownloaded = true
            }
        }.store(in: &cancellables)
    }
}

//MARK: - MealsViewProtocol
extension MealsController: MealsViewProtocol {
    func updateDataTable(data: MealsModel?) {
        self.mealsData = data
    }
    
    func updateCellMealIngredients(id: String) {
        guard let meals = mealsData?.meals else { return }
        
        for (index, meal) in meals.enumerated() {
            if meal.idMeal == id {
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MealCell
                cell?.activityIndicator.stopAnimating()
                
                return
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension MealsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mealsData?.meals[indexPath.row].mealsIngredients != nil {
            let controller = IngredientsController(meal: self.mealsData?.meals[indexPath.row])
            let presenter = IngredientsPresenter(view: controller)
            controller.presenter = presenter
            
            self.present(controller, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource
extension MealsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mealsData = mealsData?.meals else { return 0 }
        
        return mealsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as? MealCell else { return UITableViewCell() }
        
        if let mealData = mealsData?.meals[indexPath.row] {
            if let imageData = mealData.imageMealData, let image = UIImage(data: imageData) {
                cell.setupData(image: image, title: mealData.strMeal)
            } else {
                let defaultImage = #imageLiteral(resourceName: "question-sign")
                cell.setupData(image: defaultImage, title: mealData.strMeal)
            }
            
            if mealData.mealsIngredients == nil {
                cell.activityIndicator.startAnimating()
            } else {
                cell.activityIndicator.stopAnimating()
            }
        }
        
        return cell
    }
}
