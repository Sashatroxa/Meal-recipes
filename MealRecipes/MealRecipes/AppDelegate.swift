//
//  AppDelegate.swift
//  MealRecipes
//
//  Created by Oleksandr on 7/28/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let firstController = MealsController()
        let presenter = MealsPresenter(view: firstController)
        firstController.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: firstController)
        navigationController.navigationBar.isHidden = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        return true
    }
}

