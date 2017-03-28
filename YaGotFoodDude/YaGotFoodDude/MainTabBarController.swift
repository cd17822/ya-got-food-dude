//
//  MainTabBarController.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    @IBAction func addMealTapped(_ sender: Any) {
        performSegue(withIdentifier: "MainTabBarControllerToNewMealViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
