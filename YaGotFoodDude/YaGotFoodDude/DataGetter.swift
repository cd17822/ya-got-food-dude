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
    public static func getMeals(context: NSManagedObjectContext, callback:
        ((_ meals: [NSManagedObject], _ error: NSError?) -> Void)) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
        request.sortDescriptors = [NSSortDescriptor(key: "weekStart", ascending: true)] // [0] is oldest
        
        do {
            let goals = try context.fetch(request)
            callback(goals as! [NSManagedObject], nil)
        } catch let error as NSError {
            callback([], error)
        }
    }
}
