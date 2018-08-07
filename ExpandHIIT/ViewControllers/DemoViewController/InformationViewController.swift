//
//  InformationViewController.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/10/18.
//  Copyright © 2018 Melody Song. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Information"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hiitTriggered(_ sender: UIButton) {
        let url = URL(string: "https://dailyburn.com/life/fitness/high-intensity-hiit-workout/")!
        UIApplication.shared.open(url)
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
