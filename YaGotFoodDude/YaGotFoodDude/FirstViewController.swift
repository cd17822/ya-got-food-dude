//
//  FirstViewController.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/24/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet var testiv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ImageGetter.get("milk", testiv) { image in
            DispatchQueue.main.async() {
                
                //self.testiv.frame = CGRect(x: self.view.frame.width/2-25, y: self.view.frame.height/2-25, width: 50, height: 50)
                self.testiv.image = image
                self.view.addSubview(self.testiv)
            }
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

