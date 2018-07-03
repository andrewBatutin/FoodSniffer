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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension FoodListViewController: UITableViewDelegate{
    
}

extension FoodListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.foodList.dequeueReusableCell(withIdentifier: "food_cell_id")!
        cell.textLabel?.text = "Test"
        return cell
    }
    
    
}
