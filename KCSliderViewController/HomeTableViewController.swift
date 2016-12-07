//
//  HomeTableViewController.swift
//  KCSliderViewController
//
//  Created by liaozhenming on 2016/12/2.
//  Copyright © 2016年 liaozhenming. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var arr_functionList: [String] = []
    
    var arr_dictionary:[Dictionary <String,String>] = []
    
    var test_dictionary:[Dictionary <String,NSInteger>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dic1: Dictionary <String,String> = ["name":"haha1","sex":"1","age":"11"]
        let dic2: Dictionary <String,String> = ["name":"haha2","sex":"1","age":"11"]
        let dic3: Dictionary <String,String> = ["name":"haha3","sex":"1","age":"11"]
        let dic4: Dictionary <String,String> = ["name":"haha4","sex":"1","age":"11"]
        let dic5: Dictionary <String,String> = ["name":"haha5","sex":"1","age":"11"]
        let dic6: Dictionary <String,String> = ["name":"haha6","sex":"1","age":"11"]
        arr_dictionary = [dic1,dic2,dic3,dic4,dic5,dic6]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_dictionary.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "123456")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "123456")
        }
        
//        let title = arr_functionList[indexPath.row]
//        cell?.textLabel?.text = title
        
        let dic: Dictionary<String,String> = arr_dictionary[indexPath.row]
        let value: String = dic["name"] as String!
        cell?.textLabel?.text = value
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.kc_closeSideViewController(animate: true)
        
        self.kc_openSideViewController(left: true)
    }
}
