//
//  FoodListAPIConsumer.swift
//  FoodSniffer
//
//  Created by andrew batutin on 7/3/18.
//  Copyright © 2018 HomeOfRisingSun. All rights reserved.
//

import Foundation

enum DaySegments:String,Codable{
    
    case morning
    case afternoon
    case evening
    
}

struct FoodItem:Codable {
    
    let name:String
    let consumePeriod:DaySegments
    
}

@objc
final class FoodListAPIConsumer : NSObject, URLSessionDelegate{
    
    
    let foodListURL = "https://www.dropbox.com/s/8ipgua5mfiakhxy/MockFoodListJSON.json?dl=1"
    
    
    func loadFoodList(_ callback: @escaping ( [FoodItem]? ) -> ()){
        
        guard let foodUrl = URL(string: foodListURL) else { return }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: foodUrl) { (data, response, error) in
            
            if let networkError = error {
                print(networkError.localizedDescription)
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            
            guard let foodData = data else {
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let items = try decoder.decode([FoodItem].self, from: foodData)
                DispatchQueue.main.async {
                    callback(items)
                }
            }catch{
                print(error)
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            
        }
        dataTask.resume()
        
    }
    
}
