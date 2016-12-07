//
//  MainViewController.swift
//  KCSliderViewController
//
//  Created by liaozhenming on 2016/12/1.
//  Copyright © 2016年 liaozhenming. All rights reserved.
//

import UIKit

class MainViewController: KCSideViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController")
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController")
        
//        self.cornerRadiusEnable = true
        self.shadowEnable = true
        self.kc_setViewControllers(rootViewController: rootViewController, leftViewController: leftViewController, rightViewController: nil)
        
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

}
