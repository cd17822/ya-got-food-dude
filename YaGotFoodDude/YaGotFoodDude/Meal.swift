//
//  Meal.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/27/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation
import CoreData

extension Meal {
    var neededIngredients: [Ingredient] {
        var needed = [Ingredient]()
        for ingredientAsAny in ingredients! {
            let ingredient = ingredientAsAny as! Ingredient
            if !ingredient.isOwned {
                needed.append(ingredient)
            }
        }
        return needed
    }
}
