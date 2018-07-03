//
//  ViewController.swift
//  FoodSniffer
//
//  Created by andrew batutin on 7/3/18.
//  Copyright © 2018 HomeOfRisingSun. All rights reserved.
//

import UIKit

class FoodListViewController: UIViewController {
    
    
    @IBOutlet weak var foodList: UITableView!
    
    var foodItems:[FoodItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let c = FoodListAPIConsumer.init()
        c.loadFoodList { (food) in
            if let items = food{
                self.foodItems = self.filter(foodItems: items, by: Date())
                self.foodList.reloadData()
            }
        }
        
        print( dateIntervals() )
        
    }

}

extension FoodListViewController: UITableViewDelegate{
    
}

extension FoodListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.foodList.dequeueReusableCell(withIdentifier: "food_cell_id")!
        if let item = self.foodItems?[indexPath.row] {
            cell.textLabel?.text = item.name
        }
        return cell
    }
    
}

extension FoodListViewController{
    
    
    func dateIntervals() -> [DaySegments:DateInterval]{
        
        guard let morning = DateInterval(from: "08:00-13:00") else { fatalError() }
        guard let aftrenoon = DateInterval(from: "13:00-18:00") else { fatalError() }
        guard let evening = DateInterval(from: "18:00-08:00") else { fatalError() }
        
        return [
            DaySegments.morning : morning,
            DaySegments.afternoon : aftrenoon,
            DaySegments.evening : evening
        ]
        
    }
    
    
    func filter(foodItems items:[FoodItem], by date:Date) -> [FoodItem]{
        
        
        return items.filter { (item) -> Bool in
            if let inteval = dateIntervals()[item.consumePeriod]{
                return inteval.contains(date)
            }
            return false
        }
        
    }
    
}
