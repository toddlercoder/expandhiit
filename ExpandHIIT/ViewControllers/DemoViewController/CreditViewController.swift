//
//  CreditViewController.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/10/18.
//  Copyright © 2018 Melody Song. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "General"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Actions
    
    @IBAction func ramotionTriggered(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://github.com/Ramotion/swift-ui-animation-components-and-libraries")!)
    }
    
    @IBAction func freesoundTriggered(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://freesound.org")!)
    }
    
    @IBAction func pixabayTriggered(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://pixabay.com")!)
    }
    
    @IBAction func JRDTriggered(_ sender: UIButton) {
        let JRDChannelID = "UCmYew1VwdbpHnSFG-CQ1A-A"
        var url = URL(string: "youtube://\(JRDChannelID)")!
        if !(UIApplication.shared.canOpenURL(url)) {
            url = URL(string: "https://www.youtube.com/channel/UCmYew1VwdbpHnSFG-CQ1A-A")!
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction func donationTriggered(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.paypal.me/melodyneedsmoney")!)
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
