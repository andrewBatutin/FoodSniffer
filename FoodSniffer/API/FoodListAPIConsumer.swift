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


enum FoodAPIError:Error{
    case SomeError
}

class FoodListAPIConsumer{
    
    let foodListURL = "https://www.dropbox.com/s/8ipgua5mfiakhxy/MockFoodListJSON.json?dl=1"
    let session = URLSession(configuration: .default)
    
    
    func loadFoodList(_ callback: @escaping ( [FoodItem]? ) -> ()){
        
        guard let foodUrl = URL(string: foodListURL) else { return }
        let dataTask = session.dataTask(with: foodUrl) { (data, response, error) in
            
            guard let foodData = data else {
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
            }
            
            
        }
        dataTask.resume()
        
    }
    
}

extension FoodListAPIConsumer{
    
    func mockData() -> [FoodItem]{
        return [
            FoodItem(name: "soup", consumePeriod: .morning),
            FoodItem(name: "bannana", consumePeriod: .afternoon),
            FoodItem(name: "whickey", consumePeriod: .evening)
        ]
    }
    
    func mockJSON() -> String?{
        let coder = JSONEncoder()
        coder.outputFormatting = .prettyPrinted
        if let res = try? coder.encode(self.mockData()),
            let str = String(data: res, encoding: .utf8){
            return str
        }
        return nil
    }
    
}
