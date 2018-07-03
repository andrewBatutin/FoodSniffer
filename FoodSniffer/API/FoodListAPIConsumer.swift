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

@objc
class FoodListAPIConsumer : NSObject, URLSessionDelegate{
    
    let certificates: [Data] = {
        let url = Bundle.main.url(forResource: "wwwdropboxcom", withExtension: "crt")!
        let data = try! Data(contentsOf: url)
        return [data]
    }()
    
    let foodListURL = "https://www.dropbox.com/s/8ipgua5mfiakhxy/MockFoodListJSON.json?dl=1"
    
    
    
    func loadFoodList(_ callback: @escaping ( [FoodItem]? ) -> ()){
        
        guard let foodUrl = URL(string: foodListURL) else { return }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let dataTask = session.dataTask(with: foodUrl) { (data, response, error) in
            
            if error !=  nil {
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            
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

extension FoodListAPIConsumer {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 {
            
            if let certificate = SecTrustGetCertificateAtIndex(trust, 0) {
                let data = SecCertificateCopyData(certificate) as Data
                if certificates.contains(data) {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                    return
                }
            }
        }
        completionHandler(.rejectProtectionSpace, nil)
    }
}
