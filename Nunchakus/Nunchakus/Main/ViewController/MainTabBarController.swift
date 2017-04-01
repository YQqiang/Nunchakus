//
//  MainTabBarController.swift
//  Nunchakus
//
//  Created by kjlink on 2017/3/21.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        let teach = TeachingViewController()
        let selfie = SelfieViewController()
        let stage = StageViewController()
        addChildController(title: "教学", imageName: "tabbar-teach", viewController: teach)
        addChildController(title: "自拍", imageName: "tabbar-selfie", viewController: selfie)
        addChildController(title: "舞台", imageName: "tabbar-stage", viewController: stage)
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

// MARK:- private func 
extension MainTabBarController {
    fileprivate func addChildController(title: String, imageName: String, viewController: UIViewController) {
        viewController.title = title
        viewController.tabBarItem.image = UIImage(named: imageName)
        viewController.tabBarItem.selectedImage = UIImage(named: imageName + "-selected")?.image(UIColor.globalColor())
        let nav = BaseNavigationController(rootViewController: viewController)
        addChildViewController(nav)
    }
}
