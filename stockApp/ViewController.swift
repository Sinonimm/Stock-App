//
//  ViewController.swift
//  stockApp
//
//  Created by SHCH on 19.02.2022.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let companies: [String: String] = ["Apple":"AAPL",
                                               "Microsoft":"MSFT",
                                               "Google":"GOOG",
                                               "Amazon":"AMZN",
                                               "Facebook":"FB",]
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companyNameLabel.text = "Tinkoff"
        
        self.companyPickerView.dataSource = self
        self.companyPickerView.delegate = self
    }


}

