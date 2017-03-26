//
//  DataGetter.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/24/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation
import CoreData

class DataGetter {
    static let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    public static func getMeals(callback: ((_ meals: [NSManagedObject], _ error: NSError?) -> Void)) {
        print("boutta request")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
        // request.sortDescriptors = [NSSortDescriptor(key: "weekStart", ascending: true)] // [0] is oldest
        print(request)
        do {
            callback([], nil)
//            print("boutta get meals")
//            let meals = try context.fetch(request)
//            print(meals)
//            print("meals^")
//            callback(meals as! [NSManagedObject], nil)
        } catch let error as NSError {
            callback([], error)
        }
    }
}
