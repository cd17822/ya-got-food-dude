//
//  MealViewController.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/27/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class MealViewController: UIViewController {
    @IBOutlet var ingredientsTextView: UITextView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var navigationBarTitle: UINavigationItem!
    var meal: Meal?
    var image: UIImage?
    var parentVC = UIViewController() // i wish i could just do : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpImage()
        listIngredients()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Personal
    func setUpNavBar() {
        navigationBarTitle.title = meal!.name
    }
    
    func setUpImage() {
        imgView.image = image
    }
    
    func listIngredients() {
        var ingredientsList = ""
        
        for (index, ingredientAsAny) in meal!.ingredients!.enumerated() {
            let ingredient = ingredientAsAny as! Ingredient
            ingredientsList.append(ingredient.name!.capitalized)
            if index != meal!.ingredients!.count - 1 {
                ingredientsList.append("\n")
            }
        }
        
        let attribute = NSMutableAttributedString.init(string: ingredientsList)
        for ingredientAsAny in meal!.ingredients! {
            let ingredient = ingredientAsAny as! Ingredient
            let range = (ingredientsList as NSString).range(of: ingredient.name!.capitalized)
            let ingredientColor = ingredient.isOwned ? UIColor(red:0.23, green:0.88, blue:0.67, alpha:1.00) :
                                                       UIColor(red:0.94, green:0.24, blue:0.55, alpha:1.00)
            attribute.addAttribute(NSForegroundColorAttributeName, value: ingredientColor, range: range)
        }
        
        let theWholeThing = (ingredientsList as NSString).range(of: ingredientsList)
        
        // make spacing larger
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 50.0
        paragraphStyle.maximumLineHeight = 50.0
        paragraphStyle.minimumLineHeight = 50.0
        attribute.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: theWholeThing)
        
        // reconfigure font
        attribute.addAttributes([NSFontAttributeName: UIFont(name: "Trebuchet MS", size: 24.0)!], range: theWholeThing)
        
        ingredientsTextView.attributedText = attribute
    }
    
    @IBAction func trashPressed(_ sender: Any) {
        var ingredientsToDelete = [Ingredient]()
        for ingredientAsAny in meal!.ingredients! {
            let ingredient = ingredientAsAny as!Ingredient
            if ingredient.meals!.count == 1 {
                ingredientsToDelete.append(ingredient)
            }
        }
        
        DataGetter.delete(meals: [meal!], ingredients: ingredientsToDelete) {
            print(self.navigationController?.popViewController(animated: true))
        }
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
