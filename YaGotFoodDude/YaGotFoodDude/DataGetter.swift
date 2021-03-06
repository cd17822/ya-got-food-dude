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
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YaGotFoodDude")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    public static func getMeals(callback: ((_ meals: [Meal], _ error: NSError?) -> Void)) {
        let request = NSFetchRequest<Meal>(entityName: "Meal")

        do {
            let meals = try persistentContainer.viewContext.fetch(request)
            callback(meals, nil)
        } catch let error as NSError {
            callback([], error)
        }
    }
    
    public static func getIngredients(callback: ((_ ingredients: [Ingredient], _ error: NSError?) -> Void)) {
        let request = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        
        do {
            let ingredients = try persistentContainer.viewContext.fetch(request)
            callback(ingredients, nil)
        } catch let error as NSError {
            callback([], error)
        }
    }
    
    private static func tryToGetIngredient(withName name: String, callback: ((_ ingredient: Ingredient?, _ error: NSError?) -> Void)) {
        let request = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        request.predicate = NSPredicate(format: "name like %@", name)
        var ingredient: Ingredient?
        do {
            let ingredients = try persistentContainer.viewContext.fetch(request)
            
            if ingredients.count > 0 {
                ingredient = ingredients[0]
            }
            
            callback(ingredient, nil)
        } catch let error as NSError {
            callback(nil, error)
        }
    }
    
    public static func saveMeal(_ mealName: String, madeOf ingredientNames: [String], callback: ((_ error: NSError?) -> Void)) {
        let meal = Meal(context: persistentContainer.viewContext)
        meal.name = mealName.lowercased()
        
        for ingredientName in ingredientNames {
            tryToGetIngredient(withName: ingredientName.lowercased()) { ingredient, error in
                if ingredient != nil {
                    ingredient!.addToMeals(meal)
                } else {
                    let ingredient = Ingredient(context: persistentContainer.viewContext)
                    ingredient.name = ingredientName.lowercased()
                    ingredient.addToMeals(meal)
                    ingredient.isOwned = true
                }
            }
            print("this should happen first")
        }
        
        do {
            try persistentContainer.viewContext.save()
            print("this should happen second")
            callback(nil)
        } catch let error as NSError {
            callback(error)
        }
    }
    
    public static func toggleOwnership(on ingredient: Ingredient, _ cb: () -> ()) {
        do {
            ingredient.isOwned = !ingredient.isOwned
            try persistentContainer.viewContext.save()
            cb()
        } catch let error as NSError {
            print(error)
            cb()
        }
    }
    
    public static func delete(meals: [Meal], ingredients: [Ingredient], _ cb: () -> ()) {
        do {
            for meal in meals {
                persistentContainer.viewContext.delete(meal)
            }
            
            for ingredient in ingredients {
                persistentContainer.viewContext.delete(ingredient)
            }
            
            try persistentContainer.viewContext.save()
            
            cb()
        } catch let error as NSError {
            print(error)
            
            cb()
        }
    }
}
