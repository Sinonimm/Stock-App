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
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var PriceChangeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let companies: [String: String] = ["Apple":"aapl",
                                               "Microsoft":"msft",
                                               "Google":"goog",
                                               "Amazon":"amzn",
                                               "Facebook":"fb",]
    
    private func parseQuote(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else{
                print("! Invalid JSON format")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName, symbol: companySymbol, price: price, priceChange: priceChange)
            }

        }catch{
            print("! JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double){
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        self.companySymbolLabel.text = symbol
        self.PriceLabel.text = "\(price)"
        self.PriceChangeLabel.text = "\(priceChange)"
    }
    
    private func requestQuote(for symbol: String){
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?&token=pk_4d16f034d7a7446a98901a1257caee09")
                
        else {
            print("wrong URL")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else{
                print(error?.localizedDescription ?? "wrong URLSession dataTask")
                return
            }
            self.parseQuote(data: data)
        }
        
        dataTask.resume()
    }
    
    private func requestQuoteUpdate(){
        self.activityIndicator.startAnimating()
        self.companyNameLabel.text = "-"
        self.companySymbolLabel.text = "-"
        self.PriceLabel.text = "-"
        self.PriceChangeLabel.text = "-"
        
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

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
}

extension ViewController: UIPickerViewDelegate {
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activityIndicator.startAnimating()
    
        let selectedSymbol = Array(self.companies.values)[row]
        self.requestQuote(for: selectedSymbol)
    }
    
}
