//
//  DataGetter.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/24/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataGetter {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YaGotFoodDude")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    public static func getMeals(callback: ((_ meals: [Meal], _ error: NSError?) -> Void)) {
        print("boutta build request")
        let request = NSFetchRequest<Meal>(entityName: "Meal")

        do {
            print("boutta get meals")
            let meals = try persistentContainer.viewContext.fetch(request)
            print(meals)
            print("meals^")
            callback(meals, nil)
        } catch let error as NSError {
            callback([], error)
        }
    }
    
    private static func tryToGetIngredient(withName name: String) -> Ingredient? {
        let request = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        request.predicate = NSPredicate(format: "name like %@", name)
        var ingredient: Ingredient?
        do {
            let ingredients = try persistentContainer.viewContext.fetch(request)
            
            if ingredients.count > 0 {
                ingredient = ingredients[0]
            }
        } catch let error as NSError {
            print(error)
        }
        
        return ingredient
    }
    
    public static func saveMeal(_ mealName: String, madeOf ingredientNames: [String]) {
        let meal = Meal(context: persistentContainer.viewContext)
        meal.name = mealName
        
        for ingredientName in ingredientNames {
            if let ingredient = tryToGetIngredient(withName: ingredientName) {
                ingredient.addToMeals(meal)
            } else {
                let ingredient = Ingredient(context: persistentContainer.viewContext)
                ingredient.name = ingredientName
                ingredient.addToMeals(meal)
                ingredient.isOwned = false
            }
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("error")
        }
    }
}
