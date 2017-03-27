//
//  MealTableViewController.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/24/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit
import CoreData

class MealTableViewController: UITableViewController {
    var meals = [Meal]()
    var photos = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchMeals() {
            self.tableView.reloadData()
            self.downloadPhotos()
        }
        (navigationController!.navigationBar.items![0]).title = "Meals"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Personal
    
    func registerNib() {
        tableView.register(UINib(nibName: "MealTableViewCell", bundle: nil), forCellReuseIdentifier: "MealTableViewCell")
    }
    
    func downloadPhotos() {
        for _ in meals {
            photos.append(nil) // we dont like race conditions!
        }
        
        for (index, meal) in meals.enumerated() {
            ImageGetter.get(meal.name!, cb: { image in
                self.photos[index] = image ?? #imageLiteral(resourceName: "food")
            })
        }
    }
    
    func fetchMeals(_ cb: @escaping () -> ()) {
        DataGetter.getMeals { meals, error in
            self.meals.removeAll()
            for meal in meals {
                if meal.neededIngredients.count == 0 { // if meal is owned
                    self.meals.append(meal)
                } else {
                    self.meals.insert(meal, at: 0)
                }
            }
            cb()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as! MealTableViewCell
        let meal = meals[indexPath.row]
        
        DispatchQueue.main.async() {
            var counter = 0
            while self.photos[indexPath.row] == nil && indexPath.row < 10 && counter < 100000 { // < 10 because the others aren't immediately visible
                counter += 1
            }
            cell.imgView.image = self.photos[indexPath.row]
        }
        
        cell.meal.text = meal.name!.capitalized
        
        var ingredientsList = ""
        var neededIngredients = [Ingredient]()
        for ingredientAsAny in meal.ingredients! {
            let ingredient = ingredientAsAny as! Ingredient
            if !(ingredient).isOwned {
                neededIngredients.append(ingredient)
            }
        }
        
        if neededIngredients.count == 0 {
            cell.ingredients.text = "You have all ingredients needed!"
        } else {
            cell.meal.textColor = UIColor(red:0.94, green:0.24, blue:0.55, alpha:1.00)
            
            for (index, ingredient) in neededIngredients.enumerated() {
                ingredientsList += (ingredient).name!.capitalized
                if index != neededIngredients.count - 1 {
                    ingredientsList += ", "
                }
            }
            cell.ingredients.text = "Need: \(ingredientsList)"
        }
        
        cell.arrowImageView.isHidden = false
        cell.haveItTextView.isHidden = true
        cell.ingredients.frame.insetBy(dx: 20, dy: 0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
