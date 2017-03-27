//
//  IngredientTableViewController.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class IngredientTableViewController: UITableViewController {
    var ingredients = [Ingredient]()
    var photos = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchIngredients() {
            self.tableView.reloadData()
            self.downloadPhotos()
        }
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
        for _ in ingredients {
            photos.append(nil) // we dont like race conditions!
        }
        
        for (index, ingredient) in ingredients.enumerated() {
            ImageGetter.get(ingredient.name!, cb: { image in
                self.photos[index] = image ?? #imageLiteral(resourceName: "food")
            })
        }
    }
    
    func fetchIngredients(_ cb: () -> ()) {
        DataGetter.getIngredients { ingredients, error in
            self.ingredients = ingredients
            cb()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as! MealTableViewCell
        let ingredient = ingredients[indexPath.row]
        
        DispatchQueue.main.async() {
            while self.photos[indexPath.row] == nil {
                    // wait for a pic to be there!
            }
            cell.imgView.image = self.photos[indexPath.row]
        }
        
        cell.meal.text = ingredient.name!.capitalized
        
        var mealsList = "For: "
        for (index, meal) in ingredient.meals!.enumerated() {
            mealsList += (meal as! Meal).name!.capitalized
            if index != ingredient.meals!.count - 1 {
                mealsList += ", "
            }
        }
        cell.ingredients.text = mealsList
        
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