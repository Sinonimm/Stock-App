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
    
    
    
    private func parseQuote(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String
            else{
                print("! Invalid JSON format")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName)
            }

        }catch{
            print("! JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String){
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
    }
    
    
    private func requestQuote(for symbol: String){
        let url = URL(string:"https://cloud.iexapis.com/stable/stock/\(symbol)/quote")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else{
                print("! Network error")
                return
            }
            self.parseQuote(data: data)
        }
        
        dataTask.resume()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activityIndicator.startAnimating()
        
        let selectedSymbol = Array(self.companies.values)[row]
        self.requestQuote(for: selectedSymbol)
    }
    
    private func requestQuoteUpdate(){
        self.activityIndicator.startAnimating()
        
        let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
        let selctedSymbol = Array(self.companies.values)[selectedRow]
        self.requestQuote(for: selctedSymbol)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companyPickerView.dataSource = self
        self.companyPickerView.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.requestQuoteUpdate()
    }


}

