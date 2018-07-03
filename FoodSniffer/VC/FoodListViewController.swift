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
                self.foodItems = items
                self.foodList.reloadData()
            }
        }
        
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
