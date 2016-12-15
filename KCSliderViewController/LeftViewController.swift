//
//  LeftViewController.swift
//  KCSliderViewController
//
//  Created by liaozhenming on 2016/12/1.
//  Copyright © 2016年 liaozhenming. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tab_function: UITableView!
    
    var arr_functionList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arr_functionList = ["产品设置","用户管理","角色管理","修改密码","店铺通知","皮肤更换"]
        
        var tableHeaderView = UIView.init(frame: CGRect(x:0,y:0,width:tab_function.bounds.width, height:180))
        tableHeaderView.backgroundColor = UIColor.yellow
        tab_function.tableHeaderView = tableHeaderView
        tab_function.rowHeight = 60.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_functionList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "123456")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "123456")
        }
        
        let title = arr_functionList[indexPath.row]
        cell?.textLabel?.text = title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.kc_closeSideViewController(animate: true)
    }
}
