//
//  NewMealViewController.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class NewMealViewController: UIViewController {
    @IBOutlet var mealPreviewImageView: UIImageView!
    @IBOutlet var mealField: UITextField!
    @IBOutlet var ingredientsField: UITextField!
    @IBOutlet var newIngredientField: UITextField!
    var ingredientNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitReturnOnNewIngredientField(_ sender: Any) {
        if newIngredientField.text == nil || newIngredientField.text == "" {
            return
        }
        
        ingredientNames.append(newIngredientField.text!)
        
        newIngredientField.text = ""
        
        var ingredientsList = ""
        for (index, ingredient) in ingredientNames.enumerated() {
            ingredientsList += ingredient
            if index != ingredientNames.count - 1 {
                ingredientsList += ", "
            }
        }
        ingredientsField.text = ingredientsList
    }
    
    @IBAction func mealFieldEditingChanged(_ sender: Any) {
        ImageGetter.get(mealField.text ?? "") { image in
            DispatchQueue.main.async() {
                self.mealPreviewImageView.image = image
            }
        }
    }
    
    @IBAction func mealFieldEditingDidEnd(_ sender: Any) {
        mealFieldEditingChanged("") // "" acts as placeholder sender
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if mealField.text == nil || mealField.text == "" { return }
        
        if newIngredientField.text != nil && newIngredientField.text! != "" {
            ingredientNames.append(newIngredientField.text!)
        }
        
        DataGetter.saveMeal(mealField.text!, madeOf: ingredientNames) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
