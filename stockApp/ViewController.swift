//
//  ViewController.swift
//  stockApp
//
//  Created by SHCH on 19.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companyNameLabel.text = "Tinkoff FinTech Company Russia"
    }


}

